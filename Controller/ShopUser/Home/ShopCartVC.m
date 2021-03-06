//
//  ShopCartVC.m
//  DPH
//
//  Created by cym on 16/1/26.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "ShopCartVC.h"
#import <MJRefresh/MJRefresh.h>
#import "ShopCartProCell.h"
#import "ShopCartSQL.h"
#import "CheckOrderVC.h"

@interface ShopCartVC ()<UITextFieldDelegate>

@property (nonatomic, strong)NSMutableArray * productArr;
@property (nonatomic , strong)NSMutableArray * cellArr;

@end

@implementation ShopCartVC


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initData];
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTotalView) name:@"reloadBottomView" object:nil];

}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
////    [self initTable];
//    [self initData];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTotalView) name:@"reloadBottomView" object:nil];
//}

-(void)initData
{
    self.productArr = [[NSMutableArray alloc]init];
    self.cellArr = [NSMutableArray array];
    
    self.productArr = [ShopCartSQL readShopCart];
}

//-(void)initTable
//{
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self.tableView.mj_header endRefreshing];
//    }];
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [self.tableView.mj_footer endRefreshing];
//    }];
//    
//    [self.tableView.mj_header beginRefreshing];
//    
//}

- (IBAction)confirmOrderAction:(id)sender {
    
    if (self.productArr.count == 0) {
        [self showCommonHUD:@"请选购商品!"];
        return;
    }
    else
    {
       [self performSegueWithIdentifier:@"toCheckOrder" sender:nil];
    }
}


//刷新总价和数量

-(void)reloadTotalView
{
    NSLog(@"%lu",(unsigned long)self.productArr.count);
    int num = (int)self.productArr.count;

    self.proNumLab.text = [NSString stringWithFormat:@"%d",num];
    float totlePrice = 0;
    
    for (ShopCartProCell * cell in _cellArr) {
        
        float sPrice = [cell.proPriceLab.text floatValue];
        float price = sPrice * [cell.numTF.text intValue];
        totlePrice +=price;
    }
    
    self.totalePriceLab.text = [NSString stringWithFormat:@"%0.2lf",totlePrice];
}


 
 -(void)changeSqlDataByCell:(ShopCartProCell *)cell
 {
     cell.modelProduct.qty = cell.numTF.text;
     NSDictionary * modelDic = [AppUtils getObjectData:cell.modelProduct];
     [ShopCartSQL saveToShopCart:modelDic withId:cell.modelProduct.productId];
 
 }


//点击加号
-(void)addNum:(UIButton *)button
{
    ShopCartProCell * thisCell = (ShopCartProCell *)[[button superview]superview];
    
    int i = [thisCell.numTF.text intValue];
    i = i+1;
    thisCell.numTF.text = [NSString stringWithFormat:@"%d",i];
    thisCell.cutBtn.enabled = YES;
    
    [self changeSqlDataByCell:thisCell];
    
    [self reloadTotalView];
    
}
//点击减号
-(void)cutNum:(UIButton *)button
{
    ShopCartProCell * thisCell = (ShopCartProCell *)[[button superview]superview];
    
    int i = [thisCell.numTF.text intValue];
    if (i == 1||[thisCell.numTF.text isEqualToString:@""]) {
        return;
    }
    i = i-1;
    thisCell.numTF.text = [NSString stringWithFormat:@"%d",i];
    if (i == 1) {
        thisCell.cutBtn.enabled = NO;
    }
    
    [self changeSqlDataByCell:thisCell];
    
    [self reloadTotalView];
    
}

-(void)deleteProAction:(id)sender
{
    UIButton *delectBtn = (UIButton *)sender;
    ShopCartProCell *cell = (ShopCartProCell *)[[delectBtn superview] superview] ;
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



#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.productArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndentifier = @"cellIndentifier";
    ShopCartProCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        NSArray * nibArr = [[NSBundle mainBundle]loadNibNamed:@"ShopCartProCell" owner:self options:nil];
        cell = nibArr[0];
        
    }
    [cell.cutBtn addTarget:self action:@selector(cutNum:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addBtn addTarget:self action:@selector(addNum:) forControlEvents:UIControlEventTouchUpInside];
    cell.numTF.delegate = self;

    cell.modelProduct = self.productArr[indexPath.row];
//    cell.numLab.hidden = YES;
    cell.numTF.delegate = self;
    [self.cellArr addObject:cell];
    
    [cell.deleteBtn addTarget:self action:@selector(deleteProAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (indexPath.row == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row) {
        [self reloadTotalView];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
//    [self performSegueWithIdentifier:@"toProDetail" sender:nil];
    
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row) {
        [self reloadTotalView];
    }

}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"修改数量" message:@"请输入要修改的数量" preferredStyle:UIAlertControllerStyleAlert];
//    
//    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull secondTextField) {
//    
//        secondTextField.text = textField.text;
//        secondTextField.keyboardType = UIKeyboardTypeNumberPad;
//    }];
//    
//    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        ShopCartProCell *cell = (ShopCartProCell *)[[textField superview] superview] ;
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//        
//        ModelProduct * model = self.productArr[indexPath.row];
//        if ([alert.textFields.firstObject.text isEqualToString:@"0"]) {
//            UIAlertController * al = [UIAlertController alertControllerWithTitle:@"删除商品" message:@"您确定要删除所选的商品?" preferredStyle:UIAlertControllerStyleAlert];
//            
//            [al addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
////                ShopCartProCell *cell = (ShopCartProCell *)[[textField superview] superview] ;
////                NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
////                
////                ModelProduct * model = self.productArr[indexPath.row];
//                [ShopCartSQL removeProductById:model.productId];
//                [self.productArr removeObjectAtIndex:indexPath.row];
//                
//                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                                      withRowAnimation:UITableViewRowAnimationLeft];
//                [self.cellArr removeAllObjects];
//                [self.tableView reloadData];
////                [self reloadTotalView];
//
//                
//            }]];
//            [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//            }]];
//            [self presentViewController:al animated:YES completion:nil];
//        }
//        else
//        {
//            textField.text =  alert.textFields.firstObject.text;
//            model.qty = alert.textFields.firstObject.text;
//             NSDictionary * modelDic = [AppUtils getObjectData:model];
//            [ShopCartSQL saveToShopCart:modelDic withId:model.productId];
//            
//            
//        }
//        [self reloadTotalView];
//        
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//    }]];
//    
//    [self presentViewController:alert animated:YES completion:nil];
//
//    
//    return YES;
//}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //如果用户输入“0”或则为空，默认改为“1”
    if ([textField.text isEqualToString:@""]||[textField.text isEqualToString:@"0"])
    {
        textField.text = @"1";
    }
    
    ShopCartProCell * thisCell = (ShopCartProCell *)[[textField superview]superview];
    
    [self changeSqlDataByCell:thisCell];
    
    [self reloadTotalView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toCheckOrder"]) {
        CheckOrderVC * view = [[CheckOrderVC alloc]init];
        view = segue.destinationViewController;
        view.orderPrice = self.totalePriceLab.text;
        view.num = self.proNumLab.text;
        view.totalPrice = self.totalePriceLab.text;
        view.productArr = self.productArr;
    }
    
}


@end
