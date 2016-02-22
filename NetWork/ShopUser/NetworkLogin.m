//
//  NetworkLogin.m
//  DPH
//
//  Created by cym on 16/1/30.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "NetworkLogin.h"
#import "AppUtils.h"

@implementation NetworkLogin

+(NetworkLogin *)sharedManager
{
    static NetworkLogin *sharedNetworkLogin = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedNetworkLogin = [[self alloc] init];
    });
    return sharedNetworkLogin;
}

-(void)sgetVerify:(NSString *)phone success:(networkSuccess)success failure:(networkFailure)failure{
    
    NSDictionary *dic = @{@"phone":phone};
    
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/common/sendCode"
                              success:^(id obj){
                                  
                                  NSDictionary *odic = (NSDictionary *)obj;
                                  
                                  if ([odic[@"state"] isEqual:@"success"]) {
                                      
                                      if (success) {
                                          success(odic);
                                      }
                                  }else{
                                      
                                      if (failure) {
                                          failure(odic[@"messageContent"]);
                                      }
                                  }
                              }
                              failure:^(id result){
                                  
                                  if (failure) {
                                      failure(@"出错!");
                                  }
                              }];
}

-(void)sloginPhone:(NSString *)phone
              code:(NSString *)code
           success:(networkSuccess)success
           failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"phone":phone,
                           @"code":code};
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"/api/user/login"
                              success:^(id result) {
                                  if ([result[@"state"] isEqualToString:@"success" ]) {
                                      if (success) {
                                          success(result);
                                      }
                                  }else{
                                      if (failure) {
                                          failure(result[@"messageContent"]);
                                      }
                                  }

                              } failure:^(id result) {
                                  if (failure) {
                                      failure(@"出错!");
                                  }
                              }];
}


@end
