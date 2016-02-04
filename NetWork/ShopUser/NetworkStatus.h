//
//  NetworkStatus.h
//  DPH
//
//  Created by cym on 16/1/25.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    NetworkUnknow = 0,
    NetworkOff = 1,
    NetworkPhone = 2,
    NetworkWifi = 3,
}NetworkType;

@interface NetworkStatus : NSObject

+(instancetype)sharedInstance;
/**
 *  是否有網絡
 *
 *  @return 1有0沒有
 */
-(BOOL)haveNetwork;

/**
 *  是否有網絡判斷
 */
@property (nonatomic) BOOL isHaveNetwork;
/**
 *  網絡類型判斷
 */
@property (nonatomic) NSInteger netType;


@end

