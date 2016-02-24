//
//  MsgVC.m
//  DPH
//
//  Created by cym on 16/1/26.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "MsgVC.h"
#import "DVSwitch.h"
#import "MsgListCell.h"
#import "NetworkMsg.h"
#import "ModelMsg.h"
#import "MsgDetailVC.h"

@interface MsgVC ()
{
    NSInteger page,type;
}
@property (nonatomic, strong)NSMutableArray * msgArr;

@end

@implementation MsgVC

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
    
    [self initTable];
    [self initSwitch];
    
    type = 1;
}


-(void)initTable
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self getMsgListByType:[NSString stringWithFormat:@"%ld",(long)type]];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page = page+1;
        [self getMsgListByType:[NSString stringWithFormat:@"%ld",(long)type]];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)initSwitch
{
    DVSwitch * mySwitch = [[DVSwitch alloc]initWithStringsArray:@[@"系统消息",@"订单消息"]] ;
    mySwitch.backgroundColor = [UIColor whiteColor];
    mySwitch.sliderColor = [UIColor colorWithHexString:@"3CA0E6"];
    mySwitch.labelTextColorInsideSlider = [UIColor whiteColor];
    mySwitch.labelTextColorOutsideSlider = [UIColor colorWithHexString:@"5f646e"];
    mySwitch.font = [UIFont systemFontOfSize:17];
    mySwitch.cornerRadius = 0;
    mySwitch.tag = 100;
    [self.mainView addSubview:mySwitch];
    
    [mySwitch setPressedHandler:^(NSUInteger index) {
        type = index+1;
        [self.tableView.mj_header beginRefreshing];
    }];
    mySwitch.translatesAutoresizingMaskIntoConstraints = NO;
    
    //水平约束
    [self.mainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[mySwitch]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(mySwitch)]];
    
    //垂直约束
    [self.mainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[mySwitch(35)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(mySwitch)]];
}


-(void)getMsgListByType:(NSString *)msgType
{
     NSString *pageNumber = [NSString stringWithFormat:@"%zd",page];
    [[NetworkMsg sharedManager]getMsgListByUserId:[UserDefaultUtils valueWithKey:@"userId"]
                                      messageType:msgType
                                           pageNo:pageNumber
                                          success:^(id result) {
                                              if ([pageNumber isEqualToString:@"1"]) {
                                                  self.msgArr = [NSMutableArray array];
                                              }
                                              NSMutableArray *arr = [NSMutableArray array];
                                              for (NSDictionary * msgDic in result) {
                                                  ModelMsg * msgDemo = [ModelMsg yy_modelWithDictionary:msgDic];
                                                  [arr addObject:msgDemo];
                                              }
                                              [self.msgArr addObjectsFromArray:arr];
                                              [self.tableView.mj_header endRefreshing];
                                              [self.tableView.mj_footer endRefreshing];
                                              if (arr.count == 0) {
                                                  [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                                  [self showCommonHUD:@"没有更多消息了!"];
                                              }

                                              [self.tableView reloadData];
                                              
                                              [self.tableView.mj_header endRefreshing];
                                              [self.tableView.mj_footer endRefreshing];
                                          }
                                          failure:^(id result) {
                                              [self.tableView.mj_header endRefreshing];
                                              [self.tableView.mj_footer endRefreshing];
                                              [self showCommonHUD:result];
                                          }];
    
}

#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.msgArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MsgListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"msgListCell"];
    if (!cell) {
        NSArray * nibArr = [[NSBundle mainBundle]loadNibNamed:@"MsgListCell" owner:self options:nil];
        cell = nibArr[0];
        
    }
    cell.modelMsg = self.msgArr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    [self performSegueWithIdentifier:@"toMsgDetail" sender:indexPath];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toMsgDetail"]) {
        MsgDetailVC * view = [[MsgDetailVC alloc]init];
        view = segue.destinationViewController;
        NSIndexPath * index = (NSIndexPath *)sender;
        view.modelMsg = self.msgArr[index.row];
        view.msgType = [NSString stringWithFormat:@"%ld",(long)type];
    }
}



@end
