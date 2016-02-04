//
//  SubmitOrderSuccessVC.h
//  DPH
//
//  Created by cym on 16/1/31.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseViewCtrl.h"

@interface SubmitOrderSuccessVC : BaseViewCtrl
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLab;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLab;

@property (nonatomic, strong)NSString * codeStr;
@property (nonatomic, strong)NSString * totalPriceStr;

@end
