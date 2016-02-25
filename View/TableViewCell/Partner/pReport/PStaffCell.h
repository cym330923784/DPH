//
//  PStaffCell.h
//  DPH
//
//  Created by Cym on 16/2/25.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelStaff.h"

@interface PStaffCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *positionLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;

@property (nonatomic,strong)ModelStaff * modelStaff;


@end
