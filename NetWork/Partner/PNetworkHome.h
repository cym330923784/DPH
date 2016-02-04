//
//  PNetworkHome.h
//  DPH
//
//  Created by cym on 16/2/2.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseNetwork.h"
#import "ModelProduct.h"

@interface PNetworkHome : BaseNetwork

+(PNetworkHome *)sharedManager;


-(void)getProductListByPartnerId:(NSString *)partnerId
                          pageNo:(NSString *)pageNo
                         success:(networkSuccess)success
                         failure:(networkFailure)failure;

-(void)getProductDetailByProductId:(NSString *)productId
                         partnerId:(NSString *)partnerId
                           success:(networkSuccess)success
                           failure:(networkFailure)failure;

-(void)submitProductChangeByPartnerId:(NSString *)partnerId
                            productId:(NSString *)productId
                         sellingPrice:(NSString *)sellingPrice
                           storageQty:(NSString *)storageQty
                          shelfStatus:(NSString *)shelfStatus
                              success:(networkSuccess)success
                              failure:(networkFailure)failure;

@end
