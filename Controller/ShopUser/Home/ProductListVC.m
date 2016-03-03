//
//  ProductListVC.m
//  DPH
//
//  Created by cym on 16/1/28.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "ProductListVC.h"
#import "ShopCartSQL.h"
#import "EditProductListCell.h"
#import "ModelFullStorage.h"
#import "CheckOrderVC.h"

@interface ProductListVC ()<UITextFieldDelegate>
{
    BOOL isPass;
}

@property (weak, nonatomic) IBOutlet UIView *tipsView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTop;

@property (nonatomic, strong)NSMutableArray * productArr;
@property (nonatomic, strong)NSMutableArray * cellArr;

@end

@implementation ProductListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.isTest) {
        self.tipsView.hidden = YES;
        self.tableViewTop.constant = 0;
    }
    isPass = !self.isTest;
    
    [self initData];
}

-(void)initData
{
    self.productArr = [[NSMutableArray alloc]init];
    self.cellArr = [NSMutableArray array];
    
    self.productArr = [ShopCartSQL readShopCart];
}


//点击确定后 更新本地数据
- (IBAction)finishAction:(id)sender {
    
    isPass = YES;
    //检测错误的商品是否修改正确
    
    for (ModelFullStorage * model in self.errorArr) {
        
        for (EditProductListCell * cell in self.cellArr) {
            cell.isError = NO;
            if ([model.productId isEqualToString:cell.modelProduct.productId]) {
                
                if ([cell.numTF.text intValue] > [model.storage intValue] ) {
                    cell.isError = YES;
                    isPass = NO;
                }
            }

        }

    }
    [self.tableView reloadData];
    self.tipsView.hidden = isPass;
    self.tableViewTop.constant = 0;
    
    if (isPass) {
        [AppUtils showAlert:@"提示" message:@"确认保存修改?" objectSelf:self defaultAction:^(id result) {
            for (ModelProduct * thisModel in self.productArr) {
                NSDictionary * modelDic = [AppUtils getObjectData:thisModel];
                [ShopCartSQL saveToShopCart:modelDic withId:thisModel.productId];
            }
            
            //把修改后的数据回传到上一个页面
            
            CheckOrderVC * checkVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
            checkVC.orderPrice = self.totalPriceLab.text;
            checkVC.num = self.numLab.text;
            checkVC.totalPrice = self.totalPriceLab.text;
            checkVC.productArr = self.productArr;

            [self.navigationController popToViewController:checkVC animated:YES];
            
        } cancelAction:^(id result) {
            
        }];

    }
    else
    {
        [self showCommonHUD:@"cccccccccc"];
    }
    
}

/*
 *  只要修改了数量就修改本地数据（暂时不用）
 *
 
-(void)changeSqlDataByCell:(EditProductListCell *)cell
{
    cell.modelProduct.qty = cell.numTF.text;
    NSDictionary * modelDic = [AppUtils getObjectData:cell.modelProduct];
    [ShopCartSQL saveToShopCart:modelDic withId:cell.modelProduct.productId];
}
 */


//刷新底部view上的数据

-(void)reloadTotalView
{
    int num = (int)self.productArr.count;
    
    self.numLab.text = [NSString stringWithFormat:@"%d",num];
    float totlePrice = 0;
    
    for (EditProductListCell * cell in _cellArr) {
        
        float sPrice = [cell.priceLab.text floatValue];
        float price = sPrice * [cell.numTF.text intValue];
        NSLog(@"%@",cell.numTF.text);
        totlePrice +=price;
    }
    
    self.totalPriceLab.text = [NSString stringWithFormat:@"%0.2lf",totlePrice];
}


//根据情况决定cell的显示

-(void)loadCell:(EditProductListCell *)cell
{
    cell.attentionImgView.hidden = !(self.isTest && cell.isError);
    cell.noEditView.hidden = self.isTest && cell.isError;
    cell.editView.hidden = !(self.isTest && cell.isError);
    cell.storageTitleLab.hidden = !(self.isTest && cell.isError);
    cell.storageNumLab.hidden = !(self.isTest && cell.isError);
    cell.deleteBtn.hidden = !(self.isTest && cell.isError);
}

//点击加号
-(void)addNum:(UIButton *)button
{
    EditProductListCell * thisCell = (EditProductListCell *)[[[button superview]superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:thisCell];
    
    
    int i = [thisCell.numTF.text intValue];
    i = i+1;
    thisCell.numTF.text = [NSString stringWithFormat:@"%d",i];
    thisCell.numStr = thisCell.numTF.text;
    thisCell.cutBtn.enabled = YES;
    
    thisCell.modelProduct.qty = thisCell.numTF.text;
    [self.productArr replaceObjectAtIndex:indexPath.row withObject:thisCell.modelProduct];
//    [self changeSqlDataByCell:thisCell];
    
    [self reloadTotalView];

}
//点击减号
-(void)cutNum:(UIButton *)button
{
    EditProductListCell * thisCell = (EditProductListCell *)[[[button superview]superview]superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:thisCell];

    
    int i = [thisCell.numTF.text intValue];
    if (i == 1||[thisCell.numTF.text isEqualToString:@""]) {
        return;
    }
    i = i-1;
    thisCell.numTF.text = [NSString stringWithFormat:@"%d",i];
    thisCell.numStr = thisCell.numTF.text;
    if (i == 1) {
        thisCell.cutBtn.enabled = NO;
    }
    thisCell.modelProduct.qty = thisCell.numTF.text;
    [self.productArr replaceObjectAtIndex:indexPath.row withObject:thisCell.modelProduct];
    
//    [self changeSqlDataByCell:thisCell];
    
    [self reloadTotalView];

}


-(void)deleteProAction:(id)sender
{
    UIButton *delectBtn = (UIButton *)sender;
    EditProductListCell *cell = (EditProductListCell *)[[delectBtn superview] superview] ;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    [AppUtils showAlert:@"删除商品" message:@"您确定要删除所选的商品?" objectSelf:self defaultAction:^(id result) {
        ModelProduct * model = self.productArr[indexPath.row];
        [ShopCartSQL removeProductById:model.productId];
        NSString * str = [UserDefaultUtils valueWithKey:@"badgeValue"];
        int i = [str intValue];
        i = i-1;
        [UserDefaultUtils saveValue:[NSString stringWithFormat:@"%d",i] forKey:@"badgeValue"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"badgeValueNotification" object:nil];
        
        
        [self.productArr removeObjectAtIndex:indexPath.row];
        
        //    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationLeft];
        [self.cellArr removeAllObjects];
        [self.tableView reloadData];
        [self reloadTotalView];
        
        
    } cancelAction:^(id result) {
        
    }];
}


#pragma marks - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.productArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EditProductListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"editProductListCell"];
    if (!cell) {
        NSArray * nibArr = [[NSBundle mainBundle]loadNibNamed:@"EditProductListCell" owner:self options:nil];
        cell = nibArr[0];
    }

    cell.modelProduct = self.productArr[indexPath.row];
    cell.isError = NO;
    
    //找到商品清单中存在于错误数组中的商品，显示错误标志
    
    for (ModelFullStorage * model in self.errorArr) {
        if ([model.productId isEqualToString:cell.modelProduct.productId]) {
            
            if ([cell.numTF.text intValue] > [model.storage intValue] ) {
                cell.storageNumLab.text = model.storage;
                cell.isError = YES;
                isPass = NO;
                break;
            }

        }
    }
    
    [self loadCell:cell];
    [cell.cutBtn addTarget:self action:@selector(cutNum:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addBtn addTarget:self action:@selector(addNum:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteBtn addTarget:self action:@selector(deleteProAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.numTF.delegate = self;
    
    [self.cellArr addObject:cell];
    
    if (indexPath.row == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row) {
        [self reloadTotalView];
    }

    return cell;
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //如果用户输入“0”或则为空，默认改为“1”
    if ([textField.text isEqualToString:@""]||[textField.text isEqualToString:@"0"])
    {
        textField.text = @"1";
    }
    
    //用户修改数据后，修改数组中对应的值，便于确定时刷新列表
    
    EditProductListCell * thisCell = (EditProductListCell *)[[[textField superview]superview]superview];

    NSIndexPath * indexPath = [self.tableView indexPathForCell:thisCell];
    thisCell.modelProduct.qty = textField.text;
    [self.productArr replaceObjectAtIndex:indexPath.row withObject:thisCell.modelProduct];
//    [self changeSqlDataByCell:thisCell];

    [self reloadTotalView];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
