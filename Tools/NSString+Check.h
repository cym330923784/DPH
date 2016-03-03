//
//  NSString+Check.h
//  CG--正則表達式
//
//  Created by Rabbit on 2015/4/10.
//  Copyright (c) 2015年 shixiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Check)
/**
 *  验证邮箱是不是可用
 *
 *  return YES / NO
 */
+ (BOOL)isValidateEmail:(NSString *)str;

/**
 *  验证是不是数字
 *
 *  return YES / NO
 */
+ (BOOL)isNumber:(NSString *)str;

/**
 *  验证是不是英文
 *
 *  return YES / NO
 */
+ (BOOL)isEnglish:(NSString *)str;

/**
 *  验证是不是汉字
 *
 *  return YES / NO
 */
+ (BOOL)isChinese:(NSString *)str;

/**
 *  验证是不是网络链接地址
 *
 *  return YES / NO
 */
//+ (BOOL)isInternetUrl:(NSString *)str;

/**
 *  是不是手机号码
 *
 *  @param mobileNum 手机号
 *
 *  @return YES / NO
 */
+ (BOOL)isMobileNumber:(NSString *)str;

/**
 *  判斷密碼格式
 *
 *  @param str 密碼
 *
 *  @return YES / NO
 */
+ (BOOL)isPassword:(NSString *)str;

/**
 *  不包含符号
 *
 *  @param str zifuchuan
 *
 *  @return YES / NO
 */
+ (BOOL)isNoSymbol:(NSString *)str;

@end
