//
//  NetworkHome.m
//  DPH
//
//  Created by cym on 16/1/30.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "NetworkHome.h"
#import "ModelFullStorage.h"

@implementation NetworkHome

+(NetworkHome *)sharedManager{
    static NetworkHome *sharedNetworkHome = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedNetworkHome = [[self alloc] init];
    });
    return sharedNetworkHome;
}



-(void)getCategoriesByUserId:(NSString *)userId
                     success:(networkSuccess)success
                     failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"uId":userId};
    
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/products/showCategories"
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
                                      failure(@"出错!");
                                  }
                              }];
}

-(void)getProductListByUserId:(NSString *)userId
                    partnerId:(NSString *)partnerId
                       pageNo:(NSString *)pageNo
                        level:(NSString *)level
                          ids:(NSString *)ids
                         type:(NSString *)type
                      success:(networkSuccess)success
                      failure:(networkFailure)failure
{
    
    NSDictionary * dic = @{@"uId":userId,
                           @"partnerId":partnerId,
                           @"pageNo":pageNo,
                           @"level":level,
                           @"ids":ids,
                           @"type":type};
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
                                          failure(result[@"messageContent"]);
                                      }
                                  }
                                  
                              } failure:^(id result) {
                                  if (failure) {
                                      failure(@"出错!");
                                  }
                              }];

}


-(void)collectProductByUserId:(NSString *)userId
                    productId:(NSString *)productId
                     isDelete:(BOOL)isDelete
                      success:(networkSuccess)success
                      failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"uId":userId,
                           @"productId":productId};
    NSString * urlStr = nil;
    if (isDelete) {
        urlStr = @"api/user/deleteFavorite";
    }
    else
    {
        urlStr = @"api/user/addFavorite";
    }
    [super sendRequestToServiceByPost:dic
                             serveUrl:urlStr
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
                                  
                              } failure:^(id result) {
                                  if (failure) {
                                      failure(@"出错!");
                                  }
                                  
                              }];
}

-(void)getproductInfoByProId:(NSString *)productId
                   partnerId:(NSString *)partnerId
                      userId:(NSString *)userId
                     success:(networkSuccess)success
                     failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"id":productId,
                           @"partnerId":partnerId,
                           @"uId":userId};
    
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
-(void)submitOrderByObject:(ModelOrder *)modelOrder
                 partnerId:(NSString *)partnerId
                   success:(networkSuccess)success
                   failure:(networkFailure)failure
{
    NSDictionary * dic = [AppUtils getObjectData:modelOrder];
    NSString * str = [AppUtils dictionaryToJson:dic];
    NSDictionary * adic = @{@"partnerId":partnerId,
                            @"jsonObject":str};
    
    [super sendRequestToServiceByPost:adic
                             serveUrl:@"api/endClientOrder/add"
                              success:^(id result) {
                                  if ([result[@"state"] isEqualToString:@"success"] || [result[@"state"] isEqualToString:@"lowStocks"])
                                  {
//                                      ModelFullStorage * model = [[ModelFullStorage alloc]init];
//                                      model.productId = @"5";
//                                      model.storage = @"40";
//                                      NSArray * errorArr = @[model];
                                      if (success) {
                                          success(result);
                                      }
//                                      if (success) {
//                                          success(errorArr);
//                                      }
                                  }
                                  else{
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
