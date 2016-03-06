//
//  POrderDetailCell.h
//  DPH
//
//  Created by cym on 16/1/31.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POrderDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *remarkLab;

@property (weak, nonatomic) IBOutlet UILabel *orderPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *proPriceLab;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIButton *callPhoneBtn;


@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIImageView *jiantouImg;


@property (weak, nonatomic) IBOutlet UILabel *payTitleLab;
@property (weak, nonatomic) IBOutlet UIImageView *payJTImg;
@property (weak, nonatomic) IBOutlet UIView *payInfoView;
@property (weak, nonatomic) IBOutlet UILabel *payNameLab;
@property (weak, nonatomic) IBOutlet UILabel *payPhoneLab;
@property (weak, nonatomic) IBOutlet UILabel *payMethodLab;




@end
