//
//  ToolPhoto.m
//  YeTao
//
//  Created by cym on 15/12/8.
//  Copyright © 2015年 YeTao. All rights reserved.
//

#import "ToolPhoto.h"

@implementation ToolPhoto

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    
    UIGraphicsBeginImageContext(newSize);
    
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    UIGraphicsEndImageContext();
    
    
    return newImage;
    
}


@end
