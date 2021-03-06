//
//  DefaultAddressCell.m
//  DPH
//
//  Created by Cym on 16/2/22.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "DefaultAddressCell.h"

@implementation DefaultAddressCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModelAddress:(ModelAddress *)modelAddress
{
    _modelAddress = modelAddress;
    self.nameLab.text = modelAddress.name;
    self.phoneLab.text = modelAddress.phone;
    self.addressLab.text = modelAddress.addressDetails;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
