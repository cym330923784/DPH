//
//  NetworkQNImg.h
//  DPH
//
//  Created by cym on 16/2/2.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseNetwork.h"

@interface NetworkQNImg : BaseNetwork

+(NetworkQNImg *)sharedManager;


-(void)getQNTokenSuccess:(networkSuccess)success
                 failure:(networkFailure)failure;

@end
