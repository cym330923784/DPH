//
//  ProductVC.m
//  DPH
//
//  Created by cym on 16/1/29.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "ProductVC.h"
#import "ProductCell.h"
#import "PNetworkHome.h"
#import "PPdtInfoVC.h"

@interface ProductVC ()
{
    NSInteger page;
}

@property (nonatomic, strong)NSMutableArray * productArr;

@end

@implementation ProductVC

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self initTable];
    page = 1;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showtabbar" object:nil];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidetabbar" object:nil];
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    
//}

-(void)initTable
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self getProductList];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page = page+1;
        [self getProductList];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)getProductList
{
    NSString *pageNumber = [NSString stringWithFormat:@"%zd",page];
    [[PNetworkHome sharedManager]getProductListByPartnerId:[UserDefaultUtils valueWithKey:@"partnerId"]
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
                                                   } failure:^(id result) {
                                                       [self showCommonHUD:result];
                                                       [self.tableView.mj_header endRefreshing];
                                                       [self.tableView.mj_footer endRefreshing];
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
    cell.addShopcartBtn.hidden = YES;
    cell.collectBtn.hidden = YES;
    cell.modelProduct = self.productArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    [self performSegueWithIdentifier:@"toProductDetail" sender:indexPath];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toProductDetail"]) {
        PPdtInfoVC * view = [[PPdtInfoVC alloc]init];
        view = segue.destinationViewController;
        NSIndexPath * index = (NSIndexPath *)sender;
        ModelProduct * model = self.productArr[index.row];
        view.productId = model.productId;
        
    }

}


@end
