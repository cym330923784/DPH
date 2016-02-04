//
//  MyInfoVC.h
//  DPH
//
//  Created by cym on 16/1/29.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "ModelUser.h"

@interface MyInfoVC : BaseViewCtrl

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;

@property(nonatomic, strong)ModelUser * modelUser;

@end
