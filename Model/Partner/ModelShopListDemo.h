//
//  ModelShopListDemo.h
//  DPH
//
//  Created by cym on 16/2/3.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelShopListDemo : NSObject

/**
 *  图片
 */
@property (nonatomic,copy) NSString *image;
/**
 *  联系人名称
 */
@property (nonatomic,copy) NSString *contactName;
/**
 *  商户ID
 */
@property (nonatomic,copy) NSString *shopId;
/**
 *  地址
 */
@property (nonatomic,copy) NSString *addressDetails;
/**
 *  
 */
@property (nonatomic,copy) NSString *levelId;
/**
 *  职位
 */
@property (nonatomic,copy) NSString *contactPosition;
/**
 *  
 */
@property (nonatomic,copy) NSString *loginAccNumber;
/**
 *  联系电话
 */
@property (nonatomic,copy) NSString *contactMobile;
/**
 *  创建时间
 */
@property (nonatomic,copy) NSString *cTime;
/**
 *  商户名称
 */
@property (nonatomic,copy) NSString *name;


@end
