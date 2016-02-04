//
//  ProductListCell.m
//  DPH
//
//  Created by cym on 16/1/31.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "ProductListCell.h"
#import <UIImageView+WebCache.h>

@implementation ProductListCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModelProduct:(ModelProduct *)modelProduct
{
    _modelProduct = modelProduct;
    
    self.codeLab.text = modelProduct.code;
    self.nameLab.text = modelProduct.name;
    self.sizeLab.text = modelProduct.specifications;
    self.priceLab.text = modelProduct.price;
    self.numLab.text = modelProduct.qty;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_ImageUrl,modelProduct.primeImageUrl]] placeholderImage:[UIImage imageNamed:@"default_pic"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
