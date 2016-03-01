//
//  ModelProduct.h
//  DPH
//
//  Created by cym on 16/1/30.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelProduct : NSObject<NSCoding>
/**
 *  商品id
 */
@property (nonatomic,copy) NSString *productId;
/**
 *  商品名称
 */
@property (nonatomic,copy) NSString *name;
/**
 *  商品编码
 */
@property (nonatomic,copy) NSString *code;
/**
 *  市场价
 */
@property (nonatomic,copy) NSString *partnerMarketPrice;
/**
 *  平台价
 */
@property (nonatomic,copy) NSString *sellingPrice;
/**
 *  描述
 */
@property (nonatomic,copy) NSString *proDescription;
/**
 *  图片
 */
@property (nonatomic,copy) NSString *primeImageUrl;
/**
 *  规格
 */
@property (nonatomic,copy) NSMutableArray *data;
/**
 *  是否收藏
 */
@property (nonatomic,copy) NSString *favorite;
/**
 *  数量(购物车, 商品清单中使用)
 */
@property (nonatomic,copy) NSString *qty;
/**
 *  规格(购物车中使用，只有一个)
 */
@property (nonatomic,copy) NSString *specifications;
/**
 *  价格(商品清单中使用，只有一个)
 */
@property (nonatomic,copy) NSString *price;
/**
 *  上下架状态(合伙人)
 */
@property (nonatomic,copy) NSString *shelfStatus;
/**
 *  库存(合伙人)
 */
@property (nonatomic,copy) NSString *storageQty;
/**
 *  合伙人id(合伙人)
 */
//@property (nonatomic,copy) NSString *partnerId;





@end
