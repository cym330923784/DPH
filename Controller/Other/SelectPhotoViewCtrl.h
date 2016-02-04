//
//  SelectPhotoViewCtrl.h
//  YeTao
//
//  Created by cym on 15/12/8.
//  Copyright © 2015年 YeTao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^photoBlock)(UIImage *img);

@interface SelectPhotoViewCtrl : UIImagePickerController


-(void)getImage:(photoBlock)action;
@end
