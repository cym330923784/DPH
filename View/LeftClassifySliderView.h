//
//  LeftClassifySliderView.h
//  DPH
//
//  Created by Cym on 16/2/29.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^classifyBlock)(NSString *level,NSString *ids);

@interface LeftClassifySliderView : UIView

@property (nonatomic, strong)classifyBlock myBlock;

@property (nonatomic, strong)NSMutableArray * myCategoryArr;
@property (nonatomic, strong)NSMutableArray * childCtyArr;

@property (weak, nonatomic) IBOutlet UITableView *leftTableView;

@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

- (void)returnText:(classifyBlock)block;

@end
