//
//  AppDelegate.m
//  DPH
//
//  Created by cym on 16/1/25.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabbarCtrl.h"
#import <IQKeyboardManager.h>
#import "PMainTabbarCtrl.h"
#import "CYM_GuideVC.h"
#import "CALayer+Transition.h"
#import "NetworkStatus.h"
#import "InitSQL.h"
#import "AppDelegate+JPush.h"
#import "JPUSHService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //首次进入APP
    
    if ((![UserDefaultUtils valueWithKey:@"isLogin"])) {
//        UIStoryboard *board         = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//        UINavigationController * firstNav = [board instantiateViewControllerWithIdentifier:@"NavLogin"];
//        self.window.rootViewController = firstNav;
        self.window.rootViewController = [CYM_GuideVC newFeatureVCWithImageNames:@[@"homePage_ico_find",@"homePage_ico_home",@"homePage_ico_shop",@"homePage_ico_user"] enterBlock:^{
            
            NSLog(@"进入主页面");
            [self enter];
            
        } configuration:^(UIButton *enterButton) { // 配置进入按钮
//            [enterButton setBackgroundImage:[UIImage imageNamed:@"btn_nor"] forState:UIControlStateNormal];
            [enterButton setBackgroundColor:[UIColor yellowColor]];
            [enterButton setBackgroundImage:[UIImage imageNamed:@"btn_pressed"] forState:UIControlStateHighlighted];
            enterButton.bounds = CGRectMake(0, 0, 120, 40);
            enterButton.center = CGPointMake(KScreenW * 0.5, KScreenH* 0.85);
        }];

    }
    else
    {
        if ([[UserDefaultUtils valueWithKey:@"isLogin"]isEqualToString:@"0"]) {
            UIStoryboard *board         = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            UINavigationController * firstNav = [board instantiateViewControllerWithIdentifier:@"LoginVC"];
            self.window.rootViewController = firstNav;

        }
        else
        {
            if ([UserDefaultUtils valueWithKey:@"userId"]) {
                MainTabbarCtrl * mainCtrl = [[MainTabbarCtrl alloc]init];
                self.window.rootViewController = mainCtrl;
            }
            else
            {
                PMainTabbarCtrl * pMainCtrl = [[PMainTabbarCtrl alloc]init];
                self.window.rootViewController = pMainCtrl;
            }
        }
    }

    [NSThread sleepForTimeInterval:1.0];
    [self.window makeKeyAndVisible];
    [NetworkStatus sharedInstance];
    [InitSQL copyDB];
    
//    [self jPushApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //接收到非apn通知
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    // Required
    //如需兼容旧版本的方式，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化和同时使用pushConfig.plist文件声明appKey等配置内容。
    [JPUSHService setupWithOption:launchOptions appKey:@"bcf4fa61632b5575315c6d4a" channel:@"APP Store" apsForProduction:false];

    
    return YES;
}

-(void)enter{
    
    UIStoryboard *board         = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UINavigationController * firstNav = [board instantiateViewControllerWithIdentifier:@"LoginVC"];
    self.window.rootViewController = firstNav;
    [self.window.layer transitionWithAnimType:TransitionAnimTypeRippleEffect subType:TransitionSubtypesFromRamdom curve:TransitionCurveEaseInEaseOut duration:2.0f];

}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
    
    NSLog(@"%@   %@   %@",content,extras,customizeField1);
    
}




- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    //    [JPUSHService handleRemoteNotification:userInfo];
    
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    // 取得Extras字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeExtras"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content =[%@], badge=[%ld], sound=[%@], customize field  =[%@]",content,(long)badge,sound,customizeField1);
    
    // Required
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"didReceiveRemoteNotification");
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

                                         
                                

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
