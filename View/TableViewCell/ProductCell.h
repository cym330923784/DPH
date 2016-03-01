//
//  ProductCell.h
//  DPH
//
//  Created by cym on 16/1/26.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelProduct.h"


@interface ProductCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *proImageView;

@property (weak, nonatomic) IBOutlet UILabel *proNameLab;
@property (weak, nonatomic) IBOutlet UILabel *proPriceLab;
@property (weak, nonatomic) IBOutlet UIButton *addShopcartBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

//@property (weak, nonatomic) IBOutlet UIButton *addShopCartBtn;

@property (nonatomic, strong)ModelProduct * modelProduct;
@end
