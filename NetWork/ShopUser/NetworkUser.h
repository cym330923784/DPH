//
//  NetworkUser.h
//  DPH
//
//  Created by cym on 16/1/31.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseNetwork.h"

@interface NetworkUser : BaseNetwork

+(NetworkUser *)sharedManager;

/**
 *  獲取商品列表
 *
 *  @param userId   用户id
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */
-(void)getUserInfoByUserId:(NSString *)userId
                   success:(networkSuccess)success
                   failure:(networkFailure)failure;


/**
 *  獲取公司信息
 *
 *  @param partnerId   合伙人id
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)getCompanyInfoByPartnerId:(NSString *)partnerId
                         success:(networkSuccess)success
                         failure:(networkFailure)failure;
@end
