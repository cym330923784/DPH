//
//  PNetworkReport.m
//  DPH
//
//  Created by cym on 16/2/3.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PNetworkReport.h"

@implementation PNetworkReport

+(PNetworkReport *)sharedManager
{
    static PNetworkReport *sharedPartnerNetworkReport = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedPartnerNetworkReport = [[self alloc] init];
    });
    return sharedPartnerNetworkReport;
}


-(void)getTotalByPartnerId:(NSString *)partnerId
                 beginDate:(NSString *)beginDate
                   endDate:(NSString *)endDate
                   success:(networkSuccess)success
                   failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"partnerId":partnerId,
                           @"beginDate":beginDate,
                           @"endDate":endDate};
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/partnerOrder/countOrderMap"
                              success:^(id result) {
                                  if ([result[@"state"] isEqualToString:@"success"])
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

-(void)getReportListByPartnerId:(NSString *)partnerId
                      beginDate:(NSString *)beginDate
                        endDate:(NSString *)endDate
                         pageNo:(NSString *)pageNo
                        success:(networkSuccess)success
                        failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"partnerId":partnerId,
                           @"beginDate":beginDate,
                           @"endDate":endDate,
                           @"pageNo":pageNo};
    
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/partnerOrder/countOrderList"
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


@end
