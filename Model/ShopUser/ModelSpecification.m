//
//  ModelSpecification.m
//  DPH
//
//  Created by cym on 16/1/30.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "ModelSpecification.h"
#import "ModelSpfctionValue.h"

@implementation ModelSpecification

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [ModelSpfctionValue class]};
}

@end
