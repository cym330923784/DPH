//
//  ReasonSelectView.h
//  DPH
//
//  Created by Cym on 16/3/5.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReasonSelectView : UIView


@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) void (^rightBlock)(NSString *);
@property (nonatomic, copy) dispatch_block_t dismissBlock;

- (id)initWithTitle:(NSString *)titleText
          reasonArr:(NSArray*)reasonArr
            typeNum:(NSInteger)typeNum
            orderId:(NSString *)orderId;
-(void)show;



@end
