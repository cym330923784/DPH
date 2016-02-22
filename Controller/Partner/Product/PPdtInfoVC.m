//
//  PPdtInfoVC.m
//  DPH
//
//  Created by cym on 16/1/29.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PPdtInfoVC.h"
#import "PProductInfoCell.h"
#import "ProIntroduceCell.h"
#import "Cym_PHD.h"
#import "ModelSpecification.h"
#import "ModelProduct.h"
#import "PNetworkHome.h"
#import "UserDefaultUtils.h"
#import <YYModel.h>
#import <UIImageView+WebCache.h>
#import "UIColor+TenSixColor.h"
#import "AppUtils.h"
#import "ProductSizeCollectCell.h"
#import "ModelSpfctionValue.h"

@interface PPdtInfoVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSString * size;
}

@property (nonatomic, strong)ModelProduct * modelProduct;
@property (nonatomic, strong)ModelSpecification * modelSpecification;
@property (nonatomic, strong)NSMutableArray * specificationArr;

@end



@implementation PPdtInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self getPRoductDetail];
}

-(void)initData
{
    self.specificationArr = [NSMutableArray array];
    size = [NSString string];
}


-(void)getPRoductDetail
{
    [self showDownloadsHUD:@"加载中..."];

    [[PNetworkHome sharedManager]getProductDetailByProductId:self.productId
                                                   partnerId:[UserDefaultUtils valueWithKey:@"partnerId"]
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

- (IBAction)saveAction:(id)sender {
    
    NSIndexPath * index = [NSIndexPath indexPathForRow:1 inSection:0];
    PProductInfoCell * thisCell = [self.tableView cellForRowAtIndexPath:index];
    
    if ([thisCell.onShelfBtn.titleLabel.textColor isEqual:[UIColor whiteColor]]) {
        self.modelProduct.shelfStatus = @"1";
    }
    else
    {
        self.modelProduct.shelfStatus = @"0";
    }
    [self showDownloadsHUD:@"提交中..."];
    
    [[PNetworkHome sharedManager]submitProductChangeByPartnerId:[UserDefaultUtils valueWithKey:@"partnerId"]
                                                      productId:self.modelProduct.productId
                                                   sellingPrice:thisCell.sellingPriceTF.text
                                                     storageQty:thisCell.qtyTF.text
                                                    shelfStatus:self.modelProduct.shelfStatus
                                                        success:^(id result) {
                                                            [self dismissHUD];
                                                            [Cym_PHD showSuccess:@"保存修改成功!"];
                                                        }
                                                        failure:^(id result) {
                                                            [self dismissHUD];
                                                            [self showCommonHUD:result];
                                                        }];    
    
    
//    [Cym_PHD showSuccess:@"保存修改成功!"];
}


#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 425;
    }
    else if (indexPath.row == 1)
    {
        return 130;
    }
    else if (indexPath.row == 2)
    {
        return 20+((self.modelSpecification.data.count+1)/2) * 35;
    }
    else
    {
        return [AppUtils labelAutoCalculateRectWith:self.modelProduct.proDescription lineSpacing:6 FontSize:14 MaxSize:CGSizeMake([AppUtils putScreenWidth]-25, 0)].height+50;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PProductInfoCell * infoCell = nil;
    if (indexPath.row == 0)
    {
        infoCell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!infoCell) {
            NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"PProductInfoCell" owner:nil options:nil];
            infoCell = nibArray[0];
        }
        
        [infoCell.proBigImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_ImageUrl,self.modelProduct.primeImageUrl]] placeholderImage:[UIImage imageNamed:@"default_pic"]];
        infoCell.nameLab.text = self.modelProduct.name;
        infoCell.codeLab.text = self.modelProduct.code;
        infoCell.marketPriceLab.text = self.modelProduct.partnerMarketPrice;

        return infoCell;
    }
    else if (indexPath.row == 1)
    {
        infoCell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!infoCell) {
            NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"PProductInfoCell" owner:nil options:nil];
            infoCell = nibArray[1];
        }
        infoCell.sellingPriceTF.text = self.modelProduct.sellingPrice;
        infoCell.qtyTF.text = self.modelProduct.storageQty;
        
        if ([self.modelProduct.shelfStatus isEqualToString:@"1"]) {
            infoCell.onShelfBtn.backgroundColor = [UIColor colorWithHexString:@"3CA0E6"];
            [infoCell.onShelfBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            infoCell.outShelfBtn.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
            [infoCell.outShelfBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
        else
        {
            infoCell.onShelfBtn.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
            [infoCell.onShelfBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            infoCell.outShelfBtn.backgroundColor = [UIColor colorWithHexString:@"3CA0E6"];
            [infoCell.outShelfBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        
        return infoCell;

    }
    else if(indexPath.row == 2)
    {
        infoCell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (!infoCell) {
            NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"PProductInfoCell" owner:nil options:nil];
            infoCell = nibArray[2];
        }
        
        [infoCell setCollectionViewDataSourceDelegate:self];
        
        return infoCell;

    }
    else
    {
        static NSString * cellI = @"introCell";
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelSpecification.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductSizeCollectCell * sizeCollectCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sizeLabelCell" forIndexPath:indexPath];
    
    ModelSpfctionValue * modelValue = self.modelSpecification.data[indexPath.row];
    sizeCollectCell.label.text = modelValue.value;
    return sizeCollectCell;
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
