//
//  PCollectCashCell.m
//  DPH
//
//  Created by Cym on 16/2/25.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PCollectCashCell.h"

@implementation PCollectCashCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModelCashRecord:(ModelCashRecord *)modelCashRecord
{
    _modelCashRecord = modelCashRecord;
    
    self.dateLab.text = modelCashRecord.createTime;
    self.nameLab.text = modelCashRecord.fromAcctName;
    self.priceLab.text = modelCashRecord.paymentAmount;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
