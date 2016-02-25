//
//  ModelCompany.h
//  DPH
//
//  Created by Cym on 16/2/24.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelCompany : NSObject

/**
 * 公司名字
 */
@property (nonatomic,strong)NSString * name;
/**
 * 详细地址
 */
@property (nonatomic,strong)NSString * addressDetails;
/**
 * 管理区域
 */
@property (nonatomic,strong)NSString * manageArea;
/**
 * 联系人姓名
 */
@property (nonatomic,strong)NSString * contactName;
/**
 * 联系人手机
 */
@property (nonatomic,strong)NSString * contactMobile;

@end
