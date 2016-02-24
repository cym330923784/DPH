//
//  PMainTabbarCtrl.m
//  DPH
//
//  Created by cym on 16/1/26.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PMainTabbarCtrl.h"


@interface PMainTabbarCtrl ()
{
    UIView *pBarView;
    
    UIButton *pProductBtn;
    UIButton *pOrderBtn;
    UIButton *pClientBtn;
    UIButton *pReportBtn;

}

@property (nonatomic, strong) UIWindow       *window;
@end

@implementation PMainTabbarCtrl

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self hideRealTabBar];
    [self customTabBar];
    [self initialTabBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showtabbar) name:@"showtabbar" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidetabbar) name:@"hidetabbar" object:nil];

}

-(void)hidetabbar{
    
    CGFloat screenH = [AppUtils putScreenHeight];
    [UIView animateWithDuration:0.3 animations:^{
        pBarView.frame=CGRectMake(0, screenH+10, [AppUtils putScreenWidth], 49);
    }];
}

-(void)showtabbar{
    
    CGFloat screenH = [AppUtils putScreenHeight];
    [UIView animateWithDuration:0.3 animations:^{
        pBarView.frame=CGRectMake(0, screenH-49, [AppUtils putScreenWidth], 49);
    }];
}

-(void)hideRealTabBar
{
    
    self.tabBar.hidden = YES;
    [self.tabBar removeFromSuperview];
    
}

-(void)customTabBar
{
    CGFloat ScreenW = [AppUtils putScreenWidth];
    
    CGFloat btnW = ScreenW/4;
    
    pBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tabBar.frame.origin.y, ScreenW, 49)];
    pBarView.backgroundColor = [UIColor colorWithHexString:@"f9f9f9"];
    [self.view addSubview:pBarView];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tabBar.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [pBarView addSubview:lineView];
    
    //********************商品*********************
    pProductBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pProductBtn.frame = CGRectMake(0, 0, btnW, 49);
    [pProductBtn setImage:[UIImage imageNamed:@"homePage_ico_home"] forState:UIControlStateNormal];
    [pProductBtn setImage:[UIImage imageNamed:@"homePage_ico_home_select"] forState:UIControlStateSelected];
    pProductBtn.tag = 0;
    pProductBtn.selected = YES;
    [pProductBtn setTitle:@"商品" forState:UIControlStateNormal];
    //    homeBtn.titleLabel.font = [UIFont fontWithName:@"FZLanTingHei-L-GBK" size:10];
    pProductBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [pProductBtn setTitleColor:[UIColor colorWithHexString:@"5f646e"] forState:UIControlStateNormal];
    [pProductBtn setTitleColor:[UIColor colorWithHexString:@"4484DF"] forState:UIControlStateSelected];
    [pProductBtn setTitleEdgeInsets:UIEdgeInsetsMake(25, 0, 0, 20)];
    [pProductBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 13, 0)];
    pProductBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [pProductBtn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    
    [pBarView addSubview:pProductBtn];
    
    
    //********************订单*********************
    pOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pOrderBtn.frame = CGRectMake(btnW, 0, btnW, 49);
    [pOrderBtn setImage:[UIImage imageNamed:@"homePage_ico_shop"] forState:UIControlStateNormal];
    [pOrderBtn setImage:[UIImage imageNamed:@"homePage_ico_shop_select"] forState:UIControlStateSelected];
    pOrderBtn.tag = 1;
    [pOrderBtn setTitle:@"订单" forState:UIControlStateNormal];
    pOrderBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [pOrderBtn setTitleColor:[UIColor colorWithHexString:@"5f646e"] forState:UIControlStateNormal];
    [pOrderBtn setTitleColor:[UIColor colorWithHexString:@"4484DF"] forState:UIControlStateSelected];
    [pOrderBtn setTitleEdgeInsets:UIEdgeInsetsMake(25, 0, 0, 20)];
    [pOrderBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 13, 0)];
    pOrderBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [pOrderBtn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    
    [pBarView addSubview:pOrderBtn];
    
    
    //********************商户*********************
    pClientBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pClientBtn.frame = CGRectMake(btnW * 2, 0, btnW, 49);
    [pClientBtn setImage:[UIImage imageNamed:@"homePage_ico_find"] forState:UIControlStateNormal];
    [pClientBtn setImage:[UIImage imageNamed:@"homePage_ico_find_select"] forState:UIControlStateSelected];
    pClientBtn.tag = 2;
    [pClientBtn setTitle:@"商户" forState:UIControlStateNormal];
    pClientBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [pClientBtn setTitleColor:[UIColor colorWithHexString:@"5f646e"] forState:UIControlStateNormal];
    [pClientBtn setTitleColor:[UIColor colorWithHexString:@"4484DF"] forState:UIControlStateSelected];
    [pClientBtn setTitleEdgeInsets:UIEdgeInsetsMake(25, 0, 0, 20)];
    [pClientBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 13, 0)];
    pClientBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [pClientBtn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    
    [pBarView addSubview:pClientBtn];
    
    //********************报表*********************
    pReportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pReportBtn.frame = CGRectMake(btnW * 3, 0, btnW, 49);
    [pReportBtn setImage:[UIImage imageNamed:@"homePage_ico_user"] forState:UIControlStateNormal];
    [pReportBtn setImage:[UIImage imageNamed:@"homePage_ico_user_select"] forState:UIControlStateSelected];
    pReportBtn.tag = 3;
    [pReportBtn setTitle:@"报表" forState:UIControlStateNormal];
    pReportBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [pReportBtn setTitleColor:[UIColor colorWithHexString:@"5f646e"] forState:UIControlStateNormal];
    [pReportBtn setTitleColor:[UIColor colorWithHexString:@"4484DF"] forState:UIControlStateSelected];
    [pReportBtn setTitleEdgeInsets:UIEdgeInsetsMake(25, 0, 0, 20)];
    [pReportBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 13, 0)];
    pReportBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [pReportBtn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    
    [pBarView addSubview:pReportBtn];
    
    
}

-(void)initialTabBar
{
    UIStoryboard * pProBoard = [UIStoryboard storyboardWithName:@"pProduct" bundle:nil];
    UINavigationController * navPPro = [pProBoard instantiateViewControllerWithIdentifier:@"NavPPro"];
    
    UIStoryboard * pOrderBoard = [UIStoryboard storyboardWithName:@"pOrder" bundle:nil];
    UINavigationController * navPOrder = [pOrderBoard instantiateViewControllerWithIdentifier:@"NavPOrder"];
    
    UIStoryboard * pClientBoard = [UIStoryboard storyboardWithName:@"pClient" bundle:nil];
    UINavigationController * navPClient = [pClientBoard instantiateViewControllerWithIdentifier:@"NavPClient"];
    
    UIStoryboard * pReportBoard = [UIStoryboard storyboardWithName:@"pReport" bundle:nil];
    UINavigationController * navPReport = [pReportBoard instantiateViewControllerWithIdentifier:@"NavPReport"];
    
    self.viewControllers               = @[navPPro, navPOrder, navPClient, navPReport];
    
    self.tabBar.tintColor              = [UIColor whiteColor];
    
}

-(void)selectedTab:(UIButton *)button
{
    pProductBtn.selected = NO;
    pOrderBtn.selected = NO;
    pClientBtn.selected = NO;
    pReportBtn.selected = NO;
    
    button.selected = YES;
    
    self.currentSelectedIndex = button.tag;
    
    self.selectedIndex = self.currentSelectedIndex;
    
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
