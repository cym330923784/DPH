//
//  categoryCell.m
//  DPH
//
//  Created by Cym on 16/3/1.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "categoryCell.h"

@implementation categoryCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModelCategory:(ModelCategory *)modelCategory
{
    _modelCategory = modelCategory;
    self.categoryNameLab.text = modelCategory.name;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    if (_mSelected)
    {
        if (((UITableView *)self.superview).isEditing)
        {
            self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
        }
        else
        {
            self.backgroundView.backgroundColor = [UIColor clearColor];
        }
        
        self.categoryNameLab.textColor = [UIColor whiteColor];

        self.backgroundColor = [UIColor colorWithHexString:@"3CA0E6"];
    }
    else
    {
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.categoryNameLab.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    [UIView commitAnimations];
}

- (void)changeMSelectedState
{
    _mSelected = !_mSelected;
    [self setNeedsLayout];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state

}

@end
