//
//  PCashRecordInfo.m
//  DPH
//
//  Created by Cym on 16/2/25.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PCashRecordInfo.h"
#import "PNetworkManage.h"
#import "ModelCashRecord.h"

@interface PCashRecordInfo ()
@property (weak, nonatomic) IBOutlet UILabel *orderIdLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *payWayLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (nonatomic, strong)ModelCashRecord * modelCashRecord;



@end

@implementation PCashRecordInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getCashRecord];
}

-(void)getCashRecord
{
    [self showDownloadsHUD:@"加载中..."];
    [[PNetworkManage sharedManager]getCashRecordDetailByRecordId:self.recordId
                                                         success:^(id result) {
                                                             [self dismissHUD];
                                                             self.modelCashRecord = [ModelCashRecord yy_modelWithDictionary:result];
                                                             [self initData];
                                                             
                                                         }
                                                         failure:^(id result) {
                                                             [self dismissHUD];
                                                             [self showCommonHUD:result];
                                                             
                                                         }];
}

-(void)initData
{
    self.orderIdLab.text = self.modelCashRecord.orderNo;
    self.dateLab.text = self.modelCashRecord.createTime;
    self.payWayLab.text = self.modelCashRecord.method;
    self.nameLab.text = self.modelCashRecord.fromAcctName;
    self.priceLab.text = self.modelCashRecord.paymentAmount;
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
