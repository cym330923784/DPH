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
#import "UserDefaultUtils.h"
#import "PMainTabbarCtrl.h"
#import "CYM_GuideVC.h"
#import "CALayer+Transition.h"

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
    
    return YES;
}

-(void)enter{
    
    UIStoryboard *board         = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UINavigationController * firstNav = [board instantiateViewControllerWithIdentifier:@"LoginVC"];
    self.window.rootViewController = firstNav;
    [self.window.layer transitionWithAnimType:TransitionAnimTypeRippleEffect subType:TransitionSubtypesFromRamdom curve:TransitionCurveEaseInEaseOut duration:2.0f];

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
