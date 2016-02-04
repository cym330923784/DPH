//
//  ModelPartner.m
//  DPH
//
//  Created by cym on 16/2/1.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "ModelPartner.h"
#import <YTKKeyValueStore.h>
#import "InitSQL.h"

@implementation ModelPartner

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"partnerId":@"id"};
}

-(void)partnerSave
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initWithDBWithPath:[InitSQL getDBPath]];
    NSString *tableName = @"partner";
    [store createTableWithName:tableName];
    if (!self.image) {
        self.image = @"";
    }
    if (!self.contactEmail) {
        self.contactEmail = @"";
    }
    if (!self.contactPosition) {
        self.contactPosition = @"";
    }
    if (!self.name) {
        self.name = @"";
    }
    
    NSString *key = @"1";
    
    NSDictionary *user = @{@"contactMobile": self.contactMobile,
                           @"name": self.name,
                           @"image":self.image,
                           @"contactEmail":self.contactEmail,
                           @"contactPosition":self.contactPosition,
                           @"partnerId":self.partnerId};
    [store putObject:user withId:key intoTable:tableName];
    
}

-(void)partnerRead
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initWithDBWithPath:[InitSQL getDBPath]];
    NSString *tableName = @"partner";
    [store createTableWithName:tableName];
    
    NSString *key = @"1";
    
    NSDictionary *dic = [store getObjectById:key fromTable:tableName];
    
    self.partnerId = [dic objectForKey:@"partnerId"];
    self.name = [dic objectForKey:@"name"];
    self.image = [dic objectForKey:@"image"];
    self.contactMobile = [dic objectForKey:@"contactMobile"];
    self.contactEmail = [dic objectForKey:@"contactEmail"];
    self.contactPosition = [dic objectForKey:@"contactPosition"];
    
}

-(void)partnerRemove
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initWithDBWithPath:[InitSQL getDBPath]];
    
    NSString *tableName = @"partner";
    
    [store createTableWithName:tableName];
    
    NSString *key = @"1";
    
    [store deleteObjectById:key fromTable:tableName];
    
}


@end
