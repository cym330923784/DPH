//
//  NetworkMsg.h
//  DPH
//
//  Created by cym on 16/2/1.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseNetwork.h"

@interface NetworkMsg : BaseNetwork

+(NetworkMsg *)sharedManager;


/**
 *  獲取消息列表
 *
 *  @param userId   用户id
 *  @param messageType   消息类型
 *  @param pageNo   页码
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)getMsgListByUserId:(NSString *)userId
              messageType:(NSString *)messageType
                   pageNo:(NSString *)pageNo
                  success:(networkSuccess)success
                  failure:(networkFailure)failure;


@end
