//
//  ModelStaff.h
//  DPH
//
//  Created by Cym on 16/2/25.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelStaff : NSObject

/**
 * id
 */
@property (nonatomic ,strong)NSString * uId;

/**
 * 姓名
 */
@property (nonatomic ,strong)NSString * name;
/**
 * 头像
 */
@property (nonatomic ,strong)NSString * image;
/**
 * 手机
 */
@property (nonatomic ,strong)NSString * contactMobile;
/**
 * 职务
 */
@property (nonatomic ,strong)NSString * duties;

@end
