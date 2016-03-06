//
//  ModelOrder.h
//  DPH
//
//  Created by cym on 16/1/31.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelProduct.h"

@interface ModelOrder : NSObject
///**
// *   地方站id
// */
//@property (nonatomic,copy) NSString * partnerId;
/**
 *   订单id
 */
@property (nonatomic,copy) NSString * orderId;
/**
 *  订单编号
 */
@property (nonatomic,copy) NSString * orderNo;
/**
 *  订单中商品数量
 */
@property (nonatomic,copy) NSString * num;
/**
 *  订单状态
 */
@property (nonatomic,copy) NSString * orderStatus;
/**
 *  下单时间
 */
@property (nonatomic,copy) NSString * createTime;
/**
 *  用户id
 */
@property (nonatomic,copy) NSString * endClientId;
/**
 *  交货人
 */
@property (nonatomic,copy) NSString *deliveryName;
/**
 *  交货电话
 */
@property (nonatomic,copy) NSString *deliveryPhone;
/**
 *  交货地址
 */
@property (nonatomic,copy) NSString *deliveryAddress;
/**
 *  订单总价
 */
@property (nonatomic,copy) NSString *totalCost;
/**
 *  备注
 */
@property (nonatomic,copy) NSString *note;
/**
 *  付款状态
 */
@property (nonatomic,copy) NSString *paymentStatus;
/**
 *  付款方式
 */
@property (nonatomic,copy) NSString *method;
/**
 *  商品数组
 */
@property (nonatomic,copy) NSMutableArray *inventoryData;

/**
 *  是否收取了现金
 */
@property (nonatomic,copy) NSString *cashReceipts;
/**
 *  区域名称
 */
@property (nonatomic,copy) NSString *areaName;

@end
