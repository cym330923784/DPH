//
//  POrderVC.m
//  DPH
//
//  Created by cym on 16/1/29.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "POrderVC.h"
#import "DVSwitch.h"
#import "POrderListCell.h"
#import "PNetworkOrder.h"
#import "ModelOrder.h"
#import "POrderDetailVC.h"
#import "UIColor+TenSixColor.h"

@interface POrderVC ()
{
    NSInteger page,type;
}

@property (weak, nonatomic) IBOutlet UIButton *filterBtn;//筛选btn
@property (weak, nonatomic) IBOutlet UIView *filterView;

@property (nonatomic ,strong)NSMutableArray * notFinishOrderArr;//未完成
@property (nonatomic ,strong)NSMutableArray * finishOrderArr;//已完成
@property (nonatomic ,strong)NSMutableArray * invalidOrderArr;//已作废

@end

@implementation POrderVC

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
    type = 6;
    [self initSwitch];
    [self initTable];
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
    
    [[PNetworkOrder sharedManager]getOrderListByPartnerId:[UserDefaultUtils valueWithKey:@"partnerId"]
                                              orderStatus:typeNum
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

//筛选
- (IBAction)filterAction:(id)sender {
    
     NSArray *titles = @[@"未审核", @"未装箱", @"为配送", @"未付款"];
    
    
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil                                                                             message: nil                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    [self addActionTarget:alertController titles:titles];
    [self addCancelActionTarget:alertController title:@"取消"];
    
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"未付款" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        
//    }];
//    [action setValue:[UIColor colorWithHexString:@"#7d7d7d"] forKey:@"_titleTextColor"];
//    [alertController addAction:action];
//    
//    //添加Button
//    [alertController addAction: [UIAlertAction actionWithTitle: @"未审核" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        [self.filterBtn setTitle:@"未审核" forState:UIControlStateNormal];
//    }]];
//    [alertController addAction: [UIAlertAction actionWithTitle: @"未装箱" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//        [self.filterBtn setTitle:@"未装箱" forState:UIControlStateNormal];
//        
//    }]];
//    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: alertController animated: YES completion: nil];
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
    POrderListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"pOrderListCell"];
    if (!cell) {
        NSArray * nibArr = [[NSBundle mainBundle]loadNibNamed:@"POrderListCell" owner:self options:nil];
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
    [self performSegueWithIdentifier:@"toPOrderDetail" sender:indexPath];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertController 方法

// 添加其他按钮
- (void)addActionTarget:(UIAlertController *)alertController titles:(NSArray *)titles
{
    for (NSString *title in titles) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self.filterBtn setTitle:action.title forState:UIControlStateNormal];
        }];
        [action setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
        [alertController addAction:action];
    }
}

// 取消按钮
- (void)addCancelActionTarget:(UIAlertController *)alertController title:(NSString *)title
{
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [action setValue:[UIColor lightGrayColor] forKey:@"_titleTextColor"];
    [alertController addAction:action];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toPOrderDetail"]) {
        POrderDetailVC * view = [[POrderDetailVC alloc]init];
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
