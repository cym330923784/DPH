//
//  CommonAddressCell.h
//  DPH
//
//  Created by Cym on 16/2/22.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelAddress.h"

@interface CommonAddressCell : UITableViewCell

@property (nonatomic, strong)ModelAddress * modelAddress;


@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@property (weak, nonatomic) IBOutlet UIButton *setDefaultBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;


@end
