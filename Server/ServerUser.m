//
//  ServerUser.m
//  DPH
//
//  Created by cym on 16/1/30.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "ServerUser.h"
#import "NSString+Check.h"


@implementation ServerUser

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
        
        self.network = [[NetworkLogin alloc] init];
        
        self.model = [[ModelUser alloc] init];
        
        [self.model userRead];
    }
    return self;
}


-(void)userCodePhone:(NSString *)phone success:(CoreSuccess)csuccess failure:(CoreFailure)cfailure{
    if (![NSString isMobileNumber:phone]) {
        if (cfailure) {
            cfailure(@"请输入正确手机号");
        }
        return;
    }
    
    [self.network sgetVerify:phone
                     success:^(id obj){
                         
                         if (csuccess) {
                             csuccess(obj);
                         }
                         
                     }
                     failure:^(id result){
                         
                         if (cfailure) {
                             cfailure(@"错误!");
                         }
                         
                     }];
}

-(void)userLogin:(NSString *)mobile code:(NSString *)code success:(CoreSuccess)csuccess failure:(CoreFailure)cfailure
{
    if (![NSString isMobileNumber:mobile]) {
        if(cfailure){
            cfailure(@"请输入正确手机号");
        }
        return;
    }
    
    
    [self.network sloginPhone:mobile
                         code:code
                      success:^(id obj){
                          
                          NSDictionary *dic = (NSDictionary *)obj;
                          [UserDefaultUtils saveValue:dic[@"id"] forKey:@"userId"];
                          [UserDefaultUtils saveValue:dic[@"partnerId"] forKey:@"partnerId"];
                          [UserDefaultUtils saveValue:@"1" forKey:@"isLogin"];
                          self.model = [ModelUser yy_modelWithDictionary:dic];
                          [self.model userSave];
                          if (csuccess) {
                              csuccess(dic);
                          }
                      }
                      failure:^(id result){
                          
                          if (cfailure) {
                              cfailure(result);
                          }
                      }];
}



@end
