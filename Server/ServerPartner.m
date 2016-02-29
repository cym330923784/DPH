//
//  ServerPartner.m
//  DPH
//
//  Created by cym on 16/2/1.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "ServerPartner.h"
#import "NSString+Check.h"


@implementation ServerPartner

+(instancetype)sharedInstance{
    
    static id sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.pNetwork = [[PNetworkLogin alloc] init];
        
        self.model = [[ModelPartner alloc] init];
        
        [self.model partnerRead];
    }
    return self;
}


-(void)partnerLogin:(NSString *)mobile code:(NSString *)code success:(CoreSuccess)csuccess failure:(CoreFailure)cfailure
{
    if (![NSString isMobileNumber:mobile]) {
        if(cfailure){
            cfailure(@"请输入正确手机号");
        }
        return;
    }
    
    [self.pNetwork partnerLoginPhone:mobile
                         code:code
                      success:^(id obj){
                          
                          NSDictionary *dic = (NSDictionary *)obj;
                          [UserDefaultUtils saveValue:dic[@"id"] forKey:@"branchUserId"];
                          [UserDefaultUtils saveValue:dic[@"partnerId"] forKey:@"partnerId"];
                          [UserDefaultUtils saveValue:@"1" forKey:@"isLogin"];
                          self.model = [ModelPartner yy_modelWithDictionary:dic];
                          [self.model partnerSave];
                          if (csuccess) {
                              csuccess(dic);
                          }
                      }
                      failure:^(id result){
                          
                          if (cfailure) {
                              cfailure(result[@"messageContent"]);
                          }
                      }];
}


@end
