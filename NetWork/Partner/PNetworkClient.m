//
//  PNetworkClient.m
//  DPH
//
//  Created by cym on 16/2/3.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PNetworkClient.h"

@implementation PNetworkClient

+(PNetworkClient *)sharedManager
{
    static PNetworkClient *sharedPartnerNetworkClient = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedPartnerNetworkClient = [[self alloc] init];
    });
    return sharedPartnerNetworkClient;
}

-(void)getClientListByPartnerId:(NSString *)partnerId
                         pageNo:(NSString *)pageNo
                        success:(networkSuccess)success
                        failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"partnerId":partnerId,
                           @"pageNo":pageNo};
    
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/partnerEndClient/showEndClient"
                              success:^(id result) {
                                  if ([result[@"state"] isEqualToString:@"success" ])
                                  {
                                      if (success) {
                                          success(result[@"data"]);
                                      }
                                  }else{
                                      if (failure) {
                                          failure(result[@"messageContent"]);
                                      }
                                  }
                              } failure:^(id result) {
                                  if (failure) {
                                      failure(@"请求失败!");
                                  }
                              }];
}

-(void)getClientDetailByEndClientId:(NSString *)endClientId
                            success:(networkSuccess)success
                            failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"endClientId":endClientId};
    
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/partnerEndClient/showEndClientDetail"
                              success:^(id result) {
                                  if ([result[@"state"] isEqualToString:@"success" ])
                                  {
                                      if (success) {
                                          success(result[@"data"]);
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

-(void)addClientByPartnerId:(NSString *)partnerId
                     Object:(ModelShop *)modelShop
                 success:(networkSuccess)success
                 failure:(networkFailure)failure
{
    NSDictionary * dic = [AppUtils getObjectData:modelShop];
    NSString * str = [AppUtils dictionaryToJson:dic];
    NSDictionary * adic = @{@"partnerId":partnerId,
                            @"jsonObject":str};
    
    [super sendRequestToServiceByPost:adic
                             serveUrl:@"api/partnerEndClient/add"
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

-(void)editClientByUserId:(NSString *)userId
                  Object:(ModelShop *)modelShop
                 success:(networkSuccess)success
                 failure:(networkFailure)failure
{
    NSDictionary * dic = [AppUtils getObjectData:modelShop];
    NSString * str = [AppUtils dictionaryToJson:dic];
    NSDictionary * adic = @{@"uId":userId,
                            @"jsonObject":str};
    
    [super sendRequestToServiceByPost:adic
                             serveUrl:@"api/partnerEndClient/update"
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


@end
