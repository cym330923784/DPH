//
//  PClientVC.m
//  DPH
//
//  Created by cym on 16/1/29.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PClientVC.h"
#import <MJRefresh/MJRefresh.h>
#import "ShopUserCell.h"
#import "PNetworkClient.h"
#import "UserDefaultUtils.h"
#import "ModelShopListDemo.h"
#import <YYModel.h>
#import "ShopInfoVC.h"

@interface PClientVC ()
{
    NSInteger page;
}
@property (nonatomic, strong)NSMutableArray * shopArr;

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
    [self initTable];
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

    }
}


@end
