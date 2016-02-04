//
//  PdtInfoVC.h
//  DPH
//
//  Created by cym on 16/1/26.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseViewCtrl.h"

@interface PdtInfoVC : BaseViewCtrl
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSString * productId;

@end
