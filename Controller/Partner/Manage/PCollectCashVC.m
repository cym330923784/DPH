//
//  PCollectCashVC.m
//  DPH
//
//  Created by Cym on 16/2/24.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PCollectCashVC.h"
#import "PCollectCashCell.h"
#import "PNetworkManage.h"
#import "ModelCashRecordTotalDemo.h"
#import "ModelCashRecord.h"
#import "PCashRecordInfo.h"

@interface PCollectCashVC ()
{
    NSInteger page;
}


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *endDateLab;
@property (weak, nonatomic) IBOutlet UILabel *cashNumLab;
@property (weak, nonatomic) IBOutlet UILabel *cashValueLab;

@property (nonatomic, strong)ModelCashRecordTotalDemo * modelTotalDemo;
@property (nonatomic, strong)ModelCashRecord * modelCashRecord;
@property (nonatomic,strong)NSMutableArray * cashRecordArr;

@end

@implementation PCollectCashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    page = 1;
    [self initTable];
    [self getTotal];
    
}

-(void)initTable
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self getCashRecordList];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page += 1;
        [self getCashRecordList];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    
}


-(void)getTotal
{
    [self showDownloadsHUD:@"加载中..."];
    [[PNetworkManage sharedManager]getCashTotalByPartnerId:[UserDefaultUtils valueWithKey:@"partnerId"]
                                             beginDate:@"1"
                                               endDate:@"2"
                                               success:^(id result) {
                                                   [self dismissHUD];
                                                   self.modelTotalDemo = [ModelCashRecordTotalDemo yy_modelWithDictionary:result];
                                                   self.endDateLab.text=  self.modelTotalDemo.beginDate;
                                                   self.cashNumLab.text = [NSString stringWithFormat:@"%@笔",self.modelTotalDemo.countNum];
                                                   self.cashValueLab.text = [NSString stringWithFormat:@"¥%.2lf",[self.modelTotalDemo.totalCost floatValue]];
                                                   
                                               }
                                               failure:^(id result) {
                                                   [self dismissHUD];
                                                   [self showCommonHUD:result];
                                                   
                                               }];
    
}

-(void)getCashRecordList
{
    NSString *pageNumber = [NSString stringWithFormat:@"%zd",page];
    [[PNetworkManage sharedManager]getCashRecordListByPartnerId:[UserDefaultUtils valueWithKey:@"partnerId"]
                                                  beginDate:@"1"
                                                    endDate:@"2"
                                                     pageNo:pageNumber
                                                    success:^(id result) {
                                                        if ([pageNumber isEqualToString:@"1"]) {
                                                            self.cashRecordArr = [NSMutableArray array];
                                                        }
                                                        NSMutableArray *arr = [NSMutableArray array];
                                                        for (NSDictionary * reportDic in result) {
                                                            ModelCashRecord * recordDemo = [ModelCashRecord yy_modelWithDictionary:reportDic];
                                                            [arr addObject:recordDemo];
                                                        }
                                                        [self.cashRecordArr addObjectsFromArray:arr];
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
    return self.cashRecordArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PCollectCashCell * cell = [tableView dequeueReusableCellWithIdentifier:@"pCollectCashCell"];
    cell.modelCashRecord = self.cashRecordArr[indexPath.row];
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toCashRecordInfo" sender:indexPath];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toCashRecordInfo"]) {
        PCashRecordInfo * view = [[PCashRecordInfo alloc]init];
        view = segue.destinationViewController;
        NSIndexPath * index = (NSIndexPath *)sender;
        ModelCashRecord * model = self.cashRecordArr[index.row];
        view.recordId = model.recordId;
    }

}


@end
