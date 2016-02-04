//
//  ToolPhoto.h
//  YeTao
//
//  Created by cym on 15/12/8.
//  Copyright © 2015年 YeTao. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface ToolPhoto : NSObject
/**
 *  压缩照片
 *
 *  @param image   传入照片
 *  @param newSize 传入大小
 *
 *  @return 返回新照片
 */
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

@end
