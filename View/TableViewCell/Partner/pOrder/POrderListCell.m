//
//  POrderListCell.m
//  DPH
//
//  Created by cym on 16/1/31.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "POrderListCell.h"

@implementation POrderListCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setModelOrder:(ModelOrder *)modelOrder
{
    _modelOrder = modelOrder;
    self.codeLab.text = modelOrder.orderNo;
    
    
    if ([modelOrder.orderStatus isEqualToString:@"1"]) {
        self.stateLab.text = @"订单审核中";
    }
    else if ([modelOrder.orderStatus isEqualToString:@"2"])
    {
        self.stateLab.text = @"财务审核中";
    }
    else if ([modelOrder.orderStatus isEqualToString:@"3"])
    {
        self.stateLab.text = @"出库审核中";
    }
    else if ([modelOrder.orderStatus isEqualToString:@"4"])
    {
        self.stateLab.text = @"发单审核中";
    }
    else if ([modelOrder.orderStatus isEqualToString:@"5"])
    {
        self.stateLab.text = @"已发货";
    }
    else if ([modelOrder.orderStatus isEqualToString:@"6"])
    {
        self.stateLab.text = @"已签收";
    }
    else if ([modelOrder.orderStatus isEqualToString:@"7"])
    {
        self.stateLab.text = @"已完成";
    }
    else
    {
        self.stateLab.text = @"已作废";
    }
    
    
    self.orderPriceLab.text = modelOrder.totalCost;
    self.numLab.text = modelOrder.num;
    self.orderTimeLab.text = modelOrder.createTime;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
