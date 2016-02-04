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



@end
