//
//  PNetworkManage.h
//  DPH
//
//  Created by Cym on 16/2/25.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseNetwork.h"
#import "ModelStaff.h"
#import "ModelCompany.h"

@interface PNetworkManage : BaseNetwork

+(PNetworkManage *)sharedManager;


/**
 *  獲取个人信息
 *
 *  @param partnerId   合伙人id
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)getUserInfoByPartnerId:(NSString *)partnerId
                      success:(networkSuccess)success
                      failure:(networkFailure)failure;

/**
 *  獲取公司信息
 *
 *  @param partnerId   合伙人id
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)getCompanyInfoByPartnerId:(NSString *)partnerId
                         success:(networkSuccess)success
                         failure:(networkFailure)failure;

/**
 *  修改公司信息
 *
 *  @param modelCompany   jsonObject
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */
-(void)editCompanyInfoByObject:(ModelCompany *)modelCompany
               success:(networkSuccess)success
               failure:(networkFailure)failure;


/**
 *  獲取收款记录总数据
 *
 *  @param partnerId   合伙人id
 *  @param beginDate   开始时间
 *  @param endDate   截止时间
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)getCashTotalByPartnerId:(NSString *)partnerId
                 beginDate:(NSString *)beginDate
                   endDate:(NSString *)endDate
                   success:(networkSuccess)success
                   failure:(networkFailure)failure;

/**
 *  獲取收款记录列表
 *
 *  @param partnerId   合伙人id
 *  @param beginDate   开始时间
 *  @param endDate   截止时间
 *  @param pageNo   页码
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)getCashRecordListByPartnerId:(NSString *)partnerId
                      beginDate:(NSString *)beginDate
                        endDate:(NSString *)endDate
                         pageNo:(NSString *)pageNo
                        success:(networkSuccess)success
                        failure:(networkFailure)failure;

/**
 *  獲取收款记录详情
 *
 *  @param orderId   订单id
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)getCashRecordDetailByRecordId:(NSString *)recordId
                             success:(networkSuccess)success
                             failure:(networkFailure)failure;

/**
 *  獲取员工列表
 *
 *  @param partnerId   合伙人id
 *  @param pageNo   页码
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)getStaffListByPartnerId:(NSString *)partnerId
                        pageNo:(NSString *)pageNo
                       success:(networkSuccess)success
                       failure:(networkFailure)failure;


/**
 *  修改员工信息
 *
 *  @param modelStaff   员工对象
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)editStaffObject:(ModelStaff *)modelStaff
                   success:(networkSuccess)success
                   failure:(networkFailure)failure;

/**
 *  新增员工信息
 *
 *  @param modelStaff   员工对象
 *  @param success 成功囘調
 *  @param failure 失敗回調
 */

-(void)addStaffObject:(ModelStaff *)modelStaff
               success:(networkSuccess)success
               failure:(networkFailure)failure;


@end
