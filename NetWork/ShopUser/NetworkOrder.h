//
//  NetworkOrder.h
//  DPH
//
//  Created by cym on 16/1/31.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseNetwork.h"

@interface NetworkOrder : BaseNetwork

+(NetworkOrder *)sharedManager;

/**
 *  獲取订单列表
 *
 *  @param userId   用户id
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)getOrderListByUserId:(NSString *)userId
                      state:(NSString *)state
                     pageNo:(NSString *)pageNo
                    success:(networkSuccess)success
                    failure:(networkFailure)failure;

/**
 *  獲取订单详情
 *
 *  @param orderId   订单id
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)getOrderDetailByOrderId:(NSString *)orderId
                       success:(networkSuccess)success
                       failure:(networkFailure)failure;

/**
 *  獲取订单商品清单
 *
 *  @param orderId   订单id
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */
-(void)getORderProductListByOrderId:(NSString *)orderId
                            success:(networkSuccess)success
                            failure:(networkFailure)failure;

/**
 *  确认收货
 *
 *  @param orderId   订单id
 *  @param endClientId   用户id
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)confirmReceiveByOrderId:(NSString *)orderId
                   endClientId:(NSString *)endClientId
                       success:(networkSuccess)success
                       failure:(networkFailure)failure;
@end
