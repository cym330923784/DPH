//
//  PAddPayWayVC.m
//  DPH
//
//  Created by cym on 16/2/1.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PAddPayWayVC.h"
#import "DatePickerView.h"
#import "ModelPayWay.h"
#import "PNetworkOrder.h"
#import "POrderDetailVC.h"

@interface PAddPayWayVC ()

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (nonatomic,strong)ModelPayWay * modelPayWay;

@end

@implementation PAddPayWayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
    self.modelPayWay = [[ModelPayWay alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateDate:) name:@"dateFinish" object:nil];
}

-(void)initView
{
    if (![AppUtils userAuthJudgeBy:AUTH_add_paymentHistory]) {
        self.saveBtn.hidden = YES;
        self.nameTF.text = @"-";
        [self.dateBtn setTitle:@"-" forState:UIControlStateNormal];
        [self.payWayBtn setTitle:@"-" forState:UIControlStateNormal];
        self.nameTF.userInteractionEnabled = NO;
        self.dateBtn.userInteractionEnabled = NO;
        self.payWayBtn.userInteractionEnabled = NO;
    }
}

- (IBAction)saveAction:(id)sender {
    if ([self.nameTF.text isEqualToString:@""]||[self.dateBtn.titleLabel.text isEqualToString:@"请选择日期"]||[self.payWayBtn.titleLabel.text isEqualToString:@"请选择付款方式"]) {
        [self showCommonHUD:@"请完善付款信息!"];
        return;
    }
    
    self.modelPayWay.orderId = self.orderId;
    self.modelPayWay.fromAcctName = self.nameTF.text;
    self.modelPayWay.paymentTimeStamp = self.dateBtn.titleLabel.text;
    self.modelPayWay.method = self.payWayBtn.titleLabel.text;
    [self showDownloadsHUD:@"保存中..."];
    
    [[PNetworkOrder sharedManager]addPaymentByObject:self.modelPayWay
                                             success:^(id result) {
                                                 [self dismissHUD];
                                                 [self showCommonHUD:@"保存成功!"];
                                                 NSArray *array =self.navigationController.viewControllers;
                                                 POrderDetailVC * pOrderDetailView = [array objectAtIndex:1];
                                                 pOrderDetailView.payment = self.modelPayWay.method;
                                                 [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:nil afterDelay:2];
                                             }
                                             failure:^(id result) {
                                                 [self dismissHUD];
                                                 [self showCommonHUD:@"保存失败!"];
                                             }];
    
}


-(void)updateDate:(NSNotification *)noti
{
    NSDictionary *dic = [noti userInfo];
    NSString * timeStr = dic[@"date"];
    [self.dateBtn setTitle:[NSString stringWithFormat:@"%@",timeStr] forState:UIControlStateNormal];
}

- (IBAction)chooseDateAction:(id)sender {
    
    DatePickerView * dateView = [[DatePickerView alloc]init];
    
    
    [dateView show];
}

- (IBAction)choosePayWayAction:(id)sender {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil                                                                             message: nil                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    //添加Button
    [alertController addAction: [UIAlertAction actionWithTitle: @"现金支付" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.payWayBtn setTitle:@"现金支付" forState:UIControlStateNormal];
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"网银支付" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.payWayBtn setTitle:@"网银支付" forState:UIControlStateNormal];
        
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: alertController animated: YES completion: nil];
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
