//
//  PDiliveryPackageOrderVC.m
//  DPH
//
//  Created by Cym on 16/3/5.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PDiliveryPackageOrderVC.h"
#import "PDiliveryPackageOrderCell.h"
#import "ReasonSelectView.h"
#import "PNetworkOrder.h"

@interface PDiliveryPackageOrderVC ()
{
    NSInteger page;
    BOOL isAllSelect;
}

@property (nonatomic, strong)NSMutableArray * orderArr;
@property (nonatomic, strong)NSMutableArray * cellArr;
@property (nonatomic, strong)NSMutableArray * tempOrderArr;

@end

@implementation PDiliveryPackageOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cellArr = [NSMutableArray array];
    self.tempOrderArr = [NSMutableArray array];
    isAllSelect = NO;
    [self initTable];
}

-(void)initTable
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self getOrderList];
        
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page += 1;
        [self getOrderList];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)getOrderList
{
    NSString *pageNumber = [NSString stringWithFormat:@"%zd",page];
    
    [[PNetworkOrder sharedManager]getDilliveryOrderListByUserId:[UserDefaultUtils valueWithKey:@"branchUserId"]
                                                    orderStatus:@"2"
                                                         pageNo:pageNumber
                                                        success:^(id result) {
                                                            if ([pageNumber isEqualToString:@"1"]) {
                                                                self.orderArr = [NSMutableArray array];
                                                            }
                                                            
                                                            NSMutableArray *arr = [NSMutableArray array];
                                                            for (NSDictionary * orderDic in result) {
                                                                ModelOrder * orderDemo = [ModelOrder yy_modelWithDictionary:orderDic];
                                                                [arr addObject:orderDemo];
                                                            }
                                                            [self.orderArr addObjectsFromArray:arr];
                                                            
                                                            [self.tableView.mj_header endRefreshing];
                                                            [self.tableView.mj_footer endRefreshing];
                                                            if (arr.count == 0) {
                                                                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                                                [self showCommonHUD:@"没有更多订单了!"];
                                                            }
                                                            [self.tableView reloadData];
                                                            
                                                        }
                                                        failure:^(id result) {
                                                            [self.tableView.mj_header endRefreshing];
                                                            [self.tableView.mj_footer endRefreshing];
                                                            [self showCommonHUD:result];
                                                            
                                                        }];
}

//勾选
-(void)selectCheckBtn:(id)sender
{
    UIButton * thisBtn = (UIButton *)sender;
    thisBtn.selected = !thisBtn.selected;
    PDiliveryPackageOrderCell * thisCell = (PDiliveryPackageOrderCell *)[[[thisBtn superview]superview]superview];
    
    NSLog(@"%@",thisCell.modelOrder);
    if (thisBtn.selected) {
        [self.tempOrderArr addObject:thisCell.modelOrder];
    }
    else
    {
        [self.tempOrderArr removeObject:thisCell.modelOrder];
    }
}

//退回订单
-(void)backOrderACtion:(id)sender
{
//    UIButton * thisBtn = (UIButton *)sender;
    PDiliveryPackageOrderCell * thisCell = (PDiliveryPackageOrderCell *)[[[sender superview] superview]superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:thisCell];
    NSLog(@"退回订单");
    NSArray * arr = @[@"货品库存量不同",@"货品受损"];

    ReasonSelectView * view = [[ReasonSelectView alloc]initWithTitle:@"订单退回原因" reasonArr:arr typeNum:1 orderId:thisCell.modelOrder.orderId];
    view.rightBlock = ^(NSString*reasonStr){
        [self showDownloadsHUD:@"提交中..."];
        [[PNetworkOrder sharedManager]backDeliveryOrderByOrder:thisCell.modelOrder.orderId
                                                        userId:[UserDefaultUtils valueWithKey:@"branchUserId"]
                                                        reason:reasonStr
                                                       success:^(id result) {
                                                           [self dismissHUD];
                                                           
                                                           [self.orderArr removeObjectAtIndex:indexPath.row];
                                                           [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                                                                 withRowAnimation:UITableViewRowAnimationLeft];
                                                           [self.cellArr removeAllObjects];
                                                           [self.tableView reloadData];
                                                           [self showCommonHUD:@"提交成功!"];
                                                           
                                                       }
                                                       failure:^(id result) {
                                                           [self dismissHUD];
                                                           [self showCommonHUD:@"提交失败"];
                                                       }];

        
    };
    [view show];
    
}

//移除订单
-(void)removeOrderACtion:(id)sender
{
    NSLog(@"移除订单");
    PDiliveryPackageOrderCell * thisCell = (PDiliveryPackageOrderCell *)[[[sender superview] superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:thisCell];

    [self showCommonHUD:@"提交中..."];
    [[PNetworkOrder sharedManager]removeDeliveryOrderByOrder:thisCell.modelOrder.orderId
                                                      userId:[UserDefaultUtils valueWithKey:@"branchUserId"]
                                                     success:^(id result) {
                                                         [self dismissHUD];
                                                         
                                                         [self.orderArr removeObjectAtIndex:indexPath.row];
                                                         [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                                                               withRowAnimation:UITableViewRowAnimationLeft];
                                                         [self.cellArr removeAllObjects];
                                                         [self.tableView reloadData];
                                                         [self showCommonHUD:@"提交成功!"];
                                                         
                                                     }
                                                     failure:^(id result) {
                                                         [self dismissHUD];
                                                         [self showCommonHUD:@"提交失败!"];
                                                         
                                                     }];
}

//清空订单

- (IBAction)removeAllOrderAction:(id)sender {
    NSLog(@"清空订单");
    
    if (self.orderArr.count == 0) {
        [self showCommonHUD:@"没有订单!"];
        return;
    }
    [AppUtils showAlert:nil
                message:@"是否清空订单?"
             objectSelf:self
          defaultAction:^(id result) {
              NSMutableArray * tempArr= [NSMutableArray array];
              for (PDiliveryPackageOrderCell * thisCell in self.cellArr) {
                  [tempArr addObject:thisCell.modelOrder.orderId];
              }
              NSString * orderIds = [AppUtils putArrToString:tempArr];
              NSLog(@"%@",orderIds);
              [self showCommonHUD:@"提交中..."];
              [[PNetworkOrder sharedManager]removeDeliveryOrderByOrder:orderIds
                                                                userId:[UserDefaultUtils valueWithKey:@"branchUserId"]
                                                               success:^(id result) {
                                                                   [self dismissHUD];
                                                                   
                                                                   [self.orderArr removeAllObjects];
                                                                   [self.cellArr removeAllObjects];
                                                                   [self.tableView reloadData];
                                                                   [self showCommonHUD:@"提交成功!"];
                                                                   
                                                               }
                                                               failure:^(id result) {
                                                                   [self dismissHUD];
                                                                   [self showCommonHUD:@"提交失败!"];
                                                                   
                                                               }];
              
              
          }
           cancelAction:^(id result) {
               
           }];
    
    
}


//全选

- (IBAction)allSelectAction:(id)sender {
    
    [self.tempOrderArr removeAllObjects];
    for (PDiliveryPackageOrderCell * thisCell in self.cellArr) {
        if (isAllSelect) {
            thisCell.checkBtn.selected = NO;
            
        }
        else
        {
            thisCell.checkBtn.selected = YES;
            [self.tempOrderArr addObject:thisCell.modelOrder];
        }
        
    }
    isAllSelect = !isAllSelect;
}

- (IBAction)packageAction:(id)sender {
    NSMutableArray * idArr = [NSMutableArray array];
    
    if (self.tempOrderArr.count == 0) {
        [self showCommonHUD:@"请选择订单!"];
        return;
    }
    for (ModelOrder * model in self.tempOrderArr) {
        [idArr addObject:model.orderId];
    }
    NSString * idStr = [AppUtils putArrToString:idArr];
    
    [self showDownloadsHUD:@"提交中..."];
    [[PNetworkOrder sharedManager]changeDiliveryOrderByOrderIds:idStr
                                                         userId:[UserDefaultUtils valueWithKey:@"branchUserId"]
                                                    orderStatus:@"3"
                                                        success:^(id result) {
                                                            [self dismissHUD];
                                                            [self showCommonHUD:@"提交成功!"];
                                                            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:nil afterDelay:1.5];
                                                            
                                                        } failure:^(id result) {
                                                            [self dismissHUD];
                                                            [self showCommonHUD:@"提交失败!"];
                                                            
                                                        }];
}

#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PDiliveryPackageOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"pDiliveryPackageOrderCell"];
    
    cell.modelOrder = self.orderArr[indexPath.row];
    [cell.checkBtn addTarget:self action:@selector(selectCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
    //============
//    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"退回订单"]];
//    NSRange contentRange = {0,[content length]};
//    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
//    [cell.backOrderBtn setTitle:(NSString *)content forState:UIControlStateNormal];
    //=================
    [cell.backOrderBtn addTarget:self action:@selector(backOrderACtion:) forControlEvents:UIControlEventTouchUpInside];
    [cell.removeOrderBtn addTarget:self action:@selector(removeOrderACtion:) forControlEvents:UIControlEventTouchUpInside];
    [self.cellArr addObject:cell];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
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
