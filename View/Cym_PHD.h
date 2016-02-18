//
//  Cym_PHD.h
//  DPH
//
//  Created by cym on 16/1/26.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cym_PHD : UIView

+ (void)dismissBGView:(UIView *)bgView;
+ (void)show:(NSString *)status;
+ (void)showError:(NSString *)status;
+ (void)showSuccess:(NSString *)status;

@property (nonatomic,strong) UIWindow *window;
@property (nonatomic,strong) UIView *background;
@property (nonatomic,strong)UIImageView * animationView;
@property(nonatomic,strong)CABasicAnimation * rotate;
@property(nonatomic,strong)UILabel * showLabel;
@property (nonatomic, strong)UIImageView * imgV;
@property(nonatomic,strong)UIView * bgView;
@property(nonatomic,strong)UIView * whiteView;


@end
