//
//  ModelUser.m
//  DPH
//
//  Created by cym on 16/1/30.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "ModelUser.h"
#import <YTKKeyValueStore.h>
#import "InitSQL.h"

@implementation ModelUser

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userId":@"id"};
}

-(void)userSave
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initWithDBWithPath:[InitSQL getDBPath]];
    NSString *tableName = @"user";
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
                           @"userID": self.userId,
                           @"image":self.image,
                           @"contactEmail":self.contactEmail,
                           @"contactPosition":self.contactPosition,
                           @"partnerId":self.partnerId};
    [store putObject:user withId:key intoTable:tableName];
    
}

-(void)userRead
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initWithDBWithPath:[InitSQL getDBPath]];
    NSString *tableName = @"user";
    [store createTableWithName:tableName];
    
    NSString *key = @"1";
    
    NSDictionary *dic = [store getObjectById:key fromTable:tableName];
    
    self.userId = [dic objectForKey:@"userId"];
    self.name = [dic objectForKey:@"name"];
    self.image = [dic objectForKey:@"image"];
    self.contactMobile = [dic objectForKey:@"contactMobile"];
    self.contactEmail = [dic objectForKey:@"contactEmail"];
    self.contactPosition = [dic objectForKey:@"contactPosition"];
    
}

-(void)userRemove
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initWithDBWithPath:[InitSQL getDBPath]];
    
    NSString *tableName = @"user";
    
    [store createTableWithName:tableName];
    
    NSString *key = @"1";
    
    [store deleteObjectById:key fromTable:tableName];
    
}


@end
