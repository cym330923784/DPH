//
//  ModelPayWay.h
//  DPH
//
//  Created by cym on 16/2/3.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelPayWay : NSObject
/**
 * 付款方式
 */
@property (nonatomic,copy) NSString *method;
/**
 *  订单ID
 */
@property (nonatomic,copy) NSString *orderId;
/**
 *  付款人姓名
 */
@property (nonatomic,copy) NSString *fromacctName;
/**
 *  时间
 */
@property (nonatomic,copy) NSString *paymentTimestam;

@end
