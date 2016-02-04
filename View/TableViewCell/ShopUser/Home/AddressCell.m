//
//  AddressCell.m
//  DPH
//
//  Created by cym on 16/1/27.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModelAddress:(ModelAddress *)modelAddress
{
    _modelAddress = modelAddress;
    self.nameLab.text = modelAddress.name;
    self.phoneLab.text = modelAddress.phone;
    self.addressLab.text = modelAddress.addressdetails;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
