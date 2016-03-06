//
//  PNetworkOrder.m
//  DPH
//
//  Created by cym on 16/2/2.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PNetworkOrder.h"

@implementation PNetworkOrder

+(PNetworkOrder *)sharedManager
{
    static PNetworkOrder *sharedPartnerNetworkOrder = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedPartnerNetworkOrder = [[self alloc] init];
    });
    return sharedPartnerNetworkOrder;
}

-(void)getOrderListByPartnerId:(NSString *)partnerId
                   orderStatus:(NSString *)orderStatus
                        pageNo:(NSString *)pageNo
                       success:(networkSuccess)success
                       failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"partnerId":partnerId,
                           @"orderStatus":orderStatus,
                           @"pageNo":pageNo};
    
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/partnerOrder/show"
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

-(void)getOrderDetailByOrderId:(NSString *)orderId
                       success:(networkSuccess)success
                       failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"orderId":orderId};
    
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/partnerOrder/showDetail"
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

-(void)getOrderProductListByOrderId:(NSString *)orderId
                            success:(networkSuccess)success
                            failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"orderId":orderId};
    
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/partnerOrder/showInventoryList" success:^(id result) {
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

-(void)addPaymentByObject:(ModelPayWay *)modelPayWay
                  success:(networkSuccess)success
                  failure:(networkFailure)failure
{
    NSDictionary * dic = [AppUtils getObjectData:modelPayWay];
    NSString * str = [AppUtils dictionaryToJson:dic];
    NSDictionary * adic = @{@"jsonObject":str};
    
    [super sendRequestToServiceByPost:adic
                             serveUrl:@"api/partnerOrder/add"
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

-(void)updateOrderStatusByOrderId:(NSString *)orderId
                        partnerId:(NSString *)partnerId
                      orderStatus:(NSString *)orderStatus
                          success:(networkSuccess)success
                          failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"orderId":orderId,
                           @"partnerId":partnerId,
                           @"orderStatus":orderStatus};
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/partnerOrder/updateOrderStatus"
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

-(void)getDilliveryOrderListByUserId:(NSString *)userId
                         orderStatus:(NSString *)orderStatus
                              pageNo:(NSString *)pageNo
                             success:(networkSuccess)success
                             failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"uId":userId,
                           @"orderStatus":orderStatus,
                           @"pageNo":pageNo};
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/partnerOrder/showDeliveryOrder"
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

-(void)changeDiliveryOrderByOrderIds:(NSString *)orderIds
                           userId:(NSString *)userId
                         orderStatus:(NSString *)orderStatus
                             success:(networkSuccess)success
                             failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"ordersId":orderIds,
                           @"uId":userId,
                           @"orderStatus":orderStatus};
    
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/partnerOrder/batchProcessingOrderStatus"
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


-(void)backDeliveryOrderByOrder:(NSString *)orderId
                         userId:(NSString *)userId
                    reason:(NSString *)reason
                        success:(networkSuccess)success
                        failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"orderId":orderId,
                           @"uId":userId,
                           @"reason":reason};
    
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/partnerOrder/returnOrder"
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


-(void)removeDeliveryOrderByOrder:(NSString *)orderId
                           userId:(NSString *)userId
                          success:(networkSuccess)success
                          failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"ordersId":orderId,
                           @"uId":userId};
    
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/partnerOrder/removeOrderList"
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
