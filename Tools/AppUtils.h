//
//  AppUtils.h
//  DPH
//
//  Created by cym on 16/1/25.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

@interface AppUtils : NSObject

/**
 *  DES加密
 *
 *  @param msg 明文
 */
+(NSString *) encryptUseDES:(NSString *)clearText;
/**
 *  去除区，市，县
 *
 *  @return 位置名称
 */
+(NSString *)getVersion;
/**
 *  彈出AlertView
 *
 *  @param msg 提示信息
 */
//+(void)showAlertMessage:(NSString *)msg;
/**
 *  關閉鍵盤
 */
+(void)closeKeyBoard;
/**
 *  MD5加密
 *
 *  @param str 需要加密的字符串
 */
+(NSString *)md5FromString:(NSString *)str;
/**
 *  圖片轉二進制字符串
 *
 *  @param img 圖片
 *
 *  @return 二進制字符串
 */
+(NSString *)getIMageData:(UIImage *)img;
/**
 *  狀態欄提示信息
 *
 *  @param string 信息
 */
//+(void)showBarString:(NSString *)status;
/**
 *  根据字符串长度
 *
 *  @param text     字符串
 *  @param fontSize 字体大小
 *  @param maxSize  最大size
 *
 *  @return 计算之后的大小
 */
+ (CGSize)labelAutoCalculateRectWith:(NSString*)text lineSpacing:(CGFloat)lineSpacing FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize;


/**
 *  字典转json
 *
 *  @return
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

/**
 *  字符串转json
 *
 *  @return
 */
+ (NSDictionary*)StringToJson:(NSString *)str;
/**
 *  对象转字典
 *
 *  @return
 */
+ (NSDictionary*)getObjectData:(id)obj;

/**
 *  返回屏幕寬度
 *
 *  @return 屏幕寬度
 */
+ (CGFloat)putScreenWidth;
/**
 *  返回屏幕高度
 *
 *  @return 屏幕高度
 */
+ (CGFloat)putScreenHeight;
/**
 *  去除区，市，县
 *
 *  @return 位置名称
 */
+ (NSString *)dealCityName:(NSString *)cityName;

/**
 *  分割字符串为数组
 *
 *  @param msg 字符串
 */

+(NSArray *)cutStringToArray:(NSString *)string symbol:(NSString *)symbol;

/**
 *  将数组转化为字符串
 *
 *  @param msg 字符串
 */
+(NSString *)putArrToString:(NSMutableArray *)arr;
//+(void)customNavbar:(UIView *)view;

/**
 *  快捷对话框
 *
 */
+(void)showAlert:(NSString *)title message:(NSString *)message;



@end

