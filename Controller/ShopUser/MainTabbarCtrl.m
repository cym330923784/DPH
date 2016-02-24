//
//  MainTabbarCtrl.m
//  DPH
//
//  Created by cym on 16/1/25.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "MainTabbarCtrl.h"

@interface MainTabbarCtrl ()
{
    
    UIView *barView;
    
    UIButton *homeBtn;
    UIButton *orderBtn;
    UIButton *msgBtn;
    UIButton *personBtn;
}

@property (nonatomic, strong) UIWindow       *window;

@end


@implementation MainTabbarCtrl

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideRealTabBar];
    [self customTabBar];
    [self initialTabBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showtabbar) name:@"showtabbar" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidetabbar) name:@"hidetabbar" object:nil];

}

-(void)hidetabbar{
    
    CGFloat screenH = [AppUtils putScreenHeight];
    [UIView animateWithDuration:0.3 animations:^{
        barView.frame=CGRectMake(0, screenH+10, [AppUtils putScreenWidth], 49);
    }];
}

-(void)showtabbar{
    
    CGFloat screenH = [AppUtils putScreenHeight];
    [UIView animateWithDuration:0.3 animations:^{
        barView.frame=CGRectMake(0, screenH-49, [AppUtils putScreenWidth], 49);
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
    
    barView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tabBar.frame.origin.y, ScreenW, 49)];
    barView.backgroundColor = [UIColor colorWithHexString:@"f9f9f9"];
    [self.view addSubview:barView];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tabBar.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [barView addSubview:lineView];
    
    //********************首页*********************
    homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    homeBtn.frame = CGRectMake(0, 0, btnW, 49);
    [homeBtn setImage:[UIImage imageNamed:@"homePage_ico_home"] forState:UIControlStateNormal];
    [homeBtn setImage:[UIImage imageNamed:@"homePage_ico_home_select"] forState:UIControlStateSelected];
    homeBtn.tag = 0;
    homeBtn.selected = YES;
    [homeBtn setTitle:@"主页" forState:UIControlStateNormal];
    //    homeBtn.titleLabel.font = [UIFont fontWithName:@"FZLanTingHei-L-GBK" size:10];
    homeBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [homeBtn setTitleColor:[UIColor colorWithHexString:@"5f646e"] forState:UIControlStateNormal];
    [homeBtn setTitleColor:[UIColor colorWithHexString:@"4484DF"] forState:UIControlStateSelected];
    [homeBtn setTitleEdgeInsets:UIEdgeInsetsMake(25, 0, 0, 20)];
    [homeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 13, 0)];
    homeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [homeBtn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    
    [barView addSubview:homeBtn];
    
    
    //********************订单*********************
    orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    orderBtn.frame = CGRectMake(btnW, 0, btnW, 49);
    [orderBtn setImage:[UIImage imageNamed:@"homePage_ico_shop"] forState:UIControlStateNormal];
    [orderBtn setImage:[UIImage imageNamed:@"homePage_ico_shop_select"] forState:UIControlStateSelected];
    orderBtn.tag = 1;
    [orderBtn setTitle:@"订单" forState:UIControlStateNormal];
    orderBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [orderBtn setTitleColor:[UIColor colorWithHexString:@"5f646e"] forState:UIControlStateNormal];
    [orderBtn setTitleColor:[UIColor colorWithHexString:@"4484DF"] forState:UIControlStateSelected];
    [orderBtn setTitleEdgeInsets:UIEdgeInsetsMake(25, 0, 0, 20)];
    [orderBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 13, 0)];
    orderBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [orderBtn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    
    [barView addSubview:orderBtn];
    
    
    //********************消息*********************
    msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    msgBtn.frame = CGRectMake(btnW * 2, 0, btnW, 49);
    [msgBtn setImage:[UIImage imageNamed:@"homePage_ico_find"] forState:UIControlStateNormal];
    [msgBtn setImage:[UIImage imageNamed:@"homePage_ico_find_select"] forState:UIControlStateSelected];
    msgBtn.tag = 2;
    [msgBtn setTitle:@"消息" forState:UIControlStateNormal];
    msgBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [msgBtn setTitleColor:[UIColor colorWithHexString:@"5f646e"] forState:UIControlStateNormal];
    [msgBtn setTitleColor:[UIColor colorWithHexString:@"4484DF"] forState:UIControlStateSelected];
    [msgBtn setTitleEdgeInsets:UIEdgeInsetsMake(25, 0, 0, 20)];
    [msgBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 13, 0)];
    msgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [msgBtn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    
    [barView addSubview:msgBtn];
    
    //********************个人*********************
    personBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    personBtn.frame = CGRectMake(btnW * 3, 0, btnW, 49);
    [personBtn setImage:[UIImage imageNamed:@"homePage_ico_user"] forState:UIControlStateNormal];
    [personBtn setImage:[UIImage imageNamed:@"homePage_ico_user_select"] forState:UIControlStateSelected];
    personBtn.tag = 3;
    [personBtn setTitle:@"个人" forState:UIControlStateNormal];
    personBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [personBtn setTitleColor:[UIColor colorWithHexString:@"5f646e"] forState:UIControlStateNormal];
    [personBtn setTitleColor:[UIColor colorWithHexString:@"4484DF"] forState:UIControlStateSelected];
    [personBtn setTitleEdgeInsets:UIEdgeInsetsMake(25, 0, 0, 20)];
    [personBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 13, 0)];
    personBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [personBtn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    
    [barView addSubview:personBtn];


}

-(void)initialTabBar
{
    UIStoryboard * homeBoard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    UINavigationController * navHome = [homeBoard instantiateViewControllerWithIdentifier:@"NavHome"];
    
    UIStoryboard * orderBoard = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
    UINavigationController * navOrder = [orderBoard instantiateViewControllerWithIdentifier:@"NavOrder"];
    
    //    UIStoryboard * visitBoard = [UIStoryboard storyboardWithName:@"Visit" bundle:nil];
    //    UINavigationController * navVisit = [visitBoard instantiateViewControllerWithIdentifier:@"NavVisit"];
    
    UIStoryboard * msgBoard = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
    UINavigationController * navMsg = [msgBoard instantiateViewControllerWithIdentifier:@"NavMessage"];
    
    UIStoryboard * personBoard = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
    UINavigationController * navPerson = [personBoard instantiateViewControllerWithIdentifier:@"NavPerson"];
    
    self.viewControllers               = @[navHome, navOrder, navMsg, navPerson];
    
    self.tabBar.tintColor              = [UIColor whiteColor];
    
}

-(void)selectedTab:(UIButton *)button
{
    homeBtn.selected = NO;
    orderBtn.selected = NO;
    msgBtn.selected = NO;
    personBtn.selected = NO;
    
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
