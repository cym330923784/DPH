//
//  ShopCartProCell.h
//  DPH
//
//  Created by cym on 16/1/26.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelProduct.h"

@interface ShopCartProCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *proImageView;

@property (weak, nonatomic) IBOutlet UILabel *codeLab;
@property (weak, nonatomic) IBOutlet UILabel *proNameLab;
@property (weak, nonatomic) IBOutlet UILabel *sizeLab;
@property (weak, nonatomic) IBOutlet UILabel *proPriceLab;
@property (weak, nonatomic) IBOutlet UITextField *numTF;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (nonatomic , strong)ModelProduct * modelProduct;

@end
