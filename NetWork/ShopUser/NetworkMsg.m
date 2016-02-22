//
//  NetworkMsg.m
//  DPH
//
//  Created by cym on 16/2/1.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "NetworkMsg.h"

@implementation NetworkMsg

+(NetworkMsg *)sharedManager{
    static NetworkMsg *sharedNetworkMsg = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedNetworkMsg = [[self alloc] init];
    });
    return sharedNetworkMsg;
}

-(void)getMsgListByUserId:(NSString *)userId
              messageType:(NSString *)messageType
                   pageNo:(NSString *)pageNo
                  success:(networkSuccess)success
                  failure:(networkFailure)failure
{
    NSDictionary * dic = @{@"endClientId":userId,
                           @"messageType":messageType,
                           @"pageNo":pageNo};
    
    [super sendRequestToServiceByPost:dic serveUrl:@"api/message/show"
                              success:^(id result) {
                                  if ([result[@"state"] isEqualToString:@"success"])
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

@end
