//
//  ServerUser.h
//  DPH
//
//  Created by cym on 16/1/30.
//  Copyright © 2016年 DPH. All rights reserved.
//

// 核心层的回调处理。
typedef void(^CoreSuccess)(id result);
typedef void(^CoreFailure)(id result);

#import <Foundation/Foundation.h>
#import "ModelUser.h"
#import "NetworkLogin.h"

@interface ServerUser : NSObject

@property (nonatomic,strong) ModelUser *model;

@property (nonatomic,strong) NetworkLogin *network;

+ (instancetype)sharedInstance;


/**
 *  获取验证码
 *
 *  @param mobile   手机号
 *  @param csuccess 成功回调
 *  @param cfailure 失败回调
 */
-(void)userCodePhone:(NSString *)phone
             success:(CoreSuccess)csuccess
             failure:(CoreFailure)cfailure;
/**
 *  商户登录逻辑
 *
 *  @param mobile  電話號碼
 *  @param code 验证码
 *  @param csuccess 成功回调
 *  @param cfailure 失败回调
 */
-(void)userLogin:(NSString *)mobile
        code:(NSString *)code
         success:(CoreSuccess)csuccess
         failure:(CoreFailure)cfailure;




@end
