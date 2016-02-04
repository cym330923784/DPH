//
//  OrderProductListVC.h
//  DPH
//
//  Created by cym on 16/1/31.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseViewCtrl.h"

@interface OrderProductListVC : BaseViewCtrl

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLab;


@property (nonatomic,strong)NSString * orderId;
@property (nonatomic, strong)NSString * numStr;
@property (nonatomic, strong)NSString * totalPriceStr;


@end
