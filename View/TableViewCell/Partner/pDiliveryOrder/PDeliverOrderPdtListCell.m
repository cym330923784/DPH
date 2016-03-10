//
//  PDeliverOrderPdtListCell.m
//  DPH
//
//  Created by Cym on 16/3/9.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PDeliverOrderPdtListCell.h"
#import <UIImageView+WebCache.h>

@implementation PDeliverOrderPdtListCell

- (void)awakeFromNib {
    // Initialization code
}


-(void)setModelProduct:(ModelProduct *)modelProduct
{
    _modelProduct = modelProduct;
    
    self.codeLab.text = modelProduct.code;
    self.nameLab.text = modelProduct.name;
    self.sizeLab.text = modelProduct.specifications;
    self.priceLab.text = [NSString stringWithFormat:@"%0.2lf",[modelProduct.price floatValue]];
    self.numLab.text = modelProduct.qty;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_ImageUrl,modelProduct.primeImageUrl]] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
