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
//    NSString * priceStr = [NSString stringWithFormat:@"%0.2lf",[modelProduct.sellingPrice floatValue]];
    
    self.proPriceLab.text = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:[modelProduct.sellingPrice floatValue]]  numberStyle:NSNumberFormatterDecimalStyle];
    [self.proImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_ImageUrl,modelProduct.primeImageUrl]] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    
//    if ([modelProduct.favorite isEqualToString:@"0"]) {
//        self.collectBtn.selected = NO;
//    }
//    else
//    {
//        self.collectBtn.selected = YES;
//    }
    self.collectBtn.selected = [modelProduct.favorite boolValue];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
