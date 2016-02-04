//
//  ModelSpecification.h
//  DPH
//
//  Created by cym on 16/1/30.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelSpecification : NSObject
/**
 *  规格id
 */
@property (nonatomic,copy) NSString *fId;
/**
 *  规格名称
 */
@property (nonatomic,copy) NSString *name;
/**
 *  规格值
 */
@property (nonatomic,copy) NSMutableArray *data;

@end
