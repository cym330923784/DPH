//
//  NetworkHome.h
//  DPH
//
//  Created by cym on 16/1/30.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseNetwork.h"
#import "ModelOrder.h"

@interface NetworkHome : BaseNetwork

+(NetworkHome *)sharedManager;


/**
 *  獲取筛选分类列表
 *
 *  @param productId   商品id
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)getCategoriesByUserId:(NSString *)userId
                     success:(networkSuccess)success
                     failure:(networkFailure)failure;


/**
 *  獲取商品列表
 *
 *  @param userId   電話號碼
 *  @param pageNo   页码
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */
-(void)getProductListByUserId:(NSString *)userId
                    partnerId:(NSString *)partnerId
                       pageNo:(NSString *)pageNo
                      success:(networkSuccess)success
                      failure:(networkFailure)failure;

/**
 *  獲取商品详情
 *
 *  @param productId   商品id
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)getproductInfoByProId:(NSString *)productId
                      partnerId:(NSString *)partnerId
                     success:(networkSuccess)success
                     failure:(networkFailure)failure;


/**
 *  獲取地址列表
 *
 *  @param userId   用户id
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)getAddressListByUserId:(NSString *)userId
                      success:(networkSuccess)success
                      failure:(networkFailure)failure;


/**
 *  新增地址
 *
 *  @param userId   用户id
 *  @param name   姓名
 *  @param phone   电话
 *  @param address   地址
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)addAddressByUserId:(NSString *)userId
                     name:(NSString *)name
                    phone:(NSString *)phone
                  address:(NSString *)address
                  success:(networkSuccess)success
                  failure:(networkFailure)failure;


/**
 *  修改地址(设置默认)
 *
 *  @param userId   用户id
 *  @param addressId   地址id
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)setAddressByUserId:(NSString *)userId
                addressId:(NSString *)addressId
                  success:(networkSuccess)success
                  failure:(networkFailure)failure;


/**
 *  提交订单
 *
 *  @param modelOrder   订单
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)submitOrderByObject:(ModelOrder *)modelOrder
                   success:(networkSuccess)success
                   failure:(networkFailure)failure;


@end
