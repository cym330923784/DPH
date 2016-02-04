//
//  ModelShop.h
//  DPH
//
//  Created by cym on 16/2/1.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelShop : NSObject

/**
 *  合伙人ID
 */
@property (nonatomic,copy) NSString *partnerId;
/**
 *  图片
 */
@property (nonatomic,copy) NSString *images;
/**
 *  商户名称
 */
@property (nonatomic,copy) NSString *name;
/**
 *  地址
 */
@property (nonatomic,copy) NSString *addressDetail;
/**
 *  联系人名称
 */
@property (nonatomic,copy) NSString *contactName;
/**
 *  联系电话
 */
@property (nonatomic,copy) NSString *contactMobile;
/**
 *  职位
 */
@property (nonatomic,copy) NSString *contactPosition;
/**
 *  邮箱
 */
@property (nonatomic,copy) NSString *contactEmail;
/**
 *  qq
 */
@property (nonatomic,copy) NSString *contactQQ;
/**
 *  状态
 */
@property (nonatomic,copy) NSString *loginStatus;
/**
 *  vip
 */
//@property (nonatomic,copy) NSString *levelid;










@end
