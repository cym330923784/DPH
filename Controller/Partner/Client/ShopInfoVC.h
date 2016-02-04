//
//  ShopInfoVC.h
//  DPH
//
//  Created by cym on 16/2/1.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseViewCtrl.h"

@interface ShopInfoVC : BaseViewCtrl
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *shopImgView;

@property (weak, nonatomic) IBOutlet UILabel *shopNameLab;

@property(nonatomic,strong)NSString * endClientId;

@end
