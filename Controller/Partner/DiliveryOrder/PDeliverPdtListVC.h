//
//  PDeliverPdtListVC.h
//  DPH
//
//  Created by Cym on 16/3/9.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseViewCtrl.h"

@interface PDeliverPdtListVC : BaseViewCtrl

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *codeLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;


@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLab;

@property (nonatomic, strong)NSString * code;
@property (nonatomic, strong)NSString * name;
@property (nonatomic,strong)NSString * orderId;
@property (nonatomic, strong)NSString * numStr;
@property (nonatomic, strong)NSString * totalPriceStr;
@end
