//
//  POrderDetailVC.m
//  DPH
//
//  Created by cym on 16/1/31.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "POrderDetailVC.h"
#import "POrderDetailCell.h"
#import "PNetworkOrder.h"
#import "ModelOrder.h"
#import <YYModel.h>
#import "POrderPdtListVC.h"
#import "PAddPayWayVC.h"
#import "UserDefaultUtils.h"
#import <MJRefresh/MJRefresh.h>
#import "UIColor+TenSixColor.h"

@interface POrderDetailVC ()

@property (nonatomic,strong)ModelOrder * modelOrder;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;



@end

@implementation POrderDetailVC

-(void)viewWillAppear:(BOOL)animated
{
    if (self.payment != nil) {
        NSIndexPath * payIndex = [NSIndexPath indexPathForRow:3 inSection:0];
        POrderDetailCell * thisCell = [self.tableView cellForRowAtIndexPath:payIndex];
        thisCell.numLab.hidden = NO;
        thisCell.numLab.text = self.payment;
        thisCell.jiantouImg.hidden = YES;
        thisCell.titleLab.text = @"已付款";
    }
}

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
    [[PNetworkOrder sharedManager] getOrderDetailByOrderId:self.orderId
                                                   success:^(id result) {
                                                       [self dismissHUD];
                                                       self.modelOrder = [ModelOrder yy_modelWithDictionary:result];
                                                       
                                                       [self.tableView reloadData];
                                                       [self.tableView.mj_header endRefreshing];
                                                       
                                                   }
                                                   failure:^(id result) {
                                                       [self dismissHUD];
                                                       [self showCommonHUD:result];
                                                       
                                                       [self.tableView.mj_header endRefreshing];
                                                       
                                                   }];
}

- (IBAction)updateOrderStatus:(id)sender {
    [self showDownloadsHUD:@"提交中..."];
    NSLog(@"%@",self.modelOrder.orderStatus);
    NSString * statusStr = [NSString string];
    UIButton * thisBtn = (UIButton *)sender;
    NSString * titleStr = thisBtn.titleLabel.text;
    if (thisBtn.tag == 1001) {
        statusStr = @"8";
    }
    else
    {
        statusStr = self.modelOrder.orderStatus;
    }
    [[PNetworkOrder sharedManager]updateOrderStatusByOrderId:self.modelOrder.orderId
                                                   partnerId:[UserDefaultUtils valueWithKey:@"partnerId"]
                                                 orderStatus:statusStr
                                                     success:^(id result) {
                                                         [self dismissHUD];
                                                         [self showCommonHUD:[NSString stringWithFormat:@"%@成功!",titleStr]];
                                                         self.modelOrder = [ModelOrder yy_modelWithDictionary:result];
                                                         
                                                         [self.tableView reloadData];
                                                     }
                                                     failure:^(id result) {
                                                         [self dismissHUD];
                                                         [self showCommonHUD:@"提交失败!"];
                                                         
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
        return 80;
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
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    POrderDetailCell * cell = nil;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"POrderDetailCell" owner:nil options:nil];
            cell = nibArray[0];
        }
        
        cell.stateLab.text = [self checkOrderStatus];
        cell.orderIdLab.text = self.modelOrder.orderNo;
        if ([self.modelOrder.note isEqualToString:@""]) {
            cell.remarkLab.text = @"无备注";
        }
        else
        {
            cell.remarkLab.text = self.modelOrder.note;
        }
        
        cell.timeLab.text = self.modelOrder.cTime;

        
    }
    else if (indexPath.row == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell) {
            NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"POrderDetailCell" owner:nil options:nil];
            cell = nibArray[1];
        }
        cell.orderPriceLab.text = self.modelOrder.totalCost;
        cell.proPriceLab.text = self.modelOrder.totalCost;
    }
    else if (indexPath.row == 2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (!cell) {
            NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"POrderDetailCell" owner:nil options:nil];
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
            NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"POrderDetailCell" owner:nil options:nil];
            cell = nibArray[3];
            
        }
        cell.numLab.text = self.modelOrder.num;
        if (indexPath.row == 3) {
            NSLog(@"%@",self.modelOrder.paymentStatus);
            if ([self.modelOrder.paymentStatus isEqualToString:@"0"]) {
                cell.numLab.hidden = YES;
                cell.titleLab.text = @"添加付款记录";
                cell.jiantouImg.hidden = NO;
            }
            else
            {
                cell.jiantouImg.hidden = YES;
                cell.titleLab.text = @"已付款";
                cell.numLab.text = self.modelOrder.method;
            }
            
        }
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
//    [self performSegueWithIdentifier:@"toOrderProductList" sender:nil];
    if (indexPath.row == 4) {
        [self performSegueWithIdentifier:@"toPOrderProductList" sender:nil];
    }
    else if(indexPath.row == 3)
    {
        [self performSegueWithIdentifier:@"toAddPayWay" sender:nil];
    }
    
}

-(NSString *)checkOrderStatus
{
    
    self.invalidBtn.hidden = NO;
    self.rightBtn.hidden = NO;
    if ([self.modelOrder.orderStatus isEqualToString:@"1"]) {
        [self.rightBtn setTitle:@"订单审核" forState:UIControlStateNormal];
        return @"订单审核中";
    }
    else if ([self.modelOrder.orderStatus isEqualToString:@"2"])
    {
        [self.rightBtn setTitle:@"财务审核" forState:UIControlStateNormal];
        return @"财务审核中";
    }
    else if ([self.modelOrder.orderStatus isEqualToString:@"3"])
    {
        [self.rightBtn setTitle:@"出库审核" forState:UIControlStateNormal];
        return @"出库审核中";
    }
    else if ([self.modelOrder.orderStatus isEqualToString:@"4"])
    {
        [self.rightBtn setTitle:@"发单审核" forState:UIControlStateNormal];
        return @"发单审核中";
    }
    else if ([self.modelOrder.orderStatus isEqualToString:@"5"])
    {
        [self changeRightBtn];
        return @"已发货";
    }
    else if ([self.modelOrder.orderStatus isEqualToString:@"6"])
    {
        [self changeRightBtn];
        return @"已签收";
    }
    else if ([self.modelOrder.orderStatus isEqualToString:@"7"])
    {
        self.invalidBtn.hidden = YES;
        self.rightBtn.hidden = YES;
        return @"已完成";
    }
    else
    {
        
        self.invalidBtn.hidden = YES;
        self.rightBtn.hidden = YES;
        return @"已作废";
    }

}
-(void)changeRightBtn
{
    [self.rightBtn setTitle:@"订单审核完成" forState:UIControlStateNormal];
    [self.rightBtn setBackgroundColor:[UIColor lightGrayColor]];
    [self.rightBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.rightBtn.enabled = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toPOrderProductList"]) {
        POrderPdtListVC * pdtListView = [[POrderPdtListVC alloc]init];
        pdtListView = segue.destinationViewController;
        pdtListView.orderId = self.modelOrder.orderId;
        pdtListView.numStr = self.modelOrder.num;
        pdtListView.totalPriceStr = self.modelOrder.totalCost;
        
    }
    else if ([segue.identifier isEqualToString:@"toAddPayWay"]){
        PAddPayWayVC * paymentView = [[PAddPayWayVC alloc]init];
        paymentView = segue.destinationViewController;
        paymentView.orderId = self.modelOrder.orderId;
        
    }
}


@end