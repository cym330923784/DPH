//
//  TextViewAlertView.m
//  DPH
//
//  Created by cym on 16/1/30.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "TextViewAlertView.h"
#import <QuartzCore/QuartzCore.h>


#define kAlertWidth 300.0f
#define kAlertHeight 230.0f


@interface TextViewAlertView ()<UITextViewDelegate>
{
    BOOL _leftLeave;
}

@property (nonatomic, strong) UILabel *alertTitleLabel;
//@property (nonatomic, strong) UILabel *alertContentLabel;
@property (nonatomic ,strong) UITextView * alertTextView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *backImageView;

@end


@implementation TextViewAlertView


+ (CGFloat)alertWidth
{
    return kAlertWidth;
}

+ (CGFloat)alertHeight
{
    
    
    return kAlertHeight;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define kTitleYOffset 15.0f
#define kTitleHeight 25.0f

#define kContentOffset 30.0f
#define kBetweenLabelOffset 20.0f

- (id)initWithContentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
{
    if (self = [super init]) {
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor colorWithHexString:@"F0F0F0"];
        
        self.alertTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 40, kAlertWidth-20, kAlertHeight-80)];
        self.alertTextView.backgroundColor = [UIColor whiteColor];
        self.alertTextView.delegate = self;
        [self addSubview:self.alertTextView];
        
        self.alertTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kAlertWidth-20, 30)];
        self.alertTitleLabel.text = @"订单备注";
        self.alertTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.alertTitleLabel.textColor = [UIColor grayColor];
        [self addSubview:self.alertTitleLabel];
        
        CGRect leftBtnFrame;
        CGRect rightBtnFrame;
#define kSingleButtonWidth 160.0f
#define kCoupleButtonWidth 100.0f
#define kButtonHeight 35.0f
#define kButtonBottomOffset 10.0f
        if (!leftTitle) {
            rightBtnFrame = CGRectMake((kAlertWidth - kSingleButtonWidth) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kSingleButtonWidth, kButtonHeight);
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn.frame = rightBtnFrame;
            
        }else {
            leftBtnFrame = CGRectMake(0, kAlertHeight - kButtonHeight, kAlertWidth/2, kButtonHeight);
            rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame), kAlertHeight - kButtonHeight, kAlertWidth/2, kButtonHeight);
            self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftBtn.frame = leftBtnFrame;
            self.rightBtn.frame = rightBtnFrame;
        }
        
//        [self.rightBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:87.0/255.0 green:135.0/255.0 blue:173.0/255.0 alpha:1]] forState:UIControlStateNormal];
//        [self.leftBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:227.0/255.0 green:100.0/255.0 blue:83.0/255.0 alpha:1]] forState:UIControlStateNormal];
        [self.rightBtn setBackgroundColor:[UIColor whiteColor]];
        [self.leftBtn setBackgroundColor:[UIColor whiteColor]];
        
        [self.rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
        [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        
        self.leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.leftBtn setTitleColor:[UIColor colorWithHexString:@"3CA0E6"] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor colorWithHexString:@"3CA0E6"] forState:UIControlStateNormal];
        
        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.leftBtn.layer.masksToBounds = self.rightBtn.layer.masksToBounds = YES;
        self.leftBtn.layer.cornerRadius = self.rightBtn.layer.cornerRadius = 3.0;
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        
        self.alertTextView.text = content;
        
        UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [xButton setImage:[UIImage imageNamed:@"btn_close_normal.png"] forState:UIControlStateNormal];
        [xButton setImage:[UIImage imageNamed:@"btn_close_selected.png"] forState:UIControlStateHighlighted];
        xButton.frame = CGRectMake(kAlertWidth - 32, 0, 32, 32);
        [self addSubview:xButton];
        [xButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

- (void)leftBtnClicked:(id)sender
{
    _leftLeave = YES;
    [self dismissAlert];
    if (self.leftBlock) {
        self.leftBlock();
    }
}

- (void)rightBtnClicked:(id)sender
{
    _leftLeave = NO;
    [self dismissAlert];
    if (self.rightBlock) {
        self.rightBlock(self.alertTextView.text);
    }
}

- (void)show
{
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, - kAlertHeight - 30, kAlertWidth, kAlertHeight);
    [topVC.view addSubview:self];
}

- (void)dismissAlert
{
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)removeFromSuperview
{
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
    UIViewController *topVC = [self appRootViewController];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, CGRectGetHeight(topVC.view.bounds), kAlertWidth, kAlertHeight);
    self.frame = afterFrame;
    [super removeFromSuperview];
//    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.frame = afterFrame;
//        
//        if (_leftLeave) {
//            self.transform = CGAffineTransformMakeRotation(-M_1_PI / 1.5);
//        }else {
//            self.transform = CGAffineTransformMakeRotation(M_1_PI / 1.5);
//        }
//    } completion:^(BOOL finished) {
//        [super removeFromSuperview];
//    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!self.backImageView) {
        self.backImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.backImageView.backgroundColor = [UIColor blackColor];
        self.backImageView.alpha = 0.6f;
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    [topVC.view addSubview:self.backImageView];
    self.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - kAlertHeight) * 0.3, kAlertWidth, kAlertHeight);
    self.transform = CGAffineTransformMakeRotation(0);
    self.frame = afterFrame;
    [super willMoveToSuperview:newSuperview];
//    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        self.transform = CGAffineTransformMakeRotation(0);
//        self.frame = afterFrame;
//    } completion:^(BOOL finished) {
//    }];
//    [super willMoveToSuperview:newSuperview];
}

@end

@implementation UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
