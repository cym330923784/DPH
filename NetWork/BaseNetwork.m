//
//  BaseNetwork.m
//  DPH
//
//  Created by cym on 16/1/25.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseNetwork.h"
#import "NetworkStatus.h"
#import <AFNetworking.h>
#import <QiniuSDK.h>
#import "AppUtils.h"



/**
 *  服務器接口
 */



NSString *const SERVE_URL = BASE_NET;

//检测版本地址
//NSString *const APP_URL = @"http://itunes.apple.com/lookup?id=997670594";


@interface BaseNetwork ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, strong) NSURLSessionDataTask *requestOperation;

@end

@implementation BaseNetwork
-(BOOL)configureRequest{
    NSLog(@"設置請求配置開始");
    if(![[NetworkStatus sharedInstance] haveNetwork]){
        NSLog(@"沒有網絡");
        return NO;
    }
    
    if (self.requestOperation) {
        
        [self.requestOperation cancel];
    }
    
    //    self.manager = [AFHTTPRequestOperationManager manager];
    //
    //    //    self.manager.responseSerializer.acceptableContentTypes = [self.manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/xml"];
    //
    //    self.manager.requestSerializer.timeoutInterval = 25;
    
    NSLog(@"設置請求配置結束");
    return YES;
}


-(AFHTTPSessionManager *)baseHtppRequest{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:25];
    //header 设置
    //        [manager.requestSerializer setValue:K_PASS_IP forHTTPHeaderField:@"Host"];
    //        [manager.requestSerializer setValue:@"max-age=0" forHTTPHeaderField:@"Cache-Control"];
    //        [manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    //        [manager.requestSerializer setValue:@"zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
    //        [manager.requestSerializer setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    //        [manager.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    //        [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:35.0) Gecko/20100101 Firefox/35.0" forHTTPHeaderField:@"User-Agent"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    return manager;
}


-(void)sendRequestToServiceByGet:(NSDictionary *)parms
                        serveUrl:(NSString *)url
                         success:(networkSuccess)success
                         failure:(networkFailure)failure{
    
    NSLog(@"請求開始，Get方式");
    
    BOOL n = [self configureRequest];
    
    if (!n) {
        failure(@"網絡請求失敗");
    }
    
    NSString *surl = [NSString stringWithFormat:@"%@%@",SERVE_URL,url];
    NSLog(@"請求地址為%@",surl);
    NSLog(@"請求參數為>>>>%@",parms);
    
    
//    NSString * jsonStr = [AppUtils dictionaryToJson:parms];
//    NSString* encrypt = [AppUtils encryptUseDES:jsonStr];
//    NSDictionary * dic = @{@"data":encrypt};
    AFHTTPSessionManager * manager= [self baseHtppRequest];
    [manager GET:surl
      parameters:parms
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             
             NSLog(@"請求成功，結果為%@",[AppUtils dictionaryToJson:responseObject]);
             
             success(responseObject);
             
         } failure:^(NSURLSessionTask *task, NSError *error) {
             
             NSLog(@"請求失敗，原因是%@",error.localizedDescription);
             
             failure(error.localizedDescription);
         }];
    
    NSLog(@"請求結束，Get方式");

    
}

-(void)sendRequestToServiceByPost:(NSDictionary *)parms
                         serveUrl:(NSString *)url
                          success:(networkSuccess)success
                          failure:(networkFailure)failure{
    
    NSLog(@"請求開始，Post方式");
    
    //    BOOL n = [self configureRequest];
    //
    //    if (!n) {
    //        if (failure) {
    //            failure(@"網絡請求失敗");
    //        }
    //        return;
    //    }
    
    NSString *surl = [NSString stringWithFormat:@"%@%@",SERVE_URL,url];
    
    
//    NSString * jsonStr = [AppUtils dictionaryToJson:parms];
//    NSString* encrypt = [AppUtils encryptUseDES:jsonStr];
//    NSDictionary * dic = @{@"data":encrypt};
//    
    NSLog(@"請求地址為>>>>%@",surl);
    NSLog(@"請求參數為>>>>%@" ,parms);

    AFHTTPSessionManager * manager= [self baseHtppRequest];
    [manager POST:surl
       parameters:parms
         progress:nil
          success:^(NSURLSessionTask *task, id responseObject){
              NSLog(@"請求成功，結果為%@",[AppUtils dictionaryToJson:responseObject]);
              //                                           NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
              //                                           NSLog(@"请求成功，结果为=========%@",responseObject);
              success(responseObject);
              
          }failure:^(NSURLSessionTask *task, NSError *error){
              
              NSLog(@"請求失敗，原因為%@",error.localizedDescription);
              
              failure(error.localizedDescription);
              
          }];
    NSLog(@"請求結束，Post方式");
}

-(void)sendRequestToServiceByPostImage:(NSDictionary *)parms serveUrl:(NSString *)url image:(NSURL *)filePath success:(networkSuccess)success failure:(networkFailure)failure
{
    NSLog(@"請求開始，image方式");
    
    BOOL n = [self configureRequest];
    
    if (!n) {
        if (failure) {
            failure(@"網絡請求失敗");
        }
        
        return;
    }
    NSString *surl = [NSString stringWithFormat:@"%@%@",SERVE_URL,url];
    
//    NSString * jsonStr = [AppUtils dictionaryToJson:parms];
//    NSString* encrypt = [AppUtils encryptUseDES:jsonStr];
//    NSDictionary * dic = @{@"data":encrypt};
    
    self.requestOperation = [self.manager POST:surl
                                    parameters:parms
                     constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                        [formData appendPartWithFileURL:filePath name:@"image" error:nil];
                                    }
                                      progress:nil
                                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                           NSLog(@"Success: %@", [AppUtils dictionaryToJson:responseObject]);
                                       }
                                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                           NSLog(@"Error: %@", error);
                                       }];
    NSLog(@"請求結束，image方式");
}

-(void)sendRequestToServiceByPostImage:(NSDictionary *)parms
                              serveUrl:(NSString *)url
                                images:(NSMutableArray *)imgs
                               success:(networkSuccess)success
                               failure:(networkFailure)failure
{
    NSLog(@"請求開始，image方式");
    
    BOOL n = [self configureRequest];
    
    if (!n) {
        if (failure) {
            failure(@"網絡請求失敗");
        }
        
        return;
    }
    NSString *surl = [NSString stringWithFormat:@"%@%@",SERVE_URL,url];
    
    NSLog(@"%@  %@",imgs,surl);
    //    AFHTTPRequestOperationManager * manager= [self baseHtppRequest];
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:surl
       parameters:parms
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    for (int i = 0; i<imgs.count; i++) {
        NSData *imageData = UIImageJPEGRepresentation(imgs[i],0.5);
        [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"file%d.jpg",i] fileName:[NSString stringWithFormat:@"abc%d.jpg",i] mimeType:@"image/jpeg"];
    }
}
     progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
              NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
              NSLog(@"請求成功，結果為: %@", [AppUtils StringToJson:result]);
              success([AppUtils StringToJson:result]);
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              
              NSLog(@"請求失敗，原因為: %@", error);
              failure(error);
              
              
          }];
    NSLog(@"請求結束，image方式");
    
}

/*
 
 检测是否是最新版本
 
 */

/*
 
 -(void)sendRequestCheckVersionByPost:(NSDictionary *)parms
 serveUrl:(NSString *)url
 success:(networkSuccess)success
 failure:(networkFailure)failure{
 
 NSLog(@"請求開始，Post方式");
 
 BOOL n = [self configureRequest];
 
 if (!n) {
 if (failure) {
 failure(@"網絡請求失敗");
 }
 
 return;
 }
 
 NSLog(@"請求地址為>>>>%@",APP_URL);
 NSLog(@"請求參數為>>>>%@",parms);
 
 NSString * jsonStr = [AppUtills dictionaryToJson:parms];
 
 AFJSONRequestSerializer * serializer = [AFJSONRequestSerializer serializer];
 [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
 [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
 self.manager.requestSerializer = serializer;
 
 self.requestOperation = [self.manager POST:APP_URL
 parameters:jsonStr
 success:^(AFHTTPRequestOperation *operation, id responseObject){
 
 NSLog(@"請求成功，結果為%@",responseObject);
 success(responseObject);
 
 
 }failure:^(AFHTTPRequestOperation *operation, NSError *error){
 
 NSLog(@"請求失敗，原因為%@",error.localizedDescription);
 
 failure(error.localizedDescription);
 
 }];
 NSLog(@"請求結束，Post方式");
 }
 
 */

-(void)requestCancle{
    NSLog(@"取消請求開始");
    if (self.requestOperation) {
        [self.requestOperation cancel];
    }
    NSLog(@"取消請求結束");
}

//-(void)sendRequestToQiNiuByPostImage:(UIImage *)image
//                             success:(networkSuccess)success
//                             failure:(networkFailure)failure
//{
//    QNUploadManager * manager = [[QNUploadManager alloc]init];
//    NSData *imageData = UIImagePNGRepresentation(image);// png
//    [manager putData:imageData key:nil token:@"" complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//        NSLog(@"info = %@",info);
//        NSLog(@"resp = %@",resp);
//    } option:nil];
//}


@end

