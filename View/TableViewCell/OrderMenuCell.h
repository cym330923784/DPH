//
//  OrderMenuCell.h
//  DPH
//
//  Created by cym on 16/1/27.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderMenuCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *orderPriceLab;




@property (weak, nonatomic) IBOutlet UILabel *menuNameLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIImageView *arrowsImg;
@property (weak, nonatomic) IBOutlet UIImageView *attentionImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIButton *setDefaultBtn;


@property (weak, nonatomic) IBOutlet UILabel *remarkLab;




@end
