//
//  PReportVC.m
//  DPH
//
//  Created by cym on 16/1/29.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PReportVC.h"
#import "PReportCell.h"
#import "PNetworkReport.h"
#import "ModelReportDemo.h"
#import "AppDelegate.h"

@interface PReportVC ()
{
    NSInteger page;
}

@property (weak, nonatomic) IBOutlet UILabel *endDateLab;
@property (weak, nonatomic) IBOutlet UILabel *totalOrderNumLab;
@property (weak, nonatomic) IBOutlet UILabel *totalClientNumLab;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLab;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)ModelReportDemo * modelTotalData;
@property (nonatomic,strong)NSMutableArray * reportArr;

@end

@implementation PReportVC

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
    page = 1;
    [self initTable];
    [self getTotal];
    
}
//- (IBAction)cancelAction:(id)sender {
//    NSLog(@"注销账号");
//    
//    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您是否确认退出当前账号?" preferredStyle:UIAlertControllerStyleAlert];
//    
//    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [UserDefaultUtils saveValue:@"0" forKey:@"isLogin"];
//        [UserDefaultUtils removeValueWithKey:@"partnerId"];
//        
//        UIStoryboard *board         = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//        UINavigationController * firstNav = [board instantiateViewControllerWithIdentifier:@"NavLogin"];
//        
//        AppDelegate *delete =  (AppDelegate *)[UIApplication sharedApplication].delegate;
//        delete.window.rootViewController = firstNav;
//        
//        
//        
//        
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//    }]];
//    [self presentViewController:alert animated:YES completion:nil];
//}

-(void)initTable
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self getReportList];
        
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page += 1;
        [self getReportList];
    }];
    [self.tableView.mj_header beginRefreshing];

    
}

-(void)getTotal
{
    [self showDownloadsHUD:@"加载中..."];
    [[PNetworkReport sharedManager]getTotalByPartnerId:[UserDefaultUtils valueWithKey:@"partnerId"]
                                             beginDate:@"1"
                                               endDate:@"2"
                                               success:^(id result) {
                                                   [self dismissHUD];
                                                   self.modelTotalData = [ModelReportDemo yy_modelWithDictionary:result];
                                                   self.endDateLab.text=  self.modelTotalData.beginDate;
                                                   self.totalOrderNumLab.text = [NSString stringWithFormat:@"%@笔",self.modelTotalData.countNum];
                                                   self.totalClientNumLab.text=[NSString stringWithFormat:@"%@位",self.modelTotalData.endClientNum] ;
                                                   self.totalPriceLab.text = [NSString stringWithFormat:@"¥%.2lf",[self.modelTotalData.totalCost floatValue]];
                                                   
                                               }
                                               failure:^(id result) {
                                                   [self dismissHUD];
                                                   [self showCommonHUD:result];
                                                   
                                               }];
    
}

-(void)getReportList
{
    NSString *pageNumber = [NSString stringWithFormat:@"%zd",page];
    [[PNetworkReport sharedManager]getReportListByPartnerId:[UserDefaultUtils valueWithKey:@"partnerId"]
                                                  beginDate:@"1"
                                                    endDate:@"2"
                                                     pageNo:pageNumber
                                                    success:^(id result) {
                                                        if ([pageNumber isEqualToString:@"1"]) {
                                                            self.reportArr = [NSMutableArray array];
                                                        }
                                                        NSMutableArray *arr = [NSMutableArray array];
                                                        for (NSDictionary * reportDic in result) {
                                                            ModelReportDemo * reportDemo = [ModelReportDemo yy_modelWithDictionary:reportDic];
                                                            [arr addObject:reportDemo];
                                                        }
                                                        [self.reportArr addObjectsFromArray:arr];
                                                        [self.tableView.mj_header endRefreshing];
                                                        [self.tableView.mj_footer endRefreshing];
                                                        if (arr.count == 0) {
                                                            [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                                            [self showCommonHUD:@"没有更多记录了!"];
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
    return self.reportArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PReportCell * cell = [tableView dequeueReusableCellWithIdentifier:@"pReportCell"];
    cell.modelReportDemo = self.reportArr[indexPath.row];
    return cell;
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
