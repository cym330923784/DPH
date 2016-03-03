//
//  CollectionVC.m
//  DPH
//
//  Created by Cym on 16/3/1.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "CollectionVC.h"
#import "ProductCell.h"
#import "QuicklyBuyView.h"
#import "NetworkHome.h"

@interface CollectionVC ()
{
    NSInteger page;
}

@property (nonatomic, strong)NSMutableArray * productArr;

@end

@implementation CollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initTable];
}

-(void)initTable
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self getList];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page = page + 1;
        [self getList];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)getList
{
    NSString *pageNumber = [NSString stringWithFormat:@"%zd",page];
    [[NetworkHome sharedManager]getProductListByUserId:[UserDefaultUtils valueWithKey:@"userId"]
                                             partnerId:[UserDefaultUtils valueWithKey:@"partnerId"]
                                                pageNo:pageNumber
                                                 level:@"0"
                                                   ids:@"0"
                                                  type:@"2"
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
                                                   [self.tableView.mj_header endRefreshing];
                                                   [self.tableView.mj_footer endRefreshing];
                                                   [self showCommonHUD:result];
                                                   
                                               }];
}

-(void)collectAction:(id)sender
{
    UIButton *collectBtn = (UIButton *)sender;
    ProductCell * cell = (ProductCell *)[[collectBtn superview] superview];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    [AppUtils showAlert:@"删除商品" message:@"您确定要删除所选的商品?" objectSelf:self defaultAction:^(id result) {
        [[NetworkHome sharedManager]collectProductByUserId:[UserDefaultUtils valueWithKey:@"userId"]
                                                 productId:cell.modelProduct.productId isDelete:YES
                                                   success:^(id result) {
                                                       //        ModelProduct * model = self.productArr[indexPath.row];
                                                       
                                                       NSLog(@"%lu   %ld",(unsigned long)self.productArr.count,(long)indexPath.row);
                                                       [self.productArr removeObjectAtIndex:indexPath.row];
                                                       
                                                       //    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                                                       [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                                                             withRowAnimation:UITableViewRowAnimationLeft];
                                                       //        [self.cellArr removeAllObjects];
                                                       [self.tableView reloadData];
                                                       
                                                   }
                                                   failure:^(id result) {
                                                       [self showCommonHUD:result];
                                                       
                                                   }];

    } cancelAction:^(id result) {
        
    }];
    
    
}

-(void)quicklyBuyAction:(id)sender
{
    UIButton *quickBuyBtn = (UIButton *)sender;
    ProductCell * cell = (ProductCell *)[[quickBuyBtn superview] superview];
    QuicklyBuyView * view = [[QuicklyBuyView alloc]initWithModelProduct:cell.modelProduct];

    [view show];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
