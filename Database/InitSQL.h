//
//  InitSQL.h
//  DPH
//
//  Created by cym on 16/1/30.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InitSQL : NSObject

//获取数据库地址
+ (NSString *)getDBPath;

//拷贝数据库到沙盒中
+ (BOOL)copyDB;


@end
