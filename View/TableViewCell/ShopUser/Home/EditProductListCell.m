//
//  EditProductListCell.m
//  DPH
//
//  Created by Cym on 16/3/2.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "EditProductListCell.h"
#import <UIImageView+WebCache.h>

@implementation EditProductListCell

- (void)awakeFromNib {
    // Initialization code
}
//
//- (IBAction)addAction:(id)sender {
//    
//    int i = [self.numTF.text intValue];
//    i = i+1;
//    self.numTF.text = [NSString stringWithFormat:@"%d",i];
//    self.numStr = self.numTF.text;
//    self.cutBtn.enabled = YES;
//
//}
//- (IBAction)cutAction:(id)sender {
//    
//    int i = [self.numTF.text intValue];
//    if (i == 1||[self.numTF.text isEqualToString:@""]) {
//        return;
//    }
//    i = i-1;
//    self.numTF.text = [NSString stringWithFormat:@"%d",i];
//    self.numStr = self.numTF.text;
//    if (i == 1) {
//        self.cutBtn.enabled = NO;
//    }
//
//}

-(void)setModelProduct:(ModelProduct *)modelProduct
{
    _modelProduct = modelProduct;
    
    
    self.nameLab.text = modelProduct.name;
    self.priceLab.text = [NSString stringWithFormat:@"%0.2lf",[modelProduct.sellingPrice floatValue]];
    self.numLab.text = modelProduct.qty;
    self.numTF.text = modelProduct.qty;
    [self.proImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_ImageUrl,modelProduct.primeImageUrl]] placeholderImage:[UIImage imageNamed:@"default_pic"]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
