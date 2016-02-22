//
//  ShopCartSQL.h
//  DPH
//
//  Created by cym on 16/1/31.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCartSQL : NSObject

+(void)saveToShopCart:(NSDictionary *)ProductDic withId:(NSString *)productId;

+(id)getObjectById:(NSString *)objectId;

+(NSMutableArray *)readShopCart;

+(void)removeProductById:(NSString *)productId;

/**
 *  刪除所有頭像和暱稱
 */
+(void)removeAllProInShopCart;

@end
