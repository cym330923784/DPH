//
//  UserDefaultUtils.m
//  YeTao
//
//  Created by cym on 15/11/27.
//  Copyright © 2015年 YeTao. All rights reserved.
//

#import "UserDefaultUtils.h"

@implementation UserDefaultUtils

+(void)saveValue:(id) value forKey:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![value isKindOfClass:[NSNull class]]) {
        [userDefaults setValue:value forKey:key];
    }else{
        [userDefaults removeObjectForKey:key];
    }
    
    [userDefaults synchronize];
}

+(id)valueWithKey:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
//    NSLog(@"%@ == %@",key,[userDefaults valueForKey:key]);
    
    return [userDefaults valueForKey:key];
}

+(BOOL)boolValueWithKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:key];
}

+(void)saveBoolValue:(BOOL)value withKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:key];
    [userDefaults synchronize];
}

+(void)removeValueWithKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:key];
    [userDefaults synchronize];
}

+(void)print{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    NSLog(@"NSUserDefaults == %@",dic);
}



@end
