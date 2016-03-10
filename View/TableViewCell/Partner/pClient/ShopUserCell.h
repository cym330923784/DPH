//
//  ShopUserCell.h
//  DPH
//
//  Created by cym on 16/2/1.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelShopListDemo.h"

@interface ShopUserCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLab;
//@property (weak, nonatomic) IBOutlet UILabel *shopStateLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;


@property (nonatomic,strong)ModelShopListDemo * modelShopListDemo;


@end
