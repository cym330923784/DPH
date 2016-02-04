//
//  PNetworkOrder.h
//  DPH
//
//  Created by cym on 16/2/2.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseNetwork.h"
#import "ModelPayWay.h"

@interface PNetworkOrder : BaseNetwork

+(PNetworkOrder *)sharedManager;

/**
 *  獲取订单列表
 *
 *  @param partnerId   合伙人id
 *  @param orderStatus   状态
 *  @param pageNo   页码
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)getOrderListByPartnerId:(NSString *)partnerId
                      orderStatus:(NSString *)orderStatus
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
-(void)getOrderProductListByOrderId:(NSString *)orderId
                            success:(networkSuccess)success
                            failure:(networkFailure)failure;


/**
 *  添加付款记录
 *
 *  @param orderId   订单id
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)addPaymentByObject:(ModelPayWay *)modelPayWay
                  success:(networkSuccess)success
                  failure:(networkFailure)failure;

/**
 *  修改订单状态
 *
 *  @param orderId   订单id
 *  @param partnerId   合伙人id
 *  @param orderStatus   订单状态
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)updateOrderStatusByOrderId:(NSString *)orderId
                        partnerId:(NSString *)partnerId
                      orderStatus:(NSString *)orderStatus
                          success:(networkSuccess)success
                          failure:(networkFailure)failure;

@end
