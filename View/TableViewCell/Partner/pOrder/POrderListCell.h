//
//  POrderListCell.h
//  DPH
//
//  Created by cym on 16/1/31.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelOrder.h"

@interface POrderListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UILabel *codeLab;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLab;
//@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLab;

@property (nonatomic, strong)ModelOrder * modelOrder;


@end
