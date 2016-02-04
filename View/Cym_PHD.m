//
//  Cym_PHD.m
//  DPH
//
//  Created by cym on 16/1/26.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "Cym_PHD.h"

@implementation Cym_PHD

static Cym_PHD * _fqsphd = nil;
+(instancetype)sharePHD
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _fqsphd = [[super allocWithZone:NULL] init] ;
    }) ;
    
    return _fqsphd;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    return [Cym_PHD sharePHD] ;
}
-(id)copyWithZone:(struct _NSZone *)zone
{
    return [Cym_PHD sharePHD] ;
}

- (id)init

{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    
    if ([delegate respondsToSelector:@selector(window)])
    {
        self.window = [delegate performSelector:@selector(window)];
    }
    else
    {
        self.window = [[UIApplication sharedApplication] keyWindow];
    }
    
    //    CGRect frame = self.window.frame;
    //    self.background = [[UIView alloc] initWithFrame:frame];
    //    self.background.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    //    [self addSubview:self.background];
    [self.window addSubview:self];
    
    //    self.animationView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    //    self.animationView.backgroundColor = [UIColor blackColor];
    //    self.animationView.center = self.background.center;
    //    [self.background addSubview:self.animationView];
    
    return self;
}

+ (void)show:(NSString *)status
{
    [[self sharePHD] showPHD:status];
}

+ (void)showSuccess:(NSString *)status
{
    [[self sharePHD] showSeccess:status];
}

+ (void)showError:(NSString *)status
{
    [[self sharePHD] showError:status];
}

+ (void)dismissBGView:(UIView *)bgView
{
    [[self sharePHD] hiddenBGView:bgView];
    
}

- (void)showPHD:(NSString *)status
{
    
    if (!self.background) {
        CGRect frame = self.window.frame;
        self.background = [[UIView alloc] initWithFrame:frame];
        self.background.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
        [self addSubview:self.background];
    }
    
    if (!self.animationView) {
        self.animationView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width*0.7, self.frame.size.width/2)];
        self.animationView.center = self.background.center;
        self.animationView.backgroundColor = [UIColor whiteColor];
        [self.background addSubview:self.animationView];
        
        self.showLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.animationView.bounds.size.height-40, self.animationView.bounds.size.width, 25)];
        self.showLabel.textAlignment = 1;
//        self.showLabel.font = [UIFont systemFontOfSize:17];
        //        self.showLabel.center = self.animationView.center;
        self.showLabel.textColor = [UIColor blackColor];
        self.showLabel.text = status;
        self.showLabel.adjustsFontSizeToFitWidth = YES;
        [self.animationView addSubview:self.showLabel];
        
        self.imgV = [[UIImageView alloc]initWithFrame:CGRectMake(self.animationView.bounds.size.width/2-50, 20, 100, 100)];
        self.imgV.backgroundColor = [UIColor blueColor];
        [self.animationView addSubview:self.imgV];
    }
    
    self.animationView.image = [UIImage imageNamed:@"PHD_circle"];
    [self shake:self.animationView];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)shake:(UIView *)view
{
    CABasicAnimation * shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shake.fromValue = [NSNumber numberWithFloat:-M_PI];
    shake.toValue = [NSNumber numberWithFloat:+M_PI];
    shake.duration=2;
    shake.repeatCount = FLT_MAX;
    [view.layer addAnimation:shake forKey:@"shake"];
}

- (void)showSeccess:(NSString *)status
{
    if (!self.background) {
        CGRect frame = self.window.frame;
        self.background = [[UIView alloc] initWithFrame:frame];
        self.background.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
        [self addSubview:self.background];
    }
    
    if (!self.animationView) {
        self.animationView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width*0.7, self.frame.size.width/2)];
        self.animationView.center = self.background.center;
        self.animationView.backgroundColor = [UIColor whiteColor];
        [self.background addSubview:self.animationView];
        
        self.showLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.animationView.bounds.size.height-40, self.animationView.bounds.size.width, 25)];
        self.showLabel.textAlignment = 1;
//        self.showLabel.font = [UIFont systemFontOfSize:17];
//        self.showLabel.center = self.animationView.center;
        self.showLabel.textColor = [UIColor blackColor];
        self.showLabel.text = status;
        self.showLabel.adjustsFontSizeToFitWidth = YES;
        [self.animationView addSubview:self.showLabel];
        
        self.imgV = [[UIImageView alloc]initWithFrame:CGRectMake(self.animationView.bounds.size.width/2-50, 20, 100, 100)];
//        self.imgV.backgroundColor = [UIColor blueColor];
        self.imgV.image = [UIImage imageNamed:@"addShopCart_pic_success"];
        [self.animationView addSubview:self.imgV];
    }
    
//    self.animationView.image = [UIImage imageNamed:@"PHD_circle"];
//    [self shake:self.animationView];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [self timedHide];
    }];
    
}

//- (void)showError:(NSString *)status
//{
//    if (!self.background) {
//        CGRect frame = self.window.frame;
//        self.background = [[UIView alloc] initWithFrame:frame];
//        self.background.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
//        [self addSubview:self.background];
//    }
//    
//    if (!self.animationView) {
//        self.animationView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/3, self.frame.size.width/3)];
//        self.animationView.center = self.background.center;
//        [self.background addSubview:self.animationView];
//        
//        self.showLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/4-30, self.frame.size.width/4)];
//        self.showLabel.textAlignment = 1;
//        self.showLabel.font = [UIFont systemFontOfSize:17];
//        self.showLabel.center = self.animationView.center;
//        self.showLabel.textColor = [UIColor whiteColor];
//        self.showLabel.text = status;
////        self.showLabel.adjustsFontSizeToFitWidth = YES;
//        [self.background addSubview:self.showLabel];
//    }
//    
//    self.animationView.image = [UIImage imageNamed:@"PHD_circle"];
//    [self shake:self.animationView];
//    
//    if (!self.animationView) {
//        
//    }
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        self.alpha = 1;
//    } completion:^(BOOL finished) {
//        [self timedHide];
//    }];
//    
//}


- (void)timedHide
{
    @autoreleasepool
    {
        NSTimeInterval sleep =  1.5;
        
        [NSThread sleepForTimeInterval:sleep];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hiddenBGView:self.bgView];
        });
    }
}

- (void)hiddenBGView:(UIView *)bgView
{
    if (bgView) {
        self.bgView = bgView;
        
        self.whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, Screen.width, Screen.height-64)];
        self.whiteView.backgroundColor = [UIColor whiteColor];
        [self.bgView addSubview:self.whiteView];
        
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.background removeFromSuperview];	self.background = nil;
        [self.animationView removeFromSuperview];	self.animationView = nil;
        [self.showLabel removeFromSuperview]; self.showLabel = nil;
        //        [self.whiteView removeFromSuperview];self.whiteView = nil;
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    [self  hidden];
}

@end
