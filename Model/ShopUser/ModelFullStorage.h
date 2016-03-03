//
//  ModelFullStorage.h
//  DPH
//
//  Created by Cym on 16/3/3.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelFullStorage : NSObject

/**
 *  商品id
 */
@property (nonatomic,copy) NSString *productId;
/**
 *  库存
 */
@property (nonatomic,copy) NSString *storage;

@end
