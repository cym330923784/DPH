//
//  UserDefaultUtils.h
//  YeTao--UserDefaults封裝
//
//  Created by cym on 15/11/27.
//  Copyright © 2015年 YeTao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultUtils : NSObject

/**
 *  保存Value
 *
 *  @param value value
 *  @param key   key
 */
+(void)saveValue:(id)value forKey:(NSString *)key;
/**
 *  提取value
 *
 *  @param key key
 *
 *  @return value
 */
+(id)valueWithKey:(NSString *)key;
/**
 *  提取Bool
 *
 *  @param key key
 *
 *  @return bool
 */
+(BOOL)boolValueWithKey:(NSString *)key;
/**
 *  保存Bool
 *
 *  @param value bool
 *  @param key   key
 */
+(void)saveBoolValue:(BOOL)value withKey:(NSString *)key;
/**
 *  刪除value
 *
 *  @param key key
 */
+(void)removeValueWithKey:(NSString *)key;

/**
 *  查看UserDefaults
 */
+(void)print;


@end
