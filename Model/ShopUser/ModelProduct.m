//
//  ModelProduct.m
//  DPH
//
//  Created by cym on 16/1/30.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "ModelProduct.h"
#import "ModelSpecification.h"

@implementation ModelProduct

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"productId":@"id",
             @"proDescription":@"description"};
}

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [ModelSpecification class]};
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.code forKey:@"code"];
    [aCoder encodeObject:self.primeImageUrl forKey:@"primeImageUrl"];
    [aCoder encodeObject:self.productId forKey:@"productId"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.sellingPrice forKey:@"sellingPrice"];
    [aCoder encodeObject:self.qty forKey:@"qty"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.code = [aDecoder decodeObjectForKey:@"code"];
        self.primeImageUrl = [aDecoder decodeObjectForKey:@"primeImageUrl"];
        self.productId = [aDecoder decodeObjectForKey:@"productId"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.sellingPrice = [aDecoder decodeObjectForKey:@"sellingPrice"];
        self.qty = [aDecoder decodeObjectForKey:@"qty"];
    }
    return self;
}

@end
