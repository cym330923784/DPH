//
//  AddressVC.h
//  DPH
//
//  Created by cym on 16/1/27.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "ModelAddress.h"


@interface AddressVC : BaseViewCtrl
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)ModelAddress * modelAddress;

@property (nonatomic,assign)BOOL  isSetDefault ;

@end
