//
//  PPdtInfoVC.h
//  DPH
//
//  Created by cym on 16/1/29.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseViewCtrl.h"


@interface PPdtInfoVC : BaseViewCtrl
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSString * productId;

@end
