//
//  PdiliveryOrderVC.m
//  DPH
//
//  Created by Cym on 16/3/5.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PdiliveryOrderVC.h"
#import "DVSwitch.h"
#import "PDiliveryOrderListCell.h"
#import "PNetworkOrder.h"
#import "ModelOrder.h"

@interface PdiliveryOrderVC ()
{
    NSInteger page,type;
}

@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@property (nonatomic, strong)NSMutableArray * orderArr;
@property (nonatomic, strong)NSMutableArray * arriveOrderArr;

@end

@implementation PdiliveryOrderVC


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showtabbar" object:nil];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidetabbar" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    type = 3;
    [self initSwitch];
    [self initTable];
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
        [self getOrderList:type];
        
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page += 1;
        [self getOrderList:type];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}



-(void)initSwitch
{
    DVSwitch * mySwitch = [[DVSwitch alloc]initWithStringsArray:@[@"配送任务",@"已送达"]] ;
    mySwitch.backgroundColor = [UIColor whiteColor];
    mySwitch.sliderColor = [UIColor colorWithHexString:@"3CA0E6"];
    mySwitch.labelTextColorInsideSlider = [UIColor whiteColor];
    mySwitch.labelTextColorOutsideSlider = [UIColor colorWithHexString:@"5f646e"];
    mySwitch.font = [UIFont systemFontOfSize:17];
    mySwitch.cornerRadius = 0;
    mySwitch.tag = 100;
    [self.mainView addSubview:mySwitch];
    
    [mySwitch setPressedHandler:^(NSUInteger index) {
        if (index == 0) {
            type = 3;
            self.bottomBtn.hidden = NO;
            if (self.orderArr.count == 0) {
                [self.tableView.mj_header beginRefreshing];
            }
            else
            {
                [self.tableView reloadData];
            }

        }
        else
        {
            type = 6;
            self.bottomBtn.hidden = YES;
            if (self.arriveOrderArr.count == 0) {
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
    [self.mainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[mySwitch]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(mySwitch)]];
    
    //垂直约束
    [self.mainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[mySwitch(35)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(mySwitch)]];
}

- (IBAction)bottomBtnAction:(id)sender {
    if (self.orderArr.count == 0) {
        [self showCommonHUD:@"没有可出发的订单!"];
        return;
    }
    NSMutableArray * idArr = [NSMutableArray array];
    for (ModelOrder * thisModel in self.orderArr) {
        [idArr addObject:thisModel.orderId];
    }
    NSString * idStr = [AppUtils putArrToString:idArr];
    
    NSInteger orderStatus;
    
     [self showDownloadsHUD:@"提交中..."];
    
    if ([UserDefaultUtils valueWithKey:@"isLeave"]) {
        //已经出发 调用送达的请求
        orderStatus = 6;
    }
    else
    {
        //还未出发，调用出发的请求
        orderStatus = 5;
        
    }
    
    [[PNetworkOrder sharedManager]changeDiliveryOrderByOrderIds:idStr
                                                         userId:[UserDefaultUtils valueWithKey:@"branchUserId"]
                                                    orderStatus:[NSString stringWithFormat:@"%ld",(long)orderStatus]
                                                        success:^(id result) {
                                                            [self dismissHUD];
                                                            if (orderStatus == 5) {
                                                                [UserDefaultUtils saveBoolValue:YES withKey:@"isLeave"];
                                                                [self.bottomBtn setTitle:@"已送达" forState:UIControlStateNormal];
                                                            }
                                                            else
                                                            {
                                                                [UserDefaultUtils saveBoolValue:NO withKey:@"isLeave"];
                                                                [self.bottomBtn setTitle:@"出发" forState:UIControlStateNormal];
                                                            }
                                                            
                                                            [self.tableView.mj_header beginRefreshing];
                                                            [self showCommonHUD:@"提交成功!"];
                                                            
                                                        }
                                                        failure:^(id result) {
                                                            [self dismissHUD];
                                                            [self showCommonHUD:@"提交失败!"];
                                                            
                                                        }];
    NSLog(@"出发");
}


-(void)getOrderList:(NSInteger)typeNum
{
    NSString *pageNumber = [NSString stringWithFormat:@"%zd",page];
    
    
    [[PNetworkOrder sharedManager] getDilliveryOrderListByUserId:[UserDefaultUtils valueWithKey:@"branchUserId"]
                                                     orderStatus:[NSString stringWithFormat:@"%ld",(long)typeNum]
                                                          pageNo:pageNumber
                                                         success:^(id result) {
                                                             if ([pageNumber isEqualToString:@"1"]) {
                                                                 if (type == 3) {
                                                                     self.orderArr = [NSMutableArray array];
                                                                 }
                                                                 else
                                                                 {
                                                                     self.arriveOrderArr = [NSMutableArray array];
                                                                 }
                                                                 
                                                             }
                                                             NSMutableArray *arr = [NSMutableArray array];
                                                             for (NSDictionary * orderDic in result) {
                                                                 ModelOrder * orderDemo = [ModelOrder yy_modelWithDictionary:orderDic];
                                                                 [arr addObject:orderDemo];
                                                             }
                                                             if (type == 3) {
                                                                 [self.orderArr addObjectsFromArray:arr];
                                                             }
                                                             else
                                                             {
                                                                 [self.arriveOrderArr addObjectsFromArray:arr];
                                                             }
                                                             
                                                             
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


#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (type == 3) {
        return self.orderArr.count;
    }
    else 
    {
        return self.arriveOrderArr.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PDiliveryOrderListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"pDiliveryOrderListCell"];
    if (!cell) {
        NSArray * nibArr = [[NSBundle mainBundle]loadNibNamed:@"PDiliveryOrderListCell" owner:self options:nil];
        cell = nibArr[0];
    }
    if (type == 3) {
    
        cell.modelOrder = self.orderArr[indexPath.row];
    }
    else
    {
        cell.modelOrder = self.arriveOrderArr[indexPath.row];
    }
    
    
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
