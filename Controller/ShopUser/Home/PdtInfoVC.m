//
//  PdtInfoVC.m
//  DPH
//
//  Created by cym on 16/1/26.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PdtInfoVC.h"
#import "ProductInfoCell.h"
#import "ProIntroduceCell.h"
#import "UIBarButtonItem+Badge.h"
#import "Cym_PHD.h"
#import "ProductSizeCollectCell.h"
#import "NetworkHome.h"
#import "ModelProduct.h"
#import <UIImageView+WebCache.h>
#import "ModelSpecification.h"
#import "ModelSpfctionValue.h"
#import "ShopCartSQL.h"
#import "ShopCartVC.h"

@interface PdtInfoVC ()
{
    NSString * size;
    NSString * badgeValue;
}

@property (nonatomic, strong)ModelProduct * modelProduct;
@property (nonatomic, strong)ModelSpecification * modelSpecification;
@property (nonatomic, strong)ModelSpfctionValue * modelSpfctionValue;
@property (nonatomic, strong)NSMutableArray * specificationArr;

@end

@implementation PdtInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self getproductInfo];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(detailChangeBadgeValue) name:@"badgeValueNotification" object:nil];
    badgeValue = [UserDefaultUtils valueWithKey:@"badgeValue"];
    UIBarButtonItem *navRightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shopCart_ico"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(toShopCart:)];
    self.navigationItem.rightBarButtonItem = navRightButton;
    self.navigationItem.rightBarButtonItem.badgeValue = badgeValue;
    self.navigationItem.rightBarButtonItem.badgeBGColor = [UIColor redColor];

    
}

-(void)initData
{
    self.specificationArr = [NSMutableArray array];
    size = [NSString string];
}

-(void)detailChangeBadgeValue
{
    NSString * str = [UserDefaultUtils valueWithKey:@"badgeValue"];
//    int i = [str intValue];
//    i = i+1;
//    [UserDefaultUtils saveValue:[NSString stringWithFormat:@"%d",i] forKey:@"badgeValue"];
    self.navigationItem.rightBarButtonItem.badgeValue = str;
    
}

-(void)toShopCart:(id)sender
{
    [UserDefaultUtils saveValue:@"0" forKey:@"badgeValue"];
    self.navigationItem.rightBarButtonItem.badgeValue = @"0";
    ShopCartVC * view = [[UIStoryboard storyboardWithName:@"Home" bundle:nil]instantiateViewControllerWithIdentifier:@"ShopCartVC" ];

    [self.navigationController pushViewController:view animated:YES];

}


-(void)getproductInfo
{
    [self showDownloadsHUD:@"加载中..."];
    [[NetworkHome sharedManager]getproductInfoByProId:self.productId
                                            partnerId:[UserDefaultUtils valueWithKey:@"partnerId"] userId:[UserDefaultUtils valueWithKey:@"userId"]
                                              success:^(id result) {
                                                  self.modelProduct = [ModelProduct yy_modelWithDictionary:result];
                                                  if (self.modelProduct.data.count>0) {
                                                      self.modelSpecification = self.modelProduct.data[0];
                                                  }
                                                  [self.tableView reloadData];
                                                  [self dismissHUD];
                                              }
                                              failure:^(id result) {
                                                  [self showCommonHUD:result];
                                              }];
}

-(void)collectAction:(id)sender
{
    BOOL isDelete;
    UIButton *collectBtn = (UIButton *)sender;
    if (collectBtn.isSelected) {
        isDelete = YES;
    }
    else
    {
        isDelete = NO;
    }

    [[NetworkHome sharedManager]collectProductByUserId:[UserDefaultUtils valueWithKey:@"userId"]
                                             productId:self.modelProduct.productId isDelete:isDelete
     
                                               success:^(id result) {
                                                   collectBtn.selected = !collectBtn.selected;
                                                   
                                               }
                                               failure:^(id result) {
                                                   [self showCommonHUD:result];
                                                   
                                               }];

}

- (IBAction)addToShopCartAction:(id)sender {
    
    NSIndexPath * index = [NSIndexPath indexPathForRow:1 inSection:0];
    ProductInfoCell * thisCell = [self.tableView cellForRowAtIndexPath:index];
//    if ([size isEqualToString:@""]) {
//        [self showCommonHUD:@"请选择一种规格!"];
//        return;
//    }
    if ([thisCell.numTF.text isEqualToString:@""]||[thisCell.numTF.text isEqualToString:@"0"]) {
        [self showCommonHUD:@"请选择数量!"];
        return;
    }
    NSLog(@"加入购物车");
    
    
    
    ModelProduct * thisPro = [ModelProduct yy_modelWithDictionary:[ShopCartSQL getObjectById:self.modelProduct.productId]];
    if (thisPro) {
        NSLog(@"存在");
        int numValue = [thisCell.numTF.text intValue];
        numValue += [thisPro.qty intValue];
        self.modelProduct.qty = [NSString stringWithFormat:@"%d",numValue];
    }
    else
    {
        NSLog(@"不存在");
        self.modelProduct.qty = thisCell.numTF.text;
        NSString * str = [UserDefaultUtils valueWithKey:@"badgeValue"];
        int i = [str intValue];
        i = i+1;
        [UserDefaultUtils saveValue:[NSString stringWithFormat:@"%d",i] forKey:@"badgeValue"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"badgeValueNotification" object:nil];
    }
    NSDictionary * modelDic = [AppUtils getObjectData:self.modelProduct];
    NSLog(@"%@",modelDic);
    
    [ShopCartSQL saveToShopCart:modelDic withId:self.modelProduct.productId];
    
    [Cym_PHD showSuccess:@"加入购物车成功!"];
//    [Cym_PHD show:@"加入购物车成功"];
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 530;
    }
    else if(indexPath.row == 1)
    {
//        return 100+((self.modelSpecification.data.count+1)/2) * 35;
        return 60;
    }
    else
    {
        return [AppUtils labelAutoCalculateRectWith:self.modelProduct.proDescription lineSpacing:6 FontSize:14 MaxSize:CGSizeMake([AppUtils putScreenWidth]-25, 0)].height+50;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductInfoCell * pdtInfoCell = nil;
    
    if (indexPath.row == 0) {
        pdtInfoCell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!pdtInfoCell) {
            NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"ProductInfoCell" owner:nil options:nil];
            pdtInfoCell = nibArray[0];
        }
        [pdtInfoCell.proBigImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_ImageUrl,self.modelProduct.primeImageUrl]] placeholderImage:[UIImage imageNamed:@"default_pic"]];
        pdtInfoCell.proNameLab.text = self.modelProduct.name;
        pdtInfoCell.proNumLab.text = self.modelProduct.code;
        pdtInfoCell.marketPriceLab.text = [NSString stringWithFormat:@"%0.2lf",[self.modelProduct.partnerMarketPrice floatValue]];
        pdtInfoCell.dphPriceLab.text = [NSString stringWithFormat:@"%0.2lf",[self.modelProduct.sellingPrice floatValue]];
        

        if ([self.modelProduct.favorite isEqualToString:@"0"]) {
            pdtInfoCell.collectBtn.selected = NO;
        }
        else
        {
            pdtInfoCell.collectBtn.selected = YES;
        }
        [pdtInfoCell.collectBtn addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
        return pdtInfoCell;

    }
    else if(indexPath.row == 1)
    {
        pdtInfoCell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!pdtInfoCell) {
            NSArray * nibArray = [[NSBundle mainBundle]loadNibNamed:@"ProductInfoCell" owner:nil options:nil];
            pdtInfoCell = nibArray[1];
        }
        
//        [pdtInfoCell setCollectionViewDataSourceDelegate:self];

        return pdtInfoCell;
        
    }
    else
    {
        static NSString * cellI = @"celli";
        ProIntroduceCell * introCell = [tableView dequeueReusableCellWithIdentifier:cellI];
        if (!introCell) {
            NSArray * nibArray = [[NSBundle mainBundle]loadNibNamed:@"ProIntroduceCell" owner:nil options:nil];
            introCell = nibArray[0];
        }
        if ([self.modelProduct.proDescription isEqual:[NSNull class]]||[self.modelProduct.proDescription isEqualToString:@""]) {
            introCell.introduceLab.text = @"暂无详情!";
        }
        else
        {
            introCell.introduceLab.text = self.modelProduct.proDescription;
        }
        
        return introCell;
    }
}

#pragma mark - collectview

//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return self.modelSpecification.data.count;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    ProductSizeCollectCell * sizeCollectCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sizeLabelCell" forIndexPath:indexPath];
//
//    ModelSpfctionValue * modelValue = self.modelSpecification.data[indexPath.row];
//    sizeCollectCell.label.text = modelValue.value;
//    return sizeCollectCell;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    ProductSizeCollectCell * selectCell = (ProductSizeCollectCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    selectCell.label.layer.borderColor = [UIColor colorWithHexString:@"3CA0E6"].CGColor;
//    size = selectCell.label.text;
//    self.modelProduct.specifications = selectCell.label.text;
////    [self updateCollectionViewCellStatus:selectCell selected:YES];
//    
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    ProductSizeCollectCell * selectCell = (ProductSizeCollectCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    selectCell.label.layer.borderColor = [UIColor colorWithHexString:@"F0F0F0"].CGColor;
//}




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
