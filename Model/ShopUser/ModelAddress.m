//
//  ModelAddress.m
//  DPH
//
//  Created by cym on 16/1/28.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "ModelAddress.h"

@implementation ModelAddress

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"addressId":@"id"};
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self == [super init]) {
        self.addressId = [aDecoder decodeObjectForKey:@"addressId"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.addressdetails = [aDecoder decodeObjectForKey:@"addressdetails"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.addressId forKey:@"addressId"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.addressdetails forKey:@"addressdetails"];
    
}

@end
