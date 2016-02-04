//
//  OrderDetailVC.h
//  DPH
//
//  Created by cym on 16/1/28.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseViewCtrl.h"

@interface OrderDetailVC : BaseViewCtrl

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSString * orderId;
@end
