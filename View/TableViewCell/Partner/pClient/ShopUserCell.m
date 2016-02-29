//
//  ShopUserCell.m
//  DPH
//
//  Created by cym on 16/2/1.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "ShopUserCell.h"
#import <UIImageView+WebCache.h>

@implementation ShopUserCell

- (void)awakeFromNib {
    // Initialization code
}


-(void)setModelShopListDemo:(ModelShopListDemo *)modelShopListDemo
{
    _modelShopListDemo = modelShopListDemo;
    
    self.shopNameLab.text = modelShopListDemo.name;
    //    self.shopStateLab.text = modelShop.levelName;
    self.nameLab.text = modelShopListDemo.contactName;
    self.phoneLab.text = modelShopListDemo.contactMobile;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_ImageUrl,modelShopListDemo.image]] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
