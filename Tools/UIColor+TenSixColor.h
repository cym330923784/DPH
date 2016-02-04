//
//  UIColor+TenSixColor.h
//  CG--十六進制顏色
//
//  Created by Rabbit on 2015/4/10.
//  Copyright (c) 2015年 shixiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (TenSixColor)
//16进制转颜色
+ (UIColor *) colorWithHexString: (NSString *)color;

//颜色转16进制字符串
+ (NSString *)getHexStringWithColor:(UIColor *)color;

@end
