//
//  SubmitOrderSuccessVC.m
//  DPH
//
//  Created by cym on 16/1/31.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "SubmitOrderSuccessVC.h"

@interface SubmitOrderSuccessVC ()

@end

@implementation SubmitOrderSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.orderCodeLab.text = [NSString stringWithFormat:@"订单编号: %@",self.codeStr];
    self.totalPriceLab.text = [NSString stringWithFormat:@"应付总额: ¥ %@",self.totalPriceStr];
}

- (IBAction)finishAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
