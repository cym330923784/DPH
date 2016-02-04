//
//  MsgDetailVC.h
//  DPH
//
//  Created by cym on 16/1/29.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "ModelMsg.h"

@interface MsgDetailVC : BaseViewCtrl

@property (nonatomic, strong)ModelMsg * modelMsg;
@property (nonatomic, strong)NSString * msgType;

@end
