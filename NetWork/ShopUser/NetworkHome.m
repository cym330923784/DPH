//
//  NetworkHome.m
//  DPH
//
//  Created by cym on 16/1/30.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "NetworkHome.h"
#import "AppUtils.h"

@implementation NetworkHome

+(NetworkHome *)sharedManager{
    static NetworkHome *sharedNetworkHome = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedNetworkHome = [[self alloc] init];
    });
    return sharedNetworkHome;
}

-(void)getProductListByUserId:(NSString *)userId
                    partnerId:(NSString *)partnerId
                       pageNo:(NSString *)pageNo
                      success:(networkSuccess)success
                      failure:(networkFailure)failure
{
    
    NSDictionary * dic = @{@"uId":userId,
                           @"partnerId":partnerId,
                           @"pageNo":pageNo};
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/products/show"
                              success:^(id result) {
                                  
                                  if ([result[@"state"] isEqualToString:@"success" ])
                                  {
                                      if (success) {
                                          success(result[@"data"]);
                                      }
                                  }else{
                                      if (failure) {
                                          failure(@"出错!");
                                      }
                                  }
                                  
                              } failure:^(id result) {
                                  if (failure) {
                                      failure(@"出错!");
                                  }
                              }];

}

-(void)getproductInfoByProId:(NSString *)productId
                      partnerId:(NSString *)partnerId
                     success:(networkSuccess)success
                     failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"id":productId,
                           @"partnerId":partnerId};
    
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/products/showDetail"
                              success:^(id result) {
                                  if ([result[@"state"] isEqualToString:@"success" ])
                                  {
                                      if (success) {
                                          success(result);
                                      }
                                  }else{
                                      if (failure) {
                                          failure(@"出错!");
                                      }
                                  }
                              }
                              failure:^(id result) {
                                  if (failure) {
                                      failure(@"出错!");
                                  }
                              }];
}


-(void)getAddressListByUserId:(NSString *)userId
                      success:(networkSuccess)success
                      failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"uId":userId};
    [super sendRequestToServiceByPost:dic serveUrl:@"api/address/show"
                              success:^(id result) {
                                  if ([result[@"state"] isEqualToString:@"success" ])
                                  {
                                      if (success) {
                                          success(result[@"data"]);
                                      }
                                  }else{
                                      if (failure) {
                                          failure(@"出错!");
                                      }
                                  }
                                  
                              }
                              failure:^(id result) {
                                  if (failure) {
                                      failure(@"出错!");
                                  }
                              }];
}

-(void)addAddressByUserId:(NSString *)userId
                     name:(NSString *)name
                    phone:(NSString *)phone
                  address:(NSString *)address
                  success:(networkSuccess)success
                  failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"uId":userId,
                           @"name":name,
                           @"phone":phone,
                           @"address":address};
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/address/add"
                              success:^(id result) {
                                  if ([result[@"state"] isEqualToString:@"success" ])
                                  {
                                      if (success) {
                                          success(result);
                                      }
                                  }else{
                                      if (failure) {
                                          failure(@"出错!");
                                      }
                                  }
                              }
                              failure:^(id result) {
                                  if (failure) {
                                      failure(@"出错!");
                                  }
                              }];
}

-(void)setAddressByUserId:(NSString *)userId
                addressId:(NSString *)addressId
                  success:(networkSuccess)success
                  failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"uId":userId,
                           @"addId":addressId};
    
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/address/update"
                              success:^(id result) {
                                  if ([result[@"state"] isEqualToString:@"success" ])
                                  {
                                      if (success) {
                                          success(result);
                                      }
                                  }else{
                                      if (failure) {
                                          failure(@"出错!");
                                      }
                                  }
                              }
                              failure:^(id result) {
                                  if (failure) {
                                      failure(@"出错!");
                                  }
                              }];
}
-(void)submitOrderByObject:(ModelOrder *)modelOrder
                   success:(networkSuccess)success
                   failure:(networkFailure)failure
{
    NSDictionary * dic = [AppUtils getObjectData:modelOrder];
    NSString * str = [AppUtils dictionaryToJson:dic];
    NSDictionary * adic = @{@"jsonObject":str};
    
    [super sendRequestToServiceByPost:adic
                             serveUrl:@"api/endClientOrder/add"
                              success:^(id result) {
                                  if ([result[@"state"] isEqualToString:@"success" ])
                                  {
                                      if (success) {
                                          success(result);
                                      }
                                  }else{
                                      if (failure) {
                                          failure(@"出错!");
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
