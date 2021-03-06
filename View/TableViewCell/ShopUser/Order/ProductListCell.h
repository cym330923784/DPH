//
//  ProductListCell.h
//  DPH
//
//  Created by cym on 16/1/31.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelProduct.h"

@interface ProductListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *codeLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *sizeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;


@property (nonatomic,strong)ModelProduct * modelProduct;


@end
