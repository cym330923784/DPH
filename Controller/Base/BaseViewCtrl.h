//
//  BaseViewCtrl.h
//  DPH
//
//  Created by cym on 16/1/25.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewCtrl : UIViewController

/**
 *  顯示一個純文字的HUD
 *
 *  @param status 提示文字
 */
-(void)showCommonHUD:(NSString *)status;
/**
 *  顯示加載提示HUD
 */
-(void)showDownloadsHUD:(NSString *)status;
/**
 *  去除HUD
 */
-(void)dismissHUD;



@end
