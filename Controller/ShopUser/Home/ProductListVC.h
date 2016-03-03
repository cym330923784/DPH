//
//  ProductListVC.h
//  DPH
//
//  Created by cym on 16/1/28.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseViewCtrl.h"

@interface ProductListVC : BaseViewCtrl
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLab;



@property (nonatomic, assign)BOOL isTest;
@property (nonatomic, strong)NSArray * errorArr;


@end
