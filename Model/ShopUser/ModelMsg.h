//
//  ModelMsg.h
//  DPH
//
//  Created by cym on 16/2/1.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelMsg : NSObject

/**
 *  消息id
 */
@property (nonatomic,copy) NSString *msgId;
/**
 *  消息内容
 */
@property (nonatomic,copy) NSString *content;
/**
 *  消息主题
 */
@property (nonatomic,copy) NSString *title;
/**
 *  消息时间
 */
@property (nonatomic,copy) NSString *date;
/**
 *  消息状态
 */
@property (nonatomic,copy) NSString *readState;

@end
