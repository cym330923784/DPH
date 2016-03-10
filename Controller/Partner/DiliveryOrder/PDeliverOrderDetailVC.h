//
//  PDeliverOrderDetailVC.h
//  DPH
//
//  Created by Cym on 16/3/9.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseViewCtrl.h"

@interface PDeliverOrderDetailVC : BaseViewCtrl
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSString * orderId;

@end
