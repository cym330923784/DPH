//
//  PDiliveryPackageOrderCell.h
//  DPH
//
//  Created by Cym on 16/3/5.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelOrder.h"

@interface PDiliveryPackageOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *codelLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;

@property (weak, nonatomic) IBOutlet UIButton *backOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *removeOrderBtn;

@property (nonatomic, strong)ModelOrder * modelOrder;



@end
