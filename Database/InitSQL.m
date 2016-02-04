//
//  InitSQL.m
//  DPH
//
//  Created by cym on 16/1/30.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "InitSQL.h"

@implementation InitSQL


+ (NSString *)getDBPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDir = paths.firstObject;
    
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:@"DPH.sqlite"];
    
    NSLog(@"%@", dbPath);
    
    return dbPath;
}

+ (BOOL)copyDB
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    
    if([fileManager fileExistsAtPath:[self getDBPath]] == NO){
        
        NSString *defaultDBPath = [[NSBundle mainBundle] pathForResource:@"DPH" ofType: @"sqlite"];
        
        if(defaultDBPath)
        {
            BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:[self getDBPath] error:&error];
            
            if(!success){
                
                NSLog(@"Failed to create writable database file with message '%@'.", [error localizedDescription]);
                
                return NO;
            }
        }
    }
    return YES;
}

@end
