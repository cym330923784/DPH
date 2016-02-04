//
//  NetworkStatus.m
//  DPH
//
//  Created by cym on 16/1/25.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "NetworkStatus.h"
#import <AFNetworking.h>
//#import "AppUtills.h"

@implementation NetworkStatus

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self getNetworkType];
    }
    return self;
}

-(BOOL)haveNetwork{
    NSLog(@"網絡情況：%d",self.isHaveNetwork);
    return self.isHaveNetwork;
}

-(void)getNetworkType{
    
    NSLog(@"判斷網絡狀態開始");
    AFNetworkReachabilityManager *mgr=[AFNetworkReachabilityManager sharedManager];
    __block NSString *statusMsg = nil;
    
    //当网络状态改变的时候，就会调用
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusUnknown) {
            
            NSLog(@"當前網絡狀態未知");
            self.isHaveNetwork = NO;
            self.netType = NetworkUnknow;
            statusMsg = @"请检查你的网络";
            
        }else if (status == AFNetworkReachabilityStatusNotReachable){
            
            NSLog(@"當前無網絡");
            self.isHaveNetwork = NO;
            self.netType = NetworkOff;
            statusMsg = @"网络连接断开";
            
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            
            NSLog(@"當前為手機網絡");
            self.isHaveNetwork = YES;
            self.netType = NetworkPhone;
            statusMsg = @"当前为移动网络";
            
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            
            NSLog(@"當前網絡狀態為wifi");
            self.isHaveNetwork = YES;
            self.netType = NetworkWifi;
            statusMsg = @"当前为WIFI网络";
            
        }
        //        [AppUtils showBarString:statusMsg];
    }];
    
    //开始监控
    [mgr startMonitoring];
    NSLog(@"判斷網絡狀態結束");
}


@end

