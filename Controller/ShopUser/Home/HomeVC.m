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
#import "QuicklyBuyView.h"


#import "CDRTranslucentSideBar.h"
#import "LeftClassifySliderView.h"
#import "ModelCategory.h"

@interface HomeVC ()<CDRTranslucentSideBarDelegate,UITableViewDataSource,UITableViewDelegate>

{
    NSInteger page,type;
    NSString * badgeValue;
}

@property (nonatomic,strong)CDRTranslucentSideBar * rightSideBar;

@property (nonatomic, strong)NSMutableArray * allProductArr;
@property (nonatomic ,strong)NSMutableArray * commomProductArr;//已完成
@property (nonatomic ,strong)NSMutableArray * collectProductArr;//已作废

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
    type = 0;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeBadgeValue) name:@"badgeValueNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cleanUpBadgeValue) name:@"cleanUpBadgeValue" object:nil];
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
        type = index;
        if (type == 0) {
            if (self.allProductArr.count == 0) {
                [self.tableView.mj_header beginRefreshing];
            }
            else
            {
                [self.tableView reloadData];
            }
        }
        else if (type == 1)
        {
            if (self.commomProductArr.count == 0) {
                [self.tableView.mj_header beginRefreshing];
            }
            else
            {
                [self.tableView reloadData];
            }
            
        }
        else
        {
            if (self.collectProductArr.count == 0) {
                [self.tableView.mj_header beginRefreshing];
            }
            else
            {
                [self.tableView reloadData];
            }
        }
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

    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"LeftClassifySliderView" owner:self options:nil];
    //得到第一个UIView
    LeftClassifySliderView * leftView = [nib objectAtIndex:0];
    leftView.myCategoryArr = categories;
    
//    LeftClassifySliderView * leftView = [[LeftClassifySliderView alloc]initWithFrame:CGRectMake(0, 0, Screen.width-50, Screen.height)];
    
    [leftView returnText:^(NSString *level, NSString *ids) {
        [self.rightSideBar dismissAnimated:YES];
        if (ids == nil) {
            NSLog(@"取消");
        }
        else
        {
            NSLog(@"回调level:%@  id:%@  刷新数据 ",level,ids);
            [self getProductListByLevel:level ids:ids type:@"0"];
        }

        
    }];
    
   
    
    
    [self.rightSideBar setContentViewInSideBar:leftView];

}

-(void)cleanUpBadgeValue
{
    self.navigationItem.rightBarButtonItem.badgeValue = [UserDefaultUtils valueWithKey:@"badgeValue"];
}
-(void)changeBadgeValue
{
    NSString * str = [UserDefaultUtils valueWithKey:@"badgeValue"];
//    int i = [str intValue];
//    i = i+1;
//    [UserDefaultUtils saveValue:[NSString stringWithFormat:@"%d",i] forKey:@"badgeValue"];
    self.navigationItem.rightBarButtonItem.badgeValue = str;

}

-(void)toShopCart:(id)sender
{
//    [UserDefaultUtils saveValue:@"0" forKey:@"badgeValue"];
//    self.navigationItem.rightBarButtonItem.badgeValue = @"0";
    
    [self performSegueWithIdentifier:@"toShopCart" sender:nil];
}

-(void)initTable
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self getProductListByLevel:@"0" ids:@"0" type:[NSString stringWithFormat:@"%ld",(long)type]];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page=page +1;
        [self getProductListByLevel:@"0" ids:@"0" type:[NSString stringWithFormat:@"%ld",(long)type]];
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

-(void)getProductListByLevel:(NSString *)level ids:(NSString *)ids type:(NSString *)typeNum
{
    NSString *pageNumber = [NSString stringWithFormat:@"%zd",page];

    
    [[NetworkHome sharedManager] getProductListByUserId:[UserDefaultUtils valueWithKey:@"userId"]
                                              partnerId:[UserDefaultUtils valueWithKey:@"partnerId"]
                                                 pageNo:pageNumber
                                                  level:level
                                                    ids:ids
                                                   type:typeNum
                                                success:^(id result) {
                                                    if ([pageNumber isEqualToString:@"1"]) {
                                                        switch ([typeNum integerValue]) {
                                                            case 0:
                                                            {
                                                                self.allProductArr = [NSMutableArray array];
                                                            }
                                                                break;
                                                            case 1:
                                                            {
                                                                self.commomProductArr = [NSMutableArray array];
                                                            }
                                                                break;
                                                            case 2:
                                                            {
                                                                self.collectProductArr = [NSMutableArray array];
                                                            }
                                                                break;
                                                                
                                                            default:
                                                                break;
                                                        }

                                                    }
                                                    NSMutableArray *arr = [NSMutableArray array];
                                                    for (NSDictionary * proDic in result) {
                                                        ModelProduct * proDomo = [ModelProduct yy_modelWithDictionary:proDic];
                                                        [arr addObject:proDomo];
                                                    }
                                                    
                                                    switch ([typeNum integerValue]) {
                                                        case 0:
                                                        {
                                                            [self.allProductArr addObjectsFromArray:arr];
                                                        }
                                                            break;
                                                        case 1:
                                                        {
                                                            [self.commomProductArr addObjectsFromArray:arr];
                                                        }
                                                            break;
                                                        case 2:
                                                        {
                                                            [self.collectProductArr addObjectsFromArray:arr];
                                                        }
                                                            break;
                                                            
                                                        default:
                                                            break;
                                                    }

                                                   
                                                    
                                                    [self.tableView.mj_header endRefreshing];
                                                    [self.tableView.mj_footer endRefreshing];
                                                    if (arr.count == 0) {
                                                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                                        [self showCommonHUD:@"没有更多商品了!"];
                                                    }
                                                    [self.tableView reloadData];
                                                    
                                                }
                                                failure:^(id result) {
                                                    [self.tableView.mj_header endRefreshing];
                                                    [self.tableView.mj_footer endRefreshing];
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
    ProductCell * cell = (ProductCell *)[[collectBtn superview] superview];
    [[NetworkHome sharedManager]collectProductByUserId:[UserDefaultUtils valueWithKey:@"userId"]
                                             productId:cell.modelProduct.productId isDelete:isDelete
     
                                               success:^(id result) {
                                                   collectBtn.selected = !collectBtn.selected;
        
    }
                                               failure:^(id result) {
                                                   [self showCommonHUD:result];
        
    }];
}

-(void)quicklyBuyAction:(id)sender
{
     UIButton *quickBuyBtn = (UIButton *)sender;
    ProductCell * cell = (ProductCell *)[[quickBuyBtn superview] superview];
    QuicklyBuyView * view = [[QuicklyBuyView alloc]initWithModelProduct:cell.modelProduct];

    [view show];
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
    if (type == 0) {
        return self.allProductArr.count;
    }
    else if (type == 1)
    {
        return self.commomProductArr.count;
    }
    else
    {
        return self.collectProductArr.count;
    }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndentifier = @"productCell";
    ProductCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        NSArray * nibArr = [[NSBundle mainBundle]loadNibNamed:@"ProductCell" owner:self options:nil];
        cell = nibArr[0];
        
    }
    if (type == 0) {
        cell.modelProduct = self.allProductArr[indexPath.row];
    }
    else if (type == 1)
    {
        cell.modelProduct = self.commomProductArr[indexPath.row];
    }
    else
    {
        cell.modelProduct = self.collectProductArr[indexPath.row];
    }
    [cell.collectBtn addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addShopcartBtn addTarget:self action:@selector(quicklyBuyAction:) forControlEvents:UIControlEventTouchUpInside];

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
        ModelProduct * model = [[ModelProduct alloc]init];
        if (type == 0) {
            model = self.allProductArr[index.row];
        }
        else if (type == 1)
        {
            model = self.commomProductArr[index.row];
        }
        else
        {
            model = self.collectProductArr[index.row];
        }

        
        view.productId = model.productId;
        
    }

}


@end
