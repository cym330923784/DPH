//
//  NetworkOrder.m
//  DPH
//
//  Created by cym on 16/1/31.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "NetworkOrder.h"

@implementation NetworkOrder
+(NetworkOrder *)sharedManager{
    static NetworkOrder *sharedNetworkOrder = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedNetworkOrder = [[self alloc] init];
    });
    return sharedNetworkOrder;
}


-(void)getOrderListByUserId:(NSString *)userId
                      state:(NSString *)state
                     pageNo:(NSString *)pageNo
                    success:(networkSuccess)success
                    failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"endClientId":userId,
                           @"orderStatus":state,
                           @"pageNo":pageNo};
    [super sendRequestToServiceByPost:dic serveUrl:@"api/endClientOrder/show"
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
                             serveUrl:@"api/endClientOrder/showDetail"
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


-(void)getORderProductListByOrderId:(NSString *)orderId
                            success:(networkSuccess)success
                            failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"orderId":orderId};
    
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/endClientOrder/showInventoryList" success:^(id result) {
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

-(void)confirmReceiveByOrderId:(NSString *)orderId
                   endClientId:(NSString *)endClientId
                       success:(networkSuccess)success
                       failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"orderId":orderId,
                           @"endClientId":endClientId};
    
    [super sendRequestToServiceByPost:dic serveUrl:@"api/endClientOrder/updateOrderStatus"
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
