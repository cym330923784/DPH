//
//  ModelCategory.m
//  DPH
//
//  Created by Cym on 16/2/29.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "ModelCategory.h"

@implementation ModelCategory

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ctyId":@"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[ModelCategory class]};
}

@end
