//
//  PReportCell.h
//  DPH
//
//  Created by cym on 16/2/2.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelReportDemo.h"

@interface PReportCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (weak, nonatomic) IBOutlet UILabel *clientNumLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (nonatomic,strong)ModelReportDemo *  modelReportDemo;

@end
