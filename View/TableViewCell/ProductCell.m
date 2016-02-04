//
//  ProductCell.m
//  DPH
//
//  Created by cym on 16/1/26.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "ProductCell.h"
#import <UIImageView+WebCache.h>


@implementation ProductCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModelProduct:(ModelProduct *)modelProduct
{
    _modelProduct = modelProduct;
    
    self.proNameLab.text = modelProduct.name;
    self.proPriceLab.text = [NSString stringWithFormat:@"%0.2lf",[modelProduct.sellingPrice floatValue]];
    [self.proImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_ImageUrl,modelProduct.primeImageUrl]] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
