//
//  PNetworkManage.m
//  DPH
//
//  Created by Cym on 16/2/25.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PNetworkManage.h"

@implementation PNetworkManage

+(PNetworkManage *)sharedManager
{
    static PNetworkManage *sharedPartnerNetworkManage = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedPartnerNetworkManage = [[self alloc] init];
    });
    return sharedPartnerNetworkManage;
}


-(void)getUserInfoByPartnerId:(NSString *)partnerId
                      success:(networkSuccess)success
                      failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"uId":partnerId};
    
    [super sendRequestToServiceByPost:dic serveUrl:@"api/pUser/showUserInfo"
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


-(void)editCompanyInfoByObject:(ModelCompany *)modelCompany
                       success:(networkSuccess)success
                       failure:(networkFailure)failure
{
    NSDictionary * dic = [modelCompany yy_modelToJSONObject];
    NSString * str = [AppUtils dictionaryToJson:dic];
    NSDictionary * adic = @{@"jsonObject":str};
    
    [super sendRequestToServiceByPost:adic
                             serveUrl:@"api/partner/update"
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


-(void)getCashTotalByPartnerId:(NSString *)partnerId
                 beginDate:(NSString *)beginDate
                   endDate:(NSString *)endDate
                   success:(networkSuccess)success
                   failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"partnerId":partnerId,
                           @"beginDate":beginDate,
                           @"endDate":endDate};
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/partnerOrder/showPaymentMap"
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

-(void)getCashRecordListByPartnerId:(NSString *)partnerId
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
                             serveUrl:@"api/partnerOrder/showPaymentList"
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

-(void)getCashRecordDetailByRecordId:(NSString *)recordId
                             success:(networkSuccess)success
                             failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"id":recordId};
    [super sendRequestToServiceByPost:dic
                             serveUrl:@"api/partnerOrder/showPaymentDetail"
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

-(void)getStaffListByPartnerId:(NSString *)partnerId
                        pageNo:(NSString *)pageNo
                       success:(networkSuccess)success
                       failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"uId":partnerId,
                           @"pageNo":pageNo};
    
    [super sendRequestToServiceByPost:dic serveUrl:@"api/pUser/showUserList"
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

-(void)editStaffObject:(ModelStaff *)modelStaff
               success:(networkSuccess)success
               failure:(networkFailure)failure
{
    NSDictionary * dic = [AppUtils getObjectData:modelStaff];
    NSString * str = [AppUtils dictionaryToJson:dic];
    NSDictionary * adic = @{@"jsonObject":str};
    
    [super sendRequestToServiceByPost:adic
                             serveUrl:@"api/pUser/updateUserInfo"
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

-(void)addStaffObject:(ModelStaff *)modelStaff
              success:(networkSuccess)success
              failure:(networkFailure)failure
{
    NSDictionary * dic = [AppUtils getObjectData:modelStaff];
    NSString * str = [AppUtils dictionaryToJson:dic];
    NSDictionary * adic = @{@"jsonObject":str};
    
    [super sendRequestToServiceByPost:adic
                             serveUrl:@"api/pUser/addUserInfo"
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
