//
//  MsgListCell.m
//  DPH
//
//  Created by cym on 16/1/29.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "MsgListCell.h"
#import <UIImageView+WebCache.h>

@implementation MsgListCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModelMsg:(ModelMsg *)modelMsg
{
    _modelMsg = modelMsg;
    
    if ([modelMsg.readState isEqualToString:@"0"]) {
        self.headImgView.image = [UIImage imageNamed:@"msg_ico_noRead"];
    }
    else
    {
        self.headImgView.image = [UIImage imageNamed:@"msg_ico_read"];
    }
    self.titleLab.text = modelMsg.title;
    self.dateLab.text = modelMsg.date;
    self.contentLab.text = modelMsg.content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
