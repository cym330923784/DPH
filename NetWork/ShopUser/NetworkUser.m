//
//  NetworkUser.m
//  DPH
//
//  Created by cym on 16/1/31.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "NetworkUser.h"

@implementation NetworkUser

+(NetworkUser *)sharedManager{
    static NetworkUser *sharedNetworkUser = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedNetworkUser = [[self alloc] init];
    });
    return sharedNetworkUser;
}

-(void)getUserInfoByUserId:(NSString *)userId
                   success:(networkSuccess)success
                   failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"uId":userId};
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/user/get"
                              success:^(id result) {
                                  if ([result[@"state"] isEqualToString:@"success" ])
                                  {
                                      if (success) {
                                          success(result);
                                      }
                                  }else{
                                      if (failure) {
                                          failure(result[@"messageContent"]);
                                      }
                                  }
                              }
                              failure:^(id result) {
                                  if (failure) {
                                      failure(@"出错!");
                                  }
                              }];
}


-(void)getCompanyInfoByPartnerId:(NSString *)partnerId
                         success:(networkSuccess)success
                         failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"partnerId":partnerId};
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/partner/show"
                              success:^(id result) {
                                  if ([result[@"state"] isEqualToString:@"success"])
                                  {
                                      if (success) {
                                          success(result);
                                      }
                                  }else{
                                      if (failure) {
                                          failure(result[@"messageContent"]);
                                      }
                                  }
                              }
                              failure:^(id result) {
                                  if (failure) {
                                      failure(@"出错!");
                                  }
                              }];
}

@end
