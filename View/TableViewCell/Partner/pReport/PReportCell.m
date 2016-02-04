//
//  PReportCell.m
//  DPH
//
//  Created by cym on 16/2/2.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PReportCell.h"

@implementation PReportCell

- (void)awakeFromNib {
    // Initialization code
}




-(void)setModelReportDemo:(ModelReportDemo *)modelReportDemo
{
    _modelReportDemo = modelReportDemo;
    
    self.dateLab.text = modelReportDemo.beginDate;
    self.orderNumLab.text = [NSString stringWithFormat:@"%@笔",modelReportDemo.countNum];
    self.clientNumLab.text = [NSString stringWithFormat:@"%@位",modelReportDemo.endClientNum];
    self.priceLab.text =[NSString stringWithFormat:@"¥%.2lf",[modelReportDemo.totalCost floatValue]] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
