//
//  PDeliverOrderDetailVC.m
//  DPH
//
//  Created by Cym on 16/3/9.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PDeliverOrderDetailVC.h"
#import "ModelOrder.h"
#import "PDeliverOrderDetailCell.h"
#import "PNetworkOrder.h"
#import "PDeliverPdtListVC.h"

@interface PDeliverOrderDetailVC ()
@property (nonatomic,strong)ModelOrder * modelOrder;
@end

@implementation PDeliverOrderDetailVC

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

-(void)callPhoneAction
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.modelOrder.deliveryPhone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}


#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 5;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 50+[AppUtils labelAutoCalculateRectWith:self.modelOrder.note lineSpacing:6 FontSize:14 MaxSize:CGSizeMake([AppUtils putScreenWidth]-65, 0)].height;
    }
    else if (indexPath.row == 1)
    {
        return 80;
    }
    else if (indexPath.row ==2)
    {
        return 115+[AppUtils labelAutoCalculateRectWith:self.modelOrder.deliveryAddress lineSpacing:6 FontSize:15 MaxSize:CGSizeMake([AppUtils putScreenWidth]-88, 0)].height;
    }
    else if (indexPath.row == 3)
    {
        
        return 45;
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
    PDeliverOrderDetailCell * cell = nil;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"PDeliverOrderDetailCell" owner:nil options:nil];
            cell = nibArray[0];
        }
        
        cell.orderCodeLab.text = self.modelOrder.orderNo;
        if ([self.modelOrder.note isEqualToString:@""]) {
            cell.remarkLab.text = @"无备注";
        }
        else
        {
            cell.remarkLab.text = self.modelOrder.note;
        }
        
        cell.timeLab.text = self.modelOrder.createTime;
        
        
    }
    else if (indexPath.row == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell) {
            NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"PDeliverOrderDetailCell" owner:nil options:nil];
            cell = nibArray[1];
        }
        cell.orderPriceLab.text = self.modelOrder.totalCost;
        cell.shouldPriceLab.text = self.modelOrder.totalCost;
    }
    else if (indexPath.row == 2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (!cell) {
            NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"PDeliverOrderDetailCell" owner:nil options:nil];
            cell = nibArray[2];
        }
        cell.nameLab.text = self.modelOrder.deliveryName;
        cell.phoneLab.text = self.modelOrder.deliveryPhone;
        cell.addressLab.text = self.modelOrder.deliveryAddress;
        [cell.callPhoneBtn addTarget:self action:@selector(callPhoneAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if (indexPath.row == 3)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
        if (!cell) {
            NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"PDeliverOrderDetailCell" owner:nil options:nil];
            cell = nibArray[3];
            
        }
        cell.numLab.text = self.modelOrder.num;
        
        
        
    }
    
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell5"];
        if (!cell) {
            NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"PDeliverOrderDetailCell" owner:nil options:nil];
            cell = nibArray[4];
            
        }
        cell.numLab.text = self.modelOrder.num;
        
        
        
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    if (indexPath.row == 3) {
        [self performSegueWithIdentifier:@"toPDeliverOrderProductList" sender:nil];
    }

    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toPDeliverOrderProductList"]) {
        PDeliverPdtListVC * pdtListView = [[PDeliverPdtListVC alloc]init];
        pdtListView = segue.destinationViewController;
        pdtListView.orderId = self.modelOrder.orderId;
        pdtListView.numStr = self.modelOrder.num;
        pdtListView.totalPriceStr = self.modelOrder.totalCost;
        pdtListView.name = self.modelOrder.deliveryName;
        pdtListView.code = self.modelOrder.orderNo;
        
    }
   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
