//
//  PCollectCashCell.h
//  DPH
//
//  Created by Cym on 16/2/25.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelCashRecord.h"

@interface PCollectCashCell : UITableViewCell

@property (nonatomic, strong)ModelCashRecord * modelCashRecord;

@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;


@end
