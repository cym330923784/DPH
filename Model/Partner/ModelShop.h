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
@property (nonatomic,copy) NSString *endClientId;
/**
 *  图片
 */
@property (nonatomic,copy) NSString *image;
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
 *  配送区域id
 */
@property (nonatomic,copy) NSString *areaId;
/**
 *  配送区域名称
 */
@property (nonatomic,copy) NSString *businessAreas;
/**
 *  备用电话
 */
@property (nonatomic,copy) NSString *secondaryPhone;
///**
// *  qq
// */
//@property (nonatomic,copy) NSString *contactQQ;
///**
// *  状态
// */
@property (nonatomic,copy) NSString *loginStatus;
/**
 *  vip
 */
//@property (nonatomic,copy) NSString *levelid;










@end
