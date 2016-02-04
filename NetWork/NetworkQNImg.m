//
//  NetworkQNImg.m
//  DPH
//
//  Created by cym on 16/2/2.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "NetworkQNImg.h"

@implementation NetworkQNImg

+(NetworkQNImg *)sharedManager{
    static NetworkQNImg *sharedNetworkQNImg = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedNetworkQNImg = [[self alloc] init];
    });
    return sharedNetworkQNImg;
}

-(void)getQNTokenSuccess:(networkSuccess)success
                 failure:(networkFailure)failure
{
    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDictionary * dic = @{@"version":version};
//    NSString * str = [NSString stringWithFormat:@"api/common/get/%@",version];
//    [super sendRequestToServiceByGet:dic
//                            serveUrl:str
//                             success:^(id result) {
//                                 if ([result[@"state"] isEqualToString:@"success" ])
//                                 {
//                                     if (success) {
//                                         success(result);
//                                     }
//                                 }else{
//                                     if (failure) {
//                                         failure(@"上传失败!");
//                                     }
//                                 }
//                             }
//                             failure:^(id result) {
//                                 if (failure) {
//                                     failure(@"出错!");
//                                 }
//                                 
//                             }];
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/common/get"
                              success:^(id result) {
                                  if ([result[@"state"] isEqualToString:@"success"])
                                  {
                                      if (success) {
                                          success(result);
                                      }
                                  }else{
                                      if (failure) {
                                          failure(@"上传失败!");
                                      }
                                  }

    } failure:^(id result) {
        if (failure) {
            failure(@"出错!");
        }
    }];
}

@end
