//
//  PDeliverOrderPdtListCell.h
//  DPH
//
//  Created by Cym on 16/3/9.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelProduct.h"

@interface PDeliverOrderPdtListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *codeLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *sizeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;


@property (weak, nonatomic) IBOutlet UILabel *returnsTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *returnsNumLab;
@property (weak, nonatomic) IBOutlet UILabel *returnsUnitLab;

@property (weak, nonatomic) IBOutlet UIButton *returnBtn;


@property (nonatomic,strong)ModelProduct * modelProduct;

@end
