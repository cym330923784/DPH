//
//  HomeVC.m
//  DPH
//
//  Created by cym on 16/1/26.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "HomeVC.h"
#import "ProductCell.h"
#import "UIBarButtonItem+Badge.h"
#import "NetworkHome.h"
#import "ModelProduct.h"
#import "PdtInfoVC.h"
#import "DVSwitch.h"


#import "CDRTranslucentSideBar.h"
#import "LeftClassifySliderView.h"
#import "ModelCategory.h"

@interface HomeVC ()<CDRTranslucentSideBarDelegate,UITableViewDataSource,UITableViewDelegate>

{
    NSInteger page;
    NSString * badgeValue;
}

@property (nonatomic,strong)CDRTranslucentSideBar * rightSideBar;

@property (nonatomic, strong)NSMutableArray * productArr;

@property (nonatomic, strong)NSMutableArray * categoryArr;


@end

@implementation HomeVC

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
    
    
    [self initTable];
    [self initSwitch];
    [self initSliderVew:nil];
//    [self getCategories];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeBadgeValue) name:@"badgeValueNotification" object:nil];
    badgeValue = [UserDefaultUtils valueWithKey:@"badgeValue"];
    UIBarButtonItem *navRightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shopCart_ico"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(toShopCart:)];
    self.navigationItem.rightBarButtonItem = navRightButton;
    self.navigationItem.rightBarButtonItem.badgeValue = badgeValue;
    self.navigationItem.rightBarButtonItem.badgeBGColor = [UIColor redColor];
}

-(void)initSwitch
{
    DVSwitch * mySwitch = [[DVSwitch alloc]initWithStringsArray:@[@"所有商品",@"最常购买",@"我的收藏"]] ;
    mySwitch.backgroundColor = [UIColor whiteColor];
    mySwitch.sliderColor = [UIColor colorWithHexString:@"3CA0E6"];
    mySwitch.labelTextColorInsideSlider = [UIColor whiteColor];
    mySwitch.labelTextColorOutsideSlider = [UIColor blackColor];
    mySwitch.font = [UIFont systemFontOfSize:14];
    mySwitch.cornerRadius = 0;
    mySwitch.tag = 101;
    [self.view addSubview:mySwitch];
    
    [mySwitch setPressedHandler:^(NSUInteger index) {
        [self.tableView.mj_header beginRefreshing];
        
    }];
    mySwitch.translatesAutoresizingMaskIntoConstraints = NO;
    
    //水平约束
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[mySwitch]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(mySwitch)]];
    
    //垂直约束
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[mySwitch(35)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(mySwitch)]];
}


- (IBAction)openLeftAction:(id)sender {
    [self.rightSideBar show];
}

-(void)initSliderVew:(NSMutableArray *)categories
{
    self.rightSideBar = [[CDRTranslucentSideBar alloc]initWithDirection:NO];
    self.rightSideBar.delegate = self;
    self.rightSideBar.sideBarWidth = Screen.width-50;
    self.rightSideBar.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.rightSideBar.tag = 1;
    
    UIView * demoView = [[UIView alloc]init];
    demoView.backgroundColor = [UIColor colorWithHexString:@"3CA0E6"];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"LeftClassifySliderView" owner:self options:nil];
    //得到第一个UIView
    LeftClassifySliderView * leftView = [nib objectAtIndex:0];
//    leftView.myCategoryArr = categories;
        
    [leftView returnText:^(NSString *str) {
        [self.rightSideBar dismissAnimated:YES];
        if (str == nil) {
            NSLog(@"取消");
        }
        else
        {
            NSLog(@"回调参数 : %@，刷新数据 ",str);
        }
        
    }];
    
   
    
    
    [self.rightSideBar setContentViewInSideBar:leftView];

}
-(void)changeBadgeValue
{
    NSString * str = [UserDefaultUtils valueWithKey:@"badgeValue"];
    int i = [str intValue];
    i = i+1;
    [UserDefaultUtils saveValue:[NSString stringWithFormat:@"%d",i] forKey:@"badgeValue"];
    self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%d",i];

}

-(void)toShopCart:(id)sender
{
    [UserDefaultUtils saveValue:@"0" forKey:@"badgeValue"];
    self.navigationItem.rightBarButtonItem.badgeValue = @"0";
    
    [self performSegueWithIdentifier:@"toShopCart" sender:nil];
}

-(void)initTable
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self getProductList];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page=page +1;
        [self getProductList];
    }];
    
    [self.tableView.mj_header beginRefreshing];

}



-(void)getCategories
{
    
    [[NetworkHome sharedManager]getCategoriesByUserId:[UserDefaultUtils valueWithKey:@"userId"]
                                              success:^(id result) {
                                                  self.categoryArr = [[NSMutableArray alloc]initWithCapacity:0];
                                                  
                                                  for (NSDictionary * categoryDic in result) {
                                                      ModelCategory * categoryDomo = [ModelCategory yy_modelWithDictionary:categoryDic];
                                                      [self.categoryArr addObject:categoryDomo];
                                                  }
                                                  [self initSliderVew:self.categoryArr];
                                              }
                                              failure:^(id result) {
                                                  [self showCommonHUD:result];
                                                  
                                              }];
}

-(void)getProductList
{
    NSString *pageNumber = [NSString stringWithFormat:@"%zd",page];

    
    [[NetworkHome sharedManager] getProductListByUserId:[UserDefaultUtils valueWithKey:@"userId"]
                                              partnerId:[UserDefaultUtils valueWithKey:@"partnerId"]
                                                 pageNo:pageNumber
                                                success:^(id result) {
                                                    if ([pageNumber isEqualToString:@"1"]) {
                                                        self.productArr = [NSMutableArray array];
                                                    }
                                                    NSMutableArray *arr = [NSMutableArray array];
                                                    for (NSDictionary * proDic in result) {
                                                        ModelProduct * proDomo = [ModelProduct yy_modelWithDictionary:proDic];
                                                        [arr addObject:proDomo];
                                                    }
                                                    [self.productArr addObjectsFromArray:arr];
                                                    
                                                    [self.tableView.mj_header endRefreshing];
                                                    [self.tableView.mj_footer endRefreshing];
                                                    if (arr.count == 0) {
                                                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                                        [self showCommonHUD:@"没有更多商品了!"];
                                                    }
                                                    [self.tableView reloadData];
                                                    
                                                }
                                                failure:^(id result) {
                                                    [self showCommonHUD:result];
                                                    [self.tableView.mj_header endRefreshing];
                                                }];
}



#pragma mark - CDRTranslucentSideBarDelegate
- (void)sideBar:(CDRTranslucentSideBar *)sideBar didAppear:(BOOL)animated
{
    if (sideBar.tag == 0) {
        NSLog(@"Left SideBar did appear");
    }
    
    if (sideBar.tag == 1) {
        NSLog(@"Right SideBar did appear");
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    }
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar willAppear:(BOOL)animated
{
    if (sideBar.tag == 0) {
        NSLog(@"Left SideBar will appear");
    }
    
    if (sideBar.tag == 1) {
        NSLog(@"Right SideBar will appear");
    }
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar didDisappear:(BOOL)animated
{
    if (sideBar.tag == 0) {
        NSLog(@"Left SideBar did disappear");
    }
    
    if (sideBar.tag == 1) {
        NSLog(@"Right SideBar did disappear");
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar willDisappear:(BOOL)animated
{
    if (sideBar.tag == 0) {
        NSLog(@"Left SideBar will disappear");
    }
    
    if (sideBar.tag == 1) {
        NSLog(@"Right SideBar will disappear");
    }
}



#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.productArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndentifier = @"productCell";
    ProductCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        NSArray * nibArr = [[NSBundle mainBundle]loadNibNamed:@"ProductCell" owner:self options:nil];
        cell = nibArr[0];
        
    }
    cell.modelProduct = self.productArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    [self performSegueWithIdentifier:@"toPdtInfo" sender:indexPath];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toPdtInfo"]) {
        PdtInfoVC * view = [[PdtInfoVC alloc]init];
        view = segue.destinationViewController;
        NSIndexPath * index = (NSIndexPath *)sender;
        ModelProduct * model = self.productArr[index.row];
        view.productId = model.productId;
        
    }

}


@end
