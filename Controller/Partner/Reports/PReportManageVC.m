//
//  PReportManageVC.m
//  DPH
//
//  Created by Cym on 16/3/6.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PReportManageVC.h"
#import "PReportVC.h"
#import "FinanceReportVC.h"
#import "DVSwitch.h"

@interface PReportManageVC ()<UIScrollViewDelegate>

@property (strong, nonatomic)NSMutableArray * viewCtrls;

@property (nonatomic, strong)DVSwitch * mySwitch;

@end



@implementation PReportManageVC

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showtabbar" object:nil];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidetabbar" object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSwitch];
    [self initScrollView];
}


-(void)initSwitch
{
    self.mySwitch = [[DVSwitch alloc]initWithStringsArray:@[@"收益",@"订单"]] ;
    self.mySwitch.frame = CGRectMake(0, 0, Screen.width, 35);
    self.mySwitch.backgroundColor = [UIColor whiteColor];
    self.mySwitch.sliderColor = [UIColor colorWithHexString:@"3CA0E6"];
    self.mySwitch.labelTextColorInsideSlider = [UIColor whiteColor];
    self.mySwitch.labelTextColorOutsideSlider = [UIColor colorWithHexString:@"5f646e"];
    self.mySwitch.font = [UIFont systemFontOfSize:17];
    self.mySwitch.cornerRadius = 0;
    self.mySwitch.tag = 100;
    [self.view addSubview:self.mySwitch];
    
    __unsafe_unretained PReportManageVC *pPeportVC = self;
    [self.mySwitch setPressedHandler:^(NSUInteger index) {
        pPeportVC.scrollView.contentOffset = CGPointMake(Screen.width * index, 0);
    }];
    self.mySwitch.translatesAutoresizingMaskIntoConstraints = NO;
    
    //水平约束
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[mySwitch]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.mySwitch)]];
//    
//    //垂直约束
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[mySwitch(35)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.mySwitch)]];
}


-(void)initScrollView
{
    
    FinanceReportVC * finaceReportVc = [[UIStoryboard storyboardWithName:@"pReport" bundle:nil]instantiateViewControllerWithIdentifier:@"financeReportVC"];
    
    PReportVC * orderReportVc = [[UIStoryboard storyboardWithName:@"pReport" bundle:nil]instantiateViewControllerWithIdentifier:@"pReportVC"];
    
     self.viewCtrls = [[NSMutableArray alloc]initWithObjects:finaceReportVc,orderReportVc,nil];
    
    self.scrollView.contentSize = CGSizeMake(Screen.width * 2, 0);
    self.scrollView.bounces = NO;
    
    for (int i = 0; i < 2; i++) {
        UIViewController * vc = self.viewCtrls[i];
        vc.view.frame = self.view.bounds;
        vc.view.frame = CGRectOffset(self.scrollView.frame, vc.view.frame.size.width * i, -35);
        [self.scrollView addSubview:vc.view];
    }
    
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.mySwitch forceSelectedIndex:scrollView.contentOffset.x/Screen.width animated:YES];

}

//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    [self.mySwitch forceSelectedIndex:scrollView.contentOffset.x/Screen.width animated:YES];
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
