//
//  HomeVC.m
//  DPH
//
//  Created by cym on 16/1/26.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "HomeVC.h"
#import <MJRefresh.h>
#import "ProductCell.h"
#import "UIBarButtonItem+Badge.h"
#import "NetworkHome.h"
#import "UserDefaultUtils.h"
#import "ModelProduct.h"
#import <YYModel.h>
#import "PdtInfoVC.h"

@interface HomeVC ()
{
    NSInteger page;
    NSString * badgeValue;
}
@property (nonatomic, strong)NSMutableArray * productArr;
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
