//
//  LoginVC.m
//  DPH
//
//  Created by cym on 16/1/25.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "LoginVC.h"
#import "AppDelegate.h"
#import "MainTabbarCtrl.h"
#import "PMainTabbarCtrl.h"
#import "BaseNetwork.h"
#import <QiniuSDK.h>
#import "NetworkLogin.h"
#import "ServerUser.h"
#import "UIColor+TenSixColor.h"
#import "UserDefaultUtils.h"
#import "ServerPartner.h"
#import "PNetworkLogin.h"
#import "NSString+Check.h"

@interface LoginVC ()
{
    NSString * validateCode;
    NSTimer * timer;
    int seconds;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;

@property (strong, nonatomic)NSString * token;
@property (strong, nonatomic)NSString * keyStr;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.token = [[NSString alloc]init];
    self.keyStr =[[NSString alloc]init];
    
    self.phoneTF.text = @"13541226263";
}

- (IBAction)sendCodeAction:(id)sender {
    if (![NSString isMobileNumber:self.phoneTF.text]) {
        [self showCommonHUD:@"请输入正确的手机号!"];
        return;
    }
    NSLog(@"发送验证码");
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    seconds = 100;
    [[ServerUser sharedInstance] userCodePhone:self.phoneTF.text
                                       success:^(id result) {
                                           NSLog(@"vc獲取驗證成功");
                                           NSDictionary * dic = (NSDictionary *)result;
                                           validateCode = dic[@"validateCode"];
                                       } failure:^(id result) {
                                           [self showCommonHUD:result];

                                           
                                       }];
}

//倒计时方法验证码实现倒计时100秒，100秒后按钮变换开始的样子
-(void)timerFireMethod:(NSTimer *)theTimer {
    if (seconds == 1) {
        [theTimer invalidate];
        seconds = 100;
        [self.sendCodeBtn setTitle:@"获取验证码" forState: UIControlStateNormal];
        [self.sendCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.sendCodeBtn setBackgroundColor:[UIColor colorWithHexString:@"3CA0E6"]];
        [self.sendCodeBtn setEnabled:YES];
    }else{
        seconds--;
        NSString *title = [NSString stringWithFormat:@"还剩%d",seconds];
        [self.sendCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.sendCodeBtn setBackgroundColor:[UIColor colorWithHexString:@"F0F0F0"]];
        [self.sendCodeBtn setEnabled:NO];
        [self.sendCodeBtn setTitle:title forState:UIControlStateNormal];
    }
}

//如果登陆成功，停止验证码的倒数，
- (void)releaseTImer {
    if (timer) {
        if ([timer respondsToSelector:@selector(isValid)]) {
            if ([timer isValid]) {
                [timer invalidate];
                seconds = 100;
            }
        }
    }
}

- (IBAction)selectShopUserAction:(id)sender {
    
    //****************暂时注释*****************
//    if (![self.codeTF.text isEqualToString:validateCode]) {
//        [self showCommonHUD:@"验证码错误!"];
//    }
//    else
//    {
        [self showDownloadsHUD:@"通信中..."];
        [[ServerUser sharedInstance] userLogin:self.phoneTF.text code:self.codeTF.text success:^(id result) {
            [self releaseTImer];
            [self dismissHUD];
            NSString * badgeValue = @"0";
            [UserDefaultUtils saveValue:badgeValue forKey:@"badgeValue"];
            MainTabbarCtrl *mainTab        = [[MainTabbarCtrl alloc] init];
            AppDelegate * app = [UIApplication sharedApplication].delegate;
            app.window.rootViewController = mainTab;//进入商户主界面

        } failure:^(id result) {
            [self dismissHUD];
            [self showCommonHUD:result];

        }];

//    }
}
- (IBAction)selectPartnerAction:(id)sender {
//    BaseNetwork * base = [[BaseNetwork alloc]init];
//    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    NSLog(@"%@",version);
//    NSDictionary * dic = @{};
//    NSString * str = [NSString stringWithFormat:@"api/common/get/%@",version];
//    [base sendRequestToServiceByGet:dic serveUrl:str success:^(id result) {
//        NSLog(@"%@",result);
//        self.token = result[@"token"];
//        UIImage * image = [UIImage imageNamed:@"homePage_ico_shop"];
//        QNUploadManager * manager = [[QNUploadManager alloc]init];
//        NSData *imageData = UIImagePNGRepresentation(image);// png
//**************************七牛上传图片*************************************
//        [manager putData:imageData key:nil token:self.token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//            NSLog(@"info = %@",info);
//            NSLog(@"resp = %@",resp);
//            self.keyStr = resp[@"key"];
//            NSLog(@"key = %@",self.keyStr);
//
//        } option:nil];
//
//    } failure:^(id result) {
//        
//    }];
//    
//    if (![self.codeTF.text isEqualToString:validateCode]) {
//        [self showCommonHUD:@"验证码错误!"];
//        return;
//    }
    
//    if (![self.codeTF.text isEqualToString:validateCode]) {
//        [self showCommonHUD:@"验证码错误!"];
//    }
//    else
//    {
        [self showDownloadsHUD:@"通信中..."];
        
        [[ServerPartner sharedInstance] partnerLogin:self.phoneTF.text
                                                code:self.codeTF.text
                                             success:^(id result) {
                                                 [self releaseTImer];
                                                 [self dismissHUD];
                                                 PMainTabbarCtrl *pMainTab        = [[PMainTabbarCtrl alloc] init];
                                                 AppDelegate * app = [UIApplication sharedApplication].delegate;
                                                 app.window.rootViewController = pMainTab;//进入合伙人主界面
                                                 
                                             }
                                             failure:^(id result) {
                                                 [self dismissHUD];
                                                 [self showCommonHUD:result];
                                                 
                                             }];
//    }
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
