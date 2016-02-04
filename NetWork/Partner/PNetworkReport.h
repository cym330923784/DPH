//
//  PNetworkReport.h
//  DPH
//
//  Created by cym on 16/2/3.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseNetwork.h"

@interface PNetworkReport : BaseNetwork

+(PNetworkReport *)sharedManager;


/**
 *  獲取报表总数据
 *
 *  @param partnerId   合伙人id
 *  @param beginDate   开始时间
 *  @param endDate   截止时间
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)getTotalByPartnerId:(NSString *)partnerId
                 beginDate:(NSString *)beginDate
                   endDate:(NSString *)endDate
                   success:(networkSuccess)success
                   failure:(networkFailure)failure;

/**
 *  獲取报表列表
 *
 *  @param partnerId   合伙人id
 *  @param beginDate   开始时间
 *  @param endDate   截止时间
 *  @param pageNo   页码
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)getReportListByPartnerId:(NSString *)partnerId
                      beginDate:(NSString *)beginDate
                        endDate:(NSString *)endDate
                         pageNo:(NSString *)pageNo
                        success:(networkSuccess)success
                        failure:(networkFailure)failure;


@end
