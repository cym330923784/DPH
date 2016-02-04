//
//  OrderListCell.m
//  DPH
//
//  Created by cym on 16/1/28.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "OrderListCell.h"

@implementation OrderListCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModelOrder:(ModelOrder *)modelOrder
{
    _modelOrder = modelOrder;
    self.codeLab.text = modelOrder.orderNo;
    

    if ([modelOrder.orderStatus isEqualToString:@"1"]||[modelOrder.orderStatus isEqualToString:@"2"]||[modelOrder.orderStatus isEqualToString:@"3"]||[modelOrder.orderStatus isEqualToString:@"4"]) {
        self.stateLab.text = @"订单处理中";
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
    self.orderTimeLab.text = modelOrder.cTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
