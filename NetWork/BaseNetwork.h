//
//  BaseNetwork.h
//  DPH
//
//  Created by cym on 16/1/25.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  網絡操作成功block處理
 *
 *  @param result 結果，具體業務層會說明
 */
typedef void (^networkSuccess)(id result);
/**
 *  網絡操作失敗block處理
 *
 *  @param result 原因
 */
typedef void (^networkFailure)(id result);


@interface BaseNetwork : NSObject


/**
 *  Get請求
 *
 *  @param parms   參數
 *  @param success 成功囘調
 *  @param failure 失敗囘調
 */
- (void)sendRequestToServiceByGet:(NSDictionary *)parms
                         serveUrl:(NSString *)url
                          success:(networkSuccess)success
                          failure:(networkFailure)failure;
/**
 *  Post請求
 *
 *  @param parms   參數
 *  @param success 成功囘調
 *  @param failure 失敗囘調
 */
- (void)sendRequestToServiceByPost:(NSDictionary *)parms
                          serveUrl:(NSString *)url
                           success:(networkSuccess)success
                           failure:(networkFailure)failure;

/**
 *  post上传图片
 *
 *  @param parms    参数
 *  @param url      空间
 *  @param filePath 图片url
 *  @param success  成功回调
 *  @param failure  失败回调
 */
-(void)sendRequestToServiceByPostImage:(NSDictionary *)parms
                              serveUrl:(NSString *)url
                                 image:(NSURL *)filePath
                               success:(networkSuccess)success
                               failure:(networkFailure)failure;

-(void)sendRequestToServiceByPostImage:(NSDictionary *)parms
                              serveUrl:(NSString *)url
                                images:(NSMutableArray *)imgs
                               success:(networkSuccess)success
                               failure:(networkFailure)failure;

//判断是否是最新版本
//-(void)sendRequestCheckVersionByPost:(NSDictionary *)parms
//                            serveUrl:(NSString *)url
//                             success:(networkSuccess)success
//                             failure:(networkFailure)failure;


/**
 *  取消當前請求
 */
-(void)requestCancle;

/**
 *  七牛上传图片
 *
 *  @param parms    参数
 *  @param url      空间
 *  @param filePath 图片url
 *  @param success  成功回调
 *  @param failure  失败回调
 */

//-(void)sendRequestToQiNiuByPostImage:(UIImage *)image
//                               success:(networkSuccess)success
//                               failure:(networkFailure)failure;


@end

