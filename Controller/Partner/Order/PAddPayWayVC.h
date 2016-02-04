//
//  PAddPayWayVC.h
//  DPH
//
//  Created by cym on 16/2/1.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseViewCtrl.h"

@interface PAddPayWayVC : BaseViewCtrl

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UIButton *dateBtn;

@property (weak, nonatomic) IBOutlet UIButton *payWayBtn;

@property (nonatomic, strong)NSString * orderId;

@end
