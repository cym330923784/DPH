//
//  PNetworkHome.m
//  DPH
//
//  Created by cym on 16/2/2.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PNetworkHome.h"

@implementation PNetworkHome

+(PNetworkHome *)sharedManager
{
    static PNetworkHome *sharedPartnerNetworkHome = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedPartnerNetworkHome = [[self alloc] init];
    });
    return sharedPartnerNetworkHome;
}


-(void)getProductListByPartnerId:(NSString *)partnerId
                          pageNo:(NSString *)pageNo
                         success:(networkSuccess)success
                         failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"partnerId":partnerId,
                           @"pageNo":pageNo};
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/partner/products/show"
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
                                      failure(result);
                                  }
                              }];
}

-(void)getProductDetailByProductId:(NSString *)productId
                         partnerId:(NSString *)partnerId
                           success:(networkSuccess)success
                           failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"id":productId,
                           @"partnerId":partnerId};
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/partner/products/showDetail"
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


-(void)submitProductChangeByPartnerId:(NSString *)partnerId
                            productId:(NSString *)productId
                         sellingPrice:(NSString *)sellingPrice
                           storageQty:(NSString *)storageQty
                          shelfStatus:(NSString *)shelfStatus
                              success:(networkSuccess)success
                              failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"productId":productId,
                           @"sellingPrice":sellingPrice,
                           @"storageQty":storageQty,
                           @"shelfStatus":shelfStatus};
    NSString * str = [AppUtils dictionaryToJson:dic];
    NSDictionary * adic = @{@"jsonObject":str,
                            @"partnerId":partnerId};
    [super sendRequestToServiceByPost:adic
                             serveUrl:@"api/partner/products/update"
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
