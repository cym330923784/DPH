//
//  DatePickerView.m
//  YeTao
//
//  Created by cym on 15/12/16.
//  Copyright © 2015年 YeTao. All rights reserved.
//

#import "DatePickerView.h"
#import "NetworkUser.h"
#import "UserDefaultUtils.h"
#import <MBProgressHUD.h>

@interface DatePickerView ()


@property (nonatomic, strong) UIView *backImageView;

@end

@implementation DatePickerView

-(id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}



-(void)awakeFromNib
{
//    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    NSDate *now = [NSDate date];
//    self.datePicker.date = self.userDate;
    self.datePicker.maximumDate = now;

}

- (void)show
{
    
    UIViewController *topVC = [self appRootViewController];
    
    UIView  * reportView = [[NSBundle mainBundle] loadNibNamed:@"DatePickerView" owner:self options:nil][0];
    reportView.frame = CGRectMake(0,Screen.height-240,Screen.width,240);
    [topVC.view addSubview:reportView];
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
    [super removeFromSuperview];
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
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
        [self.backImageView addGestureRecognizer:tap];
    }
    [topVC.view addSubview:self.backImageView];
    [super willMoveToSuperview:newSuperview];
}

-(void)close
{
    [self removeFromSuperview];
}
- (IBAction)finishAction:(id)sender {
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    //设置日期展示格式 yy表示24小时制 y表示12小时制 a表示上午
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //为当前日期设置格式化 stringFromDate
   NSString * timeStr = [formatter stringFromDate:self.datePicker.date];

    NSDictionary * dateDic = [NSDictionary dictionaryWithObjectsAndKeys:timeStr,@"date", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"dateFinish" object:self userInfo:dateDic];
    [self removeFromSuperview];
    
    
}

-(void)showCommonHUD:(NSString *)status{
    MBProgressHUD *hud            = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode                      = MBProgressHUDModeText;
    hud.labelText                 = status;
    hud.margin                    = 10.f;
    hud.yOffset                   = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.5];
}

@end
