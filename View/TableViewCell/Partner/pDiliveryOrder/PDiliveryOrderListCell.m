//
//  PDiliveryOrderListCell.m
//  DPH
//
//  Created by Cym on 16/3/5.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PDiliveryOrderListCell.h"

@implementation PDiliveryOrderListCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModelOrder:(ModelOrder *)modelOrder
{
    _modelOrder = modelOrder;
    self.nameLab.text = modelOrder.deliveryName;
    self.codeLab.text = modelOrder.orderNo;
    self.priceLab.text = [NSString stringWithFormat:@"%0.2lf",[modelOrder.totalCost floatValue]];
    self.dateLab.text = modelOrder.createTime;
    self.areaLab.text = modelOrder.areaName;
    self.cashImage.hidden = ![modelOrder.cashReceipts boolValue];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
