//
//  PStaffManageVC.m
//  DPH
//
//  Created by Cym on 16/2/25.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PStaffManageVC.h"
#import "PStaffCell.h"
#import "PNetworkManage.h"
#import "ModelStaff.h"
#import "PStaffDetailVC.h"

@interface PStaffManageVC ()
{
    NSInteger page;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)ModelStaff * modelStaff;
@property (nonatomic, strong)NSMutableArray * staffArr;



@end

@implementation PStaffManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTable];
}

-(void)initTable
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self getStaffList];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page += 1;
        [self getStaffList];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    
}

-(void)getStaffList
{
    NSString *pageNumber = [NSString stringWithFormat:@"%zd",page];
    [[PNetworkManage sharedManager]getStaffListByPartnerId:[UserDefaultUtils valueWithKey:@"partnerId"]
                                                    pageNo:pageNumber
                                                   success:^(id result) {
                                                       if ([pageNumber isEqualToString:@"1"]) {
                                                           self.staffArr = [NSMutableArray array];
                                                       }
                                                       NSMutableArray *arr = [NSMutableArray array];
                                                       for (NSDictionary * staffDic in result) {
                                                           ModelStaff * staffDemo = [ModelStaff yy_modelWithDictionary:staffDic];
                                                           [arr addObject:staffDemo];
                                                       }
                                                       [self.staffArr addObjectsFromArray:arr];
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
    return self.staffArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PStaffCell * cell = [tableView dequeueReusableCellWithIdentifier:@"pStaffCell"];
    cell.modelStaff = self.staffArr[indexPath.row];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toStaffInfo" sender:indexPath];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toStaffInfo"]) {
        PStaffDetailVC * view = [[PStaffDetailVC alloc]init];
        view = segue.destinationViewController;
        NSIndexPath * index = (NSIndexPath *)sender;
        ModelStaff * model = self.staffArr[index.row];
        view.modelStaff = model;
    }
    
}


@end
