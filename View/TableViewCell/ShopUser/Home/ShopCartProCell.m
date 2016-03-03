//
//  ShopCartProCell.m
//  DPH
//
//  Created by cym on 16/1/26.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "ShopCartProCell.h"
#import <UIImageView+WebCache.h>

@implementation ShopCartProCell

- (void)awakeFromNib {
    // Initialization code
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)setModelProduct:(ModelProduct *)modelProduct
{
    _modelProduct = modelProduct;
    
    [self.proImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_ImageUrl,modelProduct.primeImageUrl]] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    self.codeLab.text = modelProduct.code;
    self.proNameLab.text = modelProduct.name;
//    self.sizeLab.text = modelProduct.specifications;
    self.proPriceLab.text = [NSString stringWithFormat:@"%0.2lf",[modelProduct.sellingPrice floatValue]];
    self.numTF.text = modelProduct.qty;
}

-(void)change
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBottomView" object:nil];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
