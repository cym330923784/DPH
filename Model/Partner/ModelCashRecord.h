//
//  ModelCashRecord.h
//  DPH
//
//  Created by Cym on 16/2/25.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelCashRecord : NSObject

/**
 * 收款记录id
 */
@property (nonatomic ,strong)NSString * recordId;
/**
 * 订单号
 */
@property (nonatomic ,strong)NSString * orderNo;
/**
 * 日期
 */
@property (nonatomic ,strong)NSString * createTime;
/**
 * 付款方式
 */
@property (nonatomic ,strong)NSString * method;
/**
 * 付款人
 */
@property (nonatomic ,strong)NSString * fromAcctName;
/**
 * 付款金额
 */
@property (nonatomic ,strong)NSString * paymentAmount;


@end
