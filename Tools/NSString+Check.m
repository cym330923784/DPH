//
//  NSString+Check.m
//  CG
//
//  Created by Rabbit on 2015/4/10.
//  Copyright (c) 2015年 shixiao. All rights reserved.
//

#import "NSString+Check.h"

@implementation NSString (Check)

// 判断邮件格式正则表达式
static NSString *EMAIL_REGEX_NAME = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";

// 判断数字正则表达式
static NSString *NUMBER_REGEX_NAME = @"^[0-9]*$";

// 判断英文正则表达式
static NSString *ENGLISH_REGEX_NAME = @"^[A-Za-z]+$";

// 判断中文正则表达式
static NSString *CHINESE_REGEX_NAME = @"^[\u4E00-\u9FA5]*$";

// 判断网址正则表达式
//static NSString *INTERNET_URL_REGEX_NAME = @"((http|ftp|https)://)(([a-zA-Z0-9\._-]+\.[a-zA-Z]{2,6})|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\&%_\./-~-]*)?";

//判斷密碼
//static NSString *PASSWORD_REGEX_NAME = @"^[^\u4e00-\u9fa5\uf900-\ufa2d]{6,20}$";
static NSString *PASSWORD_REGEX_NAME = @"^[\\w+$]{6,20}$";


// 邮件
+ (BOOL)isValidateEmail:(NSString *)str
{
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAIL_REGEX_NAME];
    return [regex evaluateWithObject:str];
}

// 数字
+ (BOOL)isNumber:(NSString *)str
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", NUMBER_REGEX_NAME];
    return [predicate evaluateWithObject:str];
}

// 英文
+ (BOOL)isEnglish:(NSString *)str
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ENGLISH_REGEX_NAME];
    return [predicate evaluateWithObject:str];
}

// 汉字
+ (BOOL)isChinese:(NSString *)str
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CHINESE_REGEX_NAME];
    return [predicate evaluateWithObject:str];
}

// 网址
//+ (BOOL)isInternetUrl:(NSString *)str
//{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", INTERNET_URL_REGEX_NAME];
//    return [predicate evaluateWithObject:str];
//}

// 正则判断手机号码格式
+ (BOOL)isMobileNumber:(NSString *)str
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|7[0]|8[025-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186
     */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189
     */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    //NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSString * OTHER = @"^((13[0-9])|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestOther = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",OTHER];
    
    if (([regextestmobile evaluateWithObject:str] == YES)
        || ([regextestcm evaluateWithObject:str] == YES)
        || ([regextestct evaluateWithObject:str] == YES)
        || ([regextestcu evaluateWithObject:str] == YES)
        || ([regextestOther evaluateWithObject:str] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//密碼
+(BOOL)isPassword:(NSString *)str
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PASSWORD_REGEX_NAME];
    return [predicate evaluateWithObject:str];
}
@end
