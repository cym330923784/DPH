//
//  ModelCategory.h
//  DPH
//
//  Created by Cym on 16/2/29.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelCategory : NSObject
/**
 *  类别id
 */
@property (nonatomic,copy) NSString *ctyId;
/**
 *  类别名称
 */
@property (nonatomic,copy) NSString *name;
/**
 *  子类别
 */
@property (nonatomic,copy) NSMutableArray *data;

@end
