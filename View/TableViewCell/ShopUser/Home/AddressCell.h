//
//  AddressCell.h
//  DPH
//
//  Created by cym on 16/1/27.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelAddress.h"

@interface AddressCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@property (nonatomic, strong)ModelAddress * modelAddress;

@end
