//
//  PDeliverOrderDetailCell.h
//  DPH
//
//  Created by Cym on 16/3/9.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDeliverOrderDetailCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *orderCodeLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *remarkLab;

@property (weak, nonatomic) IBOutlet UILabel *shouldPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLab;


@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIButton *callPhoneBtn;


@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIImageView *jiantouImg;





@end
