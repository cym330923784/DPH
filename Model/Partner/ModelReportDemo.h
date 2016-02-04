//
//  ModelReportDemo.h
//  DPH
//
//  Created by cym on 16/2/3.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelReportDemo : NSObject

/**
 * 截止日期
 */
@property (nonatomic,copy) NSString *beginDate;
/**
 * 客户数
 */
@property (nonatomic,copy) NSString *endClientNum;
/**
 * 订单数
 */
@property (nonatomic,copy) NSString *countNum;
/**
 * 总金额
 */
@property (nonatomic,copy) NSString *totalCost;


@end
