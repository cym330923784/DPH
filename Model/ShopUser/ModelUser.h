//
//  ModelUser.h
//  DPH
//
//  Created by cym on 16/1/30.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelUser : NSObject

/**
 *  用戶ID
 */
@property (nonatomic,copy) NSString *userId;
/**
 *  合伙人ID
 */
@property (nonatomic,copy) NSString *partnerId;
/**
 *  用戶姓名
 */
@property (nonatomic,copy) NSString *name;
/**
 *  用戶头像
 */
@property (nonatomic,copy) NSString *image;
/**
 *  用戶手机
 */
@property (nonatomic,copy) NSString *contactMobile;
/**
 *  用戶邮箱
 */
@property (nonatomic,copy) NSString *contactEmail;
/**
 *  用戶职位
 */
@property (nonatomic,copy) NSString *contactPosition;


/**
 *  保存
 */
-(void)userSave;
/**
 *  讀取
 */
-(void)userRead;
/**
 *  刪除
 */
-(void)userRemove;

@end
