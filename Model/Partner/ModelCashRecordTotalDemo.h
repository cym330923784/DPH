//
//  ModelCashRecordTotalDemo.h
//  DPH
//
//  Created by Cym on 16/2/25.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelCashRecordTotalDemo : NSObject
/**
 * 截止日期
 */
@property (nonatomic,copy) NSString *beginDate;

/**
 * 总收款笔数
 */
@property (nonatomic,copy) NSString *countNum;

/**
 * 总收款额
 */
@property (nonatomic,copy) NSString *totalCost;


@end
