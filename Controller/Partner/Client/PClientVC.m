//
//  PClientVC.m
//  DPH
//
//  Created by cym on 16/1/29.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PClientVC.h"
#import "ShopUserCell.h"
#import "PNetworkClient.h"
#import "ModelShopListDemo.h"
#import "ShopInfoVC.h"
#import "ModelDeliveryArea.h"
#import "AddShopUserVC.h"

@interface PClientVC ()
{
    NSInteger page;
}
@property (nonatomic, strong)NSMutableArray * shopArr;
@property (nonatomic, strong)NSMutableArray * deliveryAreaArr;

@end

@implementation PClientVC

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];
    
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
    page = 1;
    self.deliveryAreaArr = [NSMutableArray array];
    [self initTable];
    [self initView];
    [self getDeliveryAreaList];
    
    
}


-(void)initView
{
    if (![AppUtils userAuthJudgeBy:AUTH_update_endClientManage]) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}
-(void)initTable
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self getClientList];
        
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page += 1;
        [self getClientList];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)getDeliveryAreaList
{
    
    [[PNetworkClient sharedManager]getDeliveryAreaByPartnerId:[UserDefaultUtils valueWithKey:@"partnerId"]
                                                      success:^(id result) {
                                                          for (NSDictionary * areaDic in result) {
                                                              ModelDeliveryArea * modelArea = [ModelDeliveryArea yy_modelWithDictionary:areaDic];
                                                              [self.deliveryAreaArr addObject:modelArea];
                                                          }
                                                          
                                                      }
                                                      failure:^(id result) {
                                                          [self showCommonHUD:@"获取区域列表失败!"];
                                                          
                                                      }];
}


-(void)getClientList
{
    NSString *pageNumber = [NSString stringWithFormat:@"%zd",page];
    [[PNetworkClient sharedManager]getClientListByPartnerId:[UserDefaultUtils valueWithKey:@"partnerId"] pageNo:pageNumber success:^(id result) {
        if ([pageNumber isEqualToString:@"1"]) {
            self.shopArr = [NSMutableArray array];
        }
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary * shopDic in result) {
            ModelShopListDemo * shopDomo = [ModelShopListDemo yy_modelWithDictionary:shopDic];
            [arr addObject:shopDomo];
        }
        [self.shopArr addObjectsFromArray:arr];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (arr.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self showCommonHUD:@"没有更多商户了!"];
        }
        [self.tableView reloadData];
        
        
    } failure:^(id result) {
        [self showCommonHUD:result];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shopArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopUserCell * cell = [tableView dequeueReusableCellWithIdentifier:@"shopUserCell"];
    cell.modelShopListDemo = self.shopArr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    [self performSegueWithIdentifier:@"toShopDetail" sender:indexPath];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toShopDetail"]) {
        ShopInfoVC * infoView = [[ShopInfoVC alloc]init];
        infoView = segue.destinationViewController;
        NSIndexPath * index = (NSIndexPath *)sender;
        ModelShopListDemo * model = self.shopArr[index.row];
        infoView.endClientId = model.shopId;
        infoView.deliveryAreaArr = self.deliveryAreaArr;

    }
    else if ([segue.identifier isEqualToString:@"toAddShopUser"])
    {
        AddShopUserVC * addView = [[AddShopUserVC alloc]init];
        addView = segue.destinationViewController;
        addView.deliveryAreaArr = self.deliveryAreaArr;
    }
}


@end
