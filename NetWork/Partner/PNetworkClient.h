//
//  PNetworkClient.h
//  DPH
//
//  Created by cym on 16/2/3.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseNetwork.h"
#import "ModelShop.h"

@interface PNetworkClient : BaseNetwork

+(PNetworkClient *)sharedManager;

/**
 *  獲取商户列表
 *
 *  @param partnerId   合伙人id
 *  @param pageNo   页码
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)getClientListByPartnerId:(NSString *)partnerId
                         pageNo:(NSString *)pageNo
                        success:(networkSuccess)success
                        failure:(networkFailure)failure;


/**
 *  獲取商户详情
 *
 *  @param endClientId   商户id
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)getClientDetailByEndClientId:(NSString *)endClientId
                            success:(networkSuccess)success
                            failure:(networkFailure)failure;


/**
 *  添加商户
 *
 *  @param modelShop   商户对象
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)addClientByPartnerId:(NSString *)partnerId
                     Object:(ModelShop *)modelShop
                    success:(networkSuccess)success
                    failure:(networkFailure)failure;
/**
 *  修改商户
 *
 *  @param modelShop   商户对象
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)editClientByUserId:(NSString *)userId
                     Object:(ModelShop *)modelShop
                    success:(networkSuccess)success
                    failure:(networkFailure)failure;

/**
 *  获取配送区域
 *
 *  @param partnerId   地方站id
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)getDeliveryAreaByPartnerId:(NSString *)partnerId
                          success:(networkSuccess)success
                          failure:(networkFailure)failure;

@end
