//
//  PDiliveryPackageOrderCell.m
//  DPH
//
//  Created by Cym on 16/3/5.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PDiliveryPackageOrderCell.h"

@implementation PDiliveryPackageOrderCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModelOrder:(ModelOrder *)modelOrder
{
    _modelOrder = modelOrder;
    
    self.nameLab.text = modelOrder.deliveryName;
    self.areaLab.text = modelOrder.areaName;
    self.codelLab.text = modelOrder.orderNo;
    self.priceLab.text = [NSString stringWithFormat:@"%0.2lf",[modelOrder.totalCost floatValue]];
    self.dateLab.text = modelOrder.createTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
