//
//  NetworkLogin.h
//  DPH
//
//  Created by cym on 16/1/30.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseNetwork.h"

@interface NetworkLogin : BaseNetwork

+(NetworkLogin *)sharedManager;


/**
 *  獲取驗證碼
 *
 *  @param phone   電話號碼
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */
-(void)sgetVerify:(NSString *)phone
          success:(networkSuccess)success
          failure:(networkFailure)failure;

/**
 *  登錄
 *
 *  @param phone    電話號碼
 *  @param code 验证码
 *  @param success  成功囘調
 *  @param failure  失敗囘調
 */
-(void)sloginPhone:(NSString *)phone
              code:(NSString *)code
           success:(networkSuccess)success
           failure:(networkFailure)failure;


@end
