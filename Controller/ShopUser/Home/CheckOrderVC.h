//
//  CheckOrderVC.h
//  DPH
//
//  Created by cym on 16/1/27.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseViewCtrl.h"

@interface CheckOrderVC : BaseViewCtrl
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet UILabel *numLab;

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLab;

@property (nonatomic, strong)NSString * orderPrice;
@property (nonatomic, strong)NSString * num;
@property (nonatomic, strong)NSString * totalPrice;

@property (nonatomic, strong)NSMutableArray * productArr;

@end
