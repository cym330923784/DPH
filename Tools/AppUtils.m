//
//  AppUtils.m
//  DPH
//
//  Created by cym on 16/1/25.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "AppUtils.h"

#import <CommonCrypto/CommonDigest.h>
//#import <JDStatusBarNotification.h>

#import<objc/runtime.h>

#import <GTM_Base64.h>
#include <CommonCrypto/CommonCryptor.h>

#define gkey            @"cxzliuy$&uddnqiang@lx100$#365#$"
#define gIv             @"02134765"



@implementation AppUtils

+(NSString *) encryptUseDES:(NSString *)clearText
{
    NSData* data = [clearText dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [gkey UTF8String];
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result = [GTM_Base64 stringByEncodingData:myData];
    return result;
}

+(NSString *)getVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

//+(void)showAlertMessage:(NSString *)msg
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
//}

+(void)closeKeyBoard
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

+(NSString *)md5FromString:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+(NSString *)getIMageData:(UIImage *)img
{
    if (!img) {
        return 0;
    }
    NSData *data = UIImageJPEGRepresentation(img, 1.0);
    NSString *str1 = [data.description substringWithRange:NSMakeRange(1, data.description.length-2)];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return str2;
}

//+(void)showBarString:(NSString *)status{
//    NSString *style = UIStatusBarStyleDefault;
//    
//    [JDStatusBarNotification showWithStatus:status
//                               dismissAfter:2.0
//                                  styleName:style];
//}

+ (CGSize)labelAutoCalculateRectWith:(NSString*)text lineSpacing:(CGFloat)lineSpacing FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize

{
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    [paragraphStyle setLineSpacing:lineSpacing];
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    //    NSString *subString = @"\n";
    //    NSArray *array = [text componentsSeparatedByString:subString];
    //    NSInteger count = [array count] - 1;
    CGSize labelSize = [text boundingRectWithSize:maxSize
                                          options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine
                                       attributes:attributes
                                          context:nil].size;
    
    labelSize.height=ceil(labelSize.height);
    
    labelSize.width=ceil(labelSize.width);
    
    return labelSize;
}

+ (NSString *)dealCityName:(NSString *)cityName
{
    NSString * cityNameStr = [[NSString alloc]init];
    NSString * cityNameStr1 = [cityName stringByReplacingOccurrencesOfString:@"区" withString:@""];
    NSString * cityNameStr2 = [cityNameStr1 stringByReplacingOccurrencesOfString:@"市" withString:@""];
    cityNameStr = [cityNameStr2 stringByReplacingOccurrencesOfString:@"县" withString:@""];
    
    return cityNameStr;
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSDictionary*)StringToJson:(NSString *)str
{
    NSData * data = [[NSData alloc]initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary * resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return resultDic;
}

+ (NSDictionary*)getObjectData:(id)obj
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    unsigned int propsCount;
    
    objc_property_t * props = class_copyPropertyList([obj class], &propsCount);
    
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        
        id value = [obj valueForKey:propName];
        
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [self getObjectInternal:value];
        }
        
        [dic setObject:value forKey:propName];
    }
    
    return dic;
}

+
(id)getObjectInternal:(id)obj

{
    
    if([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }

    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        
        return dic;
        
    } 
    return [self getObjectData:obj];
}


+ (CGFloat)putScreenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)putScreenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

+(NSArray *)cutStringToArray:(NSString *)string symbol:(NSString *)symbol
{
    NSArray *array = [string componentsSeparatedByString:symbol];
    return array;
}

+(NSString *)putArrToString:(NSMutableArray *)arr
{
    NSString *scoreStr = nil;
    for (NSString *str in arr) {
        
        if (!scoreStr) {
            scoreStr = str;
        }
        else{
            scoreStr = [NSString stringWithFormat:@"%@,%@",scoreStr,str];
        }
    }
    return scoreStr;
}

+(void)showAlert:(NSString *)title
         message:(NSString *)message
      objectSelf:(UIViewController*)objectSelf
   defaultAction:(defaultAction)defaultAction
    cancelAction:(cancelAction)cancelAction
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        defaultAction(action);
        
    }]];
    if (cancelAction != nil) {
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            cancelAction(action);
            
        }]];

    }
    [objectSelf presentViewController:alert animated:YES completion:nil];
    
    
}


+(BOOL)userAuthJudgeBy:(NSString*)taskSign
{
    NSMutableArray * authArr = [UserDefaultUtils valueWithKey:@"authList"];
    NSString * str = taskSign;
    return [authArr containsObject:str];
}


@end

