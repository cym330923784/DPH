//
//  QuicklyBuyView.m
//  DPH
//
//  Created by Cym on 16/3/1.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "QuicklyBuyView.h"
#import "ShopCartSQL.h"
#import "Cym_PHD.h"
#import <MBProgressHUD.h>
#import <UIImageView+WebCache.h>

@interface QuicklyBuyView ()

@property (nonatomic, strong) UIView *backImageView;


@end

@implementation QuicklyBuyView


-(id)initWithModelProduct:(ModelProduct *)modelProduct
{
    self = [super init];
    if (self) {
        self.modelProduct = modelProduct;
        NSData * proData = [NSKeyedArchiver archivedDataWithRootObject:modelProduct];
        [UserDefaultUtils saveValue:proData forKey:@"modelProduct"];
    }
    return self;
}

//-(void)setModelProduct:(ModelProduct *)modelProduct
//{
//    _modelProduct = modelProduct;
//    NSLog(@"%@   %@ ",modelProduct.sellingPrice,modelProduct.name);
//    self.imageView.image = self.image;
//    self.priceLab.text = [NSString stringWithFormat:@"%0.2lf",[modelProduct.sellingPrice floatValue]];;
//    self.nameLab.text = modelProduct.name;
//}

- (IBAction)cutAction:(id)sender {
    
    int i = [self.numTF.text intValue];
    if (i == 1||[self.numTF.text isEqualToString:@""]) {
        return;
    }
    i = i-1;
    self.numTF.text = [NSString stringWithFormat:@"%d",i];
    self.numStr = self.numTF.text;
    if (i == 1) {
        self.cutBtn.enabled = NO;
    }

}
- (IBAction)addAction:(id)sender {
    int i = [self.numTF.text intValue];
    i = i+1;
    self.numTF.text = [NSString stringWithFormat:@"%d",i];
    self.numStr = self.numTF.text;
    self.cutBtn.enabled = YES;
}


- (void)show
{
    
    UIViewController *topVC = [self appRootViewController];
    
    QuicklyBuyView  * reportView = [[NSBundle mainBundle] loadNibNamed:@"QuicklyBuyView" owner:self options:nil][0];
    NSLog(@"%@   %@  ",self.modelProduct.sellingPrice,self.modelProduct.name);

    [reportView.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_ImageUrl,self.modelProduct.primeImageUrl]] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    reportView.priceLab.text = [NSString stringWithFormat:@"%0.2lf",[self.modelProduct.sellingPrice floatValue]];
    reportView.nameLab.text = self.modelProduct.name;
    reportView.frame = CGRectMake(0,Screen.height-200,Screen.width,200);
    [topVC.view addSubview:reportView];
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (void)removeFromSuperview
{
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
    [super removeFromSuperview];
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!self.backImageView) {
        self.backImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.backImageView.backgroundColor = [UIColor blackColor];
        self.backImageView.alpha = 0.6f;
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
        [self.backImageView addGestureRecognizer:tap];
    }
    [topVC.view addSubview:self.backImageView];
    [super willMoveToSuperview:newSuperview];
}

-(void)close
{
    [self removeFromSuperview];
}

- (IBAction)submitAction:(id)sender {
    if ([self.numTF.text isEqualToString:@""]||[self.numTF.text isEqualToString:@"0"]) {
        [self showCommonHUD:@"请选择数量!"];
        return;
    }
    NSData * proData = [UserDefaultUtils valueWithKey:@"modelProduct"];
    ModelProduct * thisModel = [NSKeyedUnarchiver unarchiveObjectWithData:proData];
    ModelProduct * thisPro = [ModelProduct yy_modelWithDictionary:[ShopCartSQL getObjectById:thisModel.productId]];
    if (thisPro) {
        NSLog(@"存在");
        int numValue = [self.numTF.text intValue];
        numValue += [thisPro.qty intValue];
        thisModel.qty = [NSString stringWithFormat:@"%d",numValue];
    }
    else
    {
        NSLog(@"不存在");
        thisModel.qty = self.numTF.text;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"badgeValueNotification" object:nil];
    }
    NSDictionary * modelDic = [AppUtils getObjectData:thisModel];

    [ShopCartSQL saveToShopCart:modelDic withId:thisModel.productId];
    
    [Cym_PHD showSuccess:@"加入购物车成功!"];

    [self removeFromSuperview];
}

-(void)showCommonHUD:(NSString *)status{
    MBProgressHUD *hud            = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode                      = MBProgressHUDModeText;
    hud.labelText                 = status;
    hud.margin                    = 10.f;
    hud.yOffset                   = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}




@end
