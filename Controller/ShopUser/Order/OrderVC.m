//
//  OrderVC.m
//  DPH
//
//  Created by cym on 16/1/26.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "OrderVC.h"
#import "DVSwitch.h"
#import "UIColor+TenSixColor.h"
#import "OrderListCell.h"
#import <MJRefresh/MJRefresh.h>
#import "NetworkOrder.h"
#import "UserDefaultUtils.h"
#import "ModelOrder.h"
#import <YYModel.h>
#import "OrderDetailVC.h"

@interface OrderVC ()
{
    NSInteger page,type;
    
}
@property (nonatomic ,strong)NSMutableArray * notFinishOrderArr;//未完成
@property (nonatomic ,strong)NSMutableArray * finishOrderArr;//已完成
@property (nonatomic ,strong)NSMutableArray * invalidOrderArr;//已作废

@end

@implementation OrderVC

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
    [self initSwitch];
    [self initTable];
    
    type = 6;

}

-(void)initTable
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self getOrderListByType:[NSString stringWithFormat:@"%ld",(long)type]];

    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page += 1;
        [self getOrderListByType:[NSString stringWithFormat:@"%ld",(long)type]];

    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)initSwitch
{
    DVSwitch * mySwitch = [[DVSwitch alloc]initWithStringsArray:@[@"未完成",@"已完成",@"已作废"]] ;
    mySwitch.backgroundColor = [UIColor whiteColor];
    mySwitch.sliderColor = [UIColor colorWithHexString:@"3CA0E6"];
    mySwitch.labelTextColorInsideSlider = [UIColor whiteColor];
    mySwitch.labelTextColorOutsideSlider = [UIColor colorWithHexString:@"5f646e"];
    mySwitch.font = [UIFont systemFontOfSize:17];
    mySwitch.cornerRadius = 0;
    mySwitch.tag = 100;
    [self.mainView addSubview:mySwitch];
    
    [mySwitch setPressedHandler:^(NSUInteger index) {
        type = index+6;
        if (type == 6) {
            if (self.notFinishOrderArr.count == 0) {
                [self.tableView.mj_header beginRefreshing];
            }
            else
            {
                [self.tableView reloadData];
            }
        }
        else if (type == 7)
        {
            if (self.finishOrderArr.count == 0) {
                [self.tableView.mj_header beginRefreshing];
            }
            else
            {
                [self.tableView reloadData];
            }

        }
        else
        {
            if (self.invalidOrderArr.count == 0) {
                [self.tableView.mj_header beginRefreshing];
            }
            else
            {
                [self.tableView reloadData];
            }
        }
        
        [self.tableView reloadData];
    }];
    mySwitch.translatesAutoresizingMaskIntoConstraints = NO;
    
    //水平约束
    [self.mainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[mySwitch]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(mySwitch)]];
    
    //垂直约束
    [self.mainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[mySwitch(35)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(mySwitch)]];
}


-(void)getOrderListByType:(NSString *)typeNum
{
    NSString *pageNumber = [NSString stringWithFormat:@"%zd",page];
    [[NetworkOrder sharedManager]getOrderListByUserId:[UserDefaultUtils valueWithKey:@"userId"]
                                                state:typeNum
                                               pageNo:pageNumber
                                              success:^(id result) {
                                                  if ([pageNumber isEqualToString:@"1"]) {
                                                      switch ([typeNum integerValue]) {
                                                          case 6:
                                                          {
                                                              self.notFinishOrderArr = [NSMutableArray array];
                                                          }
                                                              break;
                                                          case 7:
                                                          {
                                                              self.finishOrderArr = [NSMutableArray array];
                                                          }
                                                              break;
                                                          case 8:
                                                          {
                                                              self.invalidOrderArr = [NSMutableArray array];
                                                          }
                                                              break;
                                                              
                                                          default:
                                                              break;
                                                      }
                                                      
                                                  }
                                                  NSMutableArray *arr = [NSMutableArray array];
                                                  for (NSDictionary * orderDic in result) {
                                                      ModelOrder * orderDemo = [ModelOrder yy_modelWithDictionary:orderDic];
                                                      [arr addObject:orderDemo];
                                                  }
                                                  
                                                  switch ([typeNum integerValue]) {
                                                      case 6:
                                                      {
                                                          [self.notFinishOrderArr addObjectsFromArray:arr];
                                                      }
                                                          break;
                                                      case 7:
                                                      {
                                                          [self.finishOrderArr addObjectsFromArray:arr];
                                                      }
                                                          break;
                                                      case 8:
                                                      {
                                                          [self.invalidOrderArr addObjectsFromArray:arr];
                                                      }
                                                          break;
                                                          
                                                      default:
                                                          break;
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

    if (type == 6) {
        return self.notFinishOrderArr.count;
    }
    else if (type == 7)
    {
        return self.finishOrderArr.count;
    }
    else
    {
        return self.invalidOrderArr.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"orderListCell"];
    if (!cell) {
        NSArray * nibArr = [[NSBundle mainBundle]loadNibNamed:@"OrderListCell" owner:self options:nil];
        cell = nibArr[0];
    }
    
    if (type == 6) {
        cell.modelOrder = self.notFinishOrderArr[indexPath.row];
    }
    else if (type == 7)
    {
        cell.modelOrder = self.finishOrderArr[indexPath.row];
    }
    else
    {
        cell.modelOrder = self.invalidOrderArr[indexPath.row];
    }

    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    [self performSegueWithIdentifier:@"toOrderDetail" sender:indexPath];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toOrderDetail"]) {
        OrderDetailVC * view = [[OrderDetailVC alloc]init];
        view = segue.destinationViewController;
        NSIndexPath * index = (NSIndexPath *)sender;
        ModelOrder * model = [[ModelOrder alloc]init];
        if (type == 6) {
            model = self.notFinishOrderArr[index.row];
        }
        else if (type == 7)
        {
            model = self.finishOrderArr[index.row];
        }
        else
        {
            model = self.invalidOrderArr[index.row];
        }

        
        view.orderId = model.orderId;
        
    }

}

@end
