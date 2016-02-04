//
//  ModelTempProduct.h
//  DPH
//
//  Created by cym on 16/1/31.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelTempProduct : NSObject

/**
 *  商品id
 */
@property (nonatomic,copy) NSString *productId;
/**
 *  价格
 */
@property (nonatomic,copy) NSString *price;
/**
 *  数量
 */
@property (nonatomic,copy) NSString *qty;
/**
 *  规格
 */
@property (nonatomic,copy) NSString *specifications;

@end
