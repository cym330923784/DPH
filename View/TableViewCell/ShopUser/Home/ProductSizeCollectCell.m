//
//  ProductSizeCollectCell.m
//  DPH
//
//  Created by cym on 16/1/29.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "ProductSizeCollectCell.h"
#import "UIColor+TenSixColor.h"

@implementation ProductSizeCollectCell

- (void)awakeFromNib {
    // Initialization code
    
    self.label.layer.borderColor = [UIColor colorWithHexString:@"F0F0F0"].CGColor;
    self.label.layer.borderWidth = 1.0;

}

@end
