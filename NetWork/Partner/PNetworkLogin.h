//
//  PNetworkLogin.h
//  DPH
//
//  Created by cym on 16/2/1.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseNetwork.h"

@interface PNetworkLogin : BaseNetwork

+(PNetworkLogin *)sharedManager;


/**
 *  登錄
 *
 *  @param phone    電話號碼
 *  @param code 验证码
 *  @param success  成功囘調
 *  @param failure  失敗囘調
 */
-(void)partnerLoginPhone:(NSString *)phone
              code:(NSString *)code
           success:(networkSuccess)success
           failure:(networkFailure)failure;


@end
