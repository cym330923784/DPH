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
#import <UIImageView+WebCache.h>
#import "ProductSizeCollectCell.h"
#import "ModelSpfctionValue.h"
#import "EditPdtInfoVC.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface PPdtInfoVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSString * size;
    
}
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewToBottom;

@property (nonatomic, strong)ModelProduct * modelProduct;
@property (nonatomic, strong)ModelSpecification * modelSpecification;
@property (nonatomic, strong)NSMutableArray * specificationArr;

@end



@implementation PPdtInfoVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initData];
    [self getPRoductDetail];
}


-(void)initView
{
    if (![AppUtils userAuthJudgeBy:AUTH_update_product]) {
        self.saveBtn.hidden = YES;
        self.tableViewToBottom.constant = 0;
    }
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
                                                        self.sellingPriceStr = self.modelProduct.sellingPrice;
                                                         self.qtyStr = self.modelProduct.storageQty;
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
                                                   sellingPrice:thisCell.sellingPriceLab.text
                                                     storageQty:thisCell.qtyLab.text
                                                    shelfStatus:self.modelProduct.shelfStatus
                                                        success:^(id result) {
                                                            [self dismissHUD];
//                                                            [self showCommonHUD:@"保存成功!"];
                                                            [Cym_PHD showSuccess:@"保存修改成功!"];
                                                        }
                                                        failure:^(id result) {
                                                            [self dismissHUD];
                                                            [self showCommonHUD:result];
                                                        }];    
    
    
//    [Cym_PHD showSuccess:@"保存修改成功!"];
}

-(void)tap:(UITapGestureRecognizer *)tap
{
    NSArray *arr = [AppUtils cutStringToArray:self.modelProduct.primeImageUrl symbol:@","];
    
    NSInteger count = arr.count;
    //     1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString *url = [[NSString stringWithFormat:@"%@%@",QN_ImageUrl,arr[i]] stringByReplacingOccurrencesOfString:@"mdpi.jpg" withString:@"hdpi.jpg"];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
//        photo.srcImageView = self.; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    //    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];

}

-(void)toChangeSellingPrice
{
    if (![AppUtils userAuthJudgeBy:AUTH_update_product]) {
        [self showCommonHUD:@"你没有权限修改商品!"];
        return;
    }
    [self performSegueWithIdentifier:@"toEditPdtInfo" sender:@"sellingPrice"];
}

-(void)toChangeQty
{
    if (![AppUtils userAuthJudgeBy:AUTH_update_product]) {
        [self showCommonHUD:@"你没有权限修改商品!"];
        return;
    }
    [self performSegueWithIdentifier:@"toEditPdtInfo" sender:@"qty"];
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
//    else if (indexPath.row == 2)
//    {
//        return 20+((self.modelSpecification.data.count+1)/2) * 35;
//    }
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
    PProductInfoCell * infoCell = nil;
    if (indexPath.row == 0)
    {
        infoCell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!infoCell) {
            NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"PProductInfoCell" owner:nil options:nil];
            infoCell = nibArray[0];
        }
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [infoCell.proBigImgView addGestureRecognizer:tap];
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
        //根据权限判断

//        infoCell.onShelfBtn.userInteractionEnabled = [AppUtils userAuthJudgeBy:AUTH_update_product];
//        infoCell.outShelfBtn.userInteractionEnabled = [AppUtils userAuthJudgeBy:AUTH_update_product];
        
        infoCell.sellingPriceLab.text = [NSString stringWithFormat:@"%0.2lf",[self.sellingPriceStr floatValue]];
        [infoCell.sellingPriceBtn addTarget:self action:@selector(toChangeSellingPrice) forControlEvents:UIControlEventTouchUpInside];
        infoCell.qtyLab.text = [NSString stringWithFormat:@"%@",self.qtyStr];
        [infoCell.qtyBtn addTarget:self action:@selector(toChangeQty) forControlEvents:UIControlEventTouchUpInside];
        
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
//    else if(indexPath.row == 2)
//    {
//        infoCell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
//        if (!infoCell) {
//            NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"PProductInfoCell" owner:nil options:nil];
//            infoCell = nibArray[2];
//        }
//        
//        [infoCell setCollectionViewDataSourceDelegate:self];
//        
//        return infoCell;
//
//    }
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

- (IBAction)unwindSegue:(UIStoryboardSegue *)sender{
    NSLog(@"unwindSegue %@", sender);
    EditPdtInfoVC * vc = sender.sourceViewController;
    if ([vc.type isEqualToString:@"price"]) {
        self.sellingPriceStr = vc.contentTF.text;
    }
    else
    {
        self.qtyStr = vc.contentTF.text;
    }
    [self.tableView reloadData];
    

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toEditPdtInfo"]) {
        EditPdtInfoVC * view = [[EditPdtInfoVC alloc]init];
        view = segue.destinationViewController;
        NSString * str = (NSString *)sender;

        if ([str isEqualToString:@"sellingPrice"]) {
            view.content = [NSString stringWithFormat:@"%0.2lf",[self.sellingPriceStr floatValue]];
            view.type = @"price";
        }
        else
        {
            view.content = self.qtyStr;
            view.type = @"qty";
        }
       
    }


}


@end
