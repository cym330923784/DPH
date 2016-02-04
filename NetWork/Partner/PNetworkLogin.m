//
//  PNetworkLogin.m
//  DPH
//
//  Created by cym on 16/2/1.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PNetworkLogin.h"

@implementation PNetworkLogin

+(PNetworkLogin *)sharedManager
{
    static PNetworkLogin *sharedPartnerNetworkLogin = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedPartnerNetworkLogin = [[self alloc] init];
    });
    return sharedPartnerNetworkLogin;
}


-(void)partnerLoginPhone:(NSString *)phone
              code:(NSString *)code
           success:(networkSuccess)success
           failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"phone":phone,
                           @"code":code};
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"/api/partner/login"
                              success:^(id result) {
                                  if ([result[@"state"] isEqualToString:@"success" ]) {
                                      if (success) {
                                          success(result);
                                      }
                                  }else{
                                      if (failure) {
                                          failure(result);
                                      }
                                  }
                                  
                              } failure:^(id result) {
                                  if (failure) {
                                      failure(@"请求失败!");
                                  }
                              }];
}

@end
