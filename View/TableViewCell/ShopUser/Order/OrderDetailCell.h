//
//  OrderDetailCell.h
//  DPH
//
//  Created by cym on 16/1/28.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *remarkLab;

@property (weak, nonatomic) IBOutlet UILabel *orederPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *proPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *noPayPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *payStateLab;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@property (weak, nonatomic) IBOutlet UILabel *numLab;



@end
