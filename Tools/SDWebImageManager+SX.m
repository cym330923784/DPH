//
//  SDWebImageManager+SX.m
//  CG
//
//  Created by Rabbit on 2015/4/26.
//  Copyright (c) 2015年 shixiao. All rights reserved.
//

#import "SDWebImageManager+SX.h"


@implementation SDWebImageManager (SX)

+ (void)downloadWithURL:(NSURL *)url
{
    // cmp不能为空    
    [[self sharedManager] downloadImageWithURL:url options:SDWebImageLowPriority|SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL){
        
    }];


}

@end
