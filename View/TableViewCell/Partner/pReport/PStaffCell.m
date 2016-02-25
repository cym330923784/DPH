//
//  PStaffCell.m
//  DPH
//
//  Created by Cym on 16/2/25.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PStaffCell.h"
#import <UIImageView+WebCache.h>

@implementation PStaffCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModelStaff:(ModelStaff *)modelStaff
{
    _modelStaff = modelStaff;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_ImageUrl,modelStaff.image]] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    self.nameLab.text = modelStaff.name;
    self.positionLab.text = modelStaff.duties;
    self.phoneLab.text = modelStaff.contactMobile;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
