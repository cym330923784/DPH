//
//  categoryCell.h
//  DPH
//
//  Created by Cym on 16/3/1.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelCategory.h"

@interface categoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *categoryNameLab;

@property (nonatomic,strong)ModelCategory * modelCategory;

@property (nonatomic, assign) BOOL mSelected;


- (void)changeMSelectedState;

@end
