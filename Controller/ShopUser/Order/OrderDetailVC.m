//
//  OrderDetailVC.m
//  DPH
//
//  Created by cym on 16/1/28.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "OrderDetailVC.h"
#import "OrderDetailCell.h"
#import "NetworkOrder.h"
#import "ModelOrder.h"
#import <YYModel.h>
#import "OrderProductListVC.h"
#import "Cym_PHD.h"
#import "UserDefaultUtils.h"
#import "UIColor+TenSixColor.h"
#import <MJRefresh/MJRefresh.h>

@interface OrderDetailVC ()

@property (nonatomic, strong)ModelOrder * modelOrder;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation OrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTable];
}

-(void)initTable
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getOrderDetail];
        
    }];
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)getOrderDetail
{
    [self showDownloadsHUD:@"加载中..."];
    [[NetworkOrder sharedManager] getOrderDetailByOrderId:self.orderId
                                                  success:^(id result) {
                                                      [self dismissHUD];
                                                      self.modelOrder = [ModelOrder yy_modelWithDictionary:result];
                                                      [self.tableView reloadData];
                                                      [self.tableView.mj_header endRefreshing];
                                                      if ([self.modelOrder.orderStatus intValue] != 5) {
                                                          self.confirmBtn.backgroundColor = [UIColor lightGrayColor];
                                                          self.confirmBtn.enabled = NO;
                                                      }
                                                      else
                                                      {
                                                          self.confirmBtn.backgroundColor = [UIColor colorWithHexString:@"3CA000"];
                                                          self.confirmBtn.enabled = YES;
                                                      }
                                                      
                                                  }
                                                  failure:^(id result) {
                                                      [self dismissHUD];
                                                      [self showCommonHUD:result];
                                                      
                                                      [self.tableView.mj_header endRefreshing];
                                                      
                                                  }];
}
- (IBAction)finishReceiveAction:(id)sender {
    
    [[NetworkOrder sharedManager] confirmReceiveByOrderId:self.modelOrder.orderId
                                              endClientId:[UserDefaultUtils valueWithKey:@"userId"]
                                                  success:^(id result) {
                                                      [Cym_PHD showSuccess:@"确认收货成功!"];
                                                      self.confirmBtn.backgroundColor = [UIColor lightGrayColor];
                                                      self.confirmBtn.enabled = NO;
                                                      
                                                      [self getOrderDetail];
                                                      
                                                  }
                                                  failure:^(id result) {
                                                      
                                                  }];
    
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 5;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 140;
    }
    else if (indexPath.row == 1)
    {
        return 130;
    }
    else if (indexPath.row ==2)
    {
        return 105;
    }
    else
    {
        return 45;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     OrderDetailCell * cell = nil;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"OrderDetailCell" owner:nil options:nil];
            cell = nibArray[0];
        }
        
        if ([self.modelOrder.orderStatus isEqualToString:@"1"]||[self.modelOrder.orderStatus isEqualToString:@"2"]||[self.modelOrder.orderStatus isEqualToString:@"3"]||[self.modelOrder.orderStatus isEqualToString:@"4"]) {
            cell.stateLab.text = @"订单处理中";
        }
        else if ([self.modelOrder.orderStatus isEqualToString:@"5"])
        {
            cell.stateLab.text = @"已发货";
        }
        else if ([self.modelOrder.orderStatus isEqualToString:@"6"])
        {
            cell.stateLab.text = @"已签收";
        }
        else if ([self.modelOrder.orderStatus isEqualToString:@"7"])
        {
            cell.stateLab.text = @"已完成";
        }
        else
        {
            cell.stateLab.text = @"已作废";
        }
        
        cell.orderIdLab.text = self.modelOrder.orderId;
        if ([self.modelOrder.note isEqualToString:@""]) {
            cell.remarkLab.text = @"无备注";
        }
        else
        {
            cell.remarkLab.text = self.modelOrder.note;
        }
 
        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
////        [formatter setDateStyle:NSDateFormatterMediumStyle];
////        [formatter setTimeStyle:NSDateFormatterShortStyle];
//        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[self.modelOrder.cTime  integerValue]];
//        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        cell.timeLab.text = self.modelOrder.cTime;
        
    }
    else if (indexPath.row == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell) {
            NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"OrderDetailCell" owner:nil options:nil];
            cell = nibArray[1];
        }
        cell.orederPriceLab.text = self.modelOrder.totalCost;
        cell.proPriceLab.text = self.modelOrder.totalCost;
        cell.noPayPriceLab.text = self.modelOrder.totalCost;
        if ([self.modelOrder.paymentStatus isEqualToString:@"0"]) {
            cell.payStateLab.text = @"未付款";
        }
        else
        {
            cell.payStateLab.text = @"已付款";
        }
    }
    else if (indexPath.row == 2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (!cell) {
            NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"OrderDetailCell" owner:nil options:nil];
            cell = nibArray[2];
        }
        cell.nameLab.text = self.modelOrder.deliveryName;
        cell.phoneLab.text = self.modelOrder.deliveryPhone;
        cell.addressLab.text = self.modelOrder.deliveryAddress;
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
        if (!cell) {
            NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"OrderDetailCell" owner:nil options:nil];
            cell = nibArray[3];

        }
        cell.numLab.text = self.modelOrder.num;
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    [self performSegueWithIdentifier:@"toOrderProductList" sender:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toOrderProductList"]) {
        OrderProductListVC * view = [[OrderProductListVC alloc]init];
        view = segue.destinationViewController;
        view.orderId = self.modelOrder.orderId;
        view.numStr = self.modelOrder.num;
        view.totalPriceStr = self.modelOrder.totalCost;
        
    }
}


@end
