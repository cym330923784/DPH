//
//  ServerPartner.h
//  DPH
//
//  Created by cym on 16/2/1.
//  Copyright © 2016年 DPH. All rights reserved.
//

// 核心层的回调处理。
typedef void(^CoreSuccess)(id result);
typedef void(^CoreFailure)(id result);

#import <Foundation/Foundation.h>
#import "ModelPartner.h"
#import "PNetworkLogin.h"

@interface ServerPartner : NSObject

@property (nonatomic,strong) ModelPartner *model;

@property (nonatomic,strong) PNetworkLogin *pNetwork;


+ (instancetype)sharedInstance;

/**
 *  合伙人登录逻辑
 *
 *  @param mobile  電話號碼
 *  @param code 验证码
 *  @param csuccess 成功回调
 *  @param cfailure 失败回调
 */
-(void)partnerLogin:(NSString *)mobile
            code:(NSString *)code
         success:(CoreSuccess)csuccess
         failure:(CoreFailure)cfailure;

@end
