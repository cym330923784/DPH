//
//  ProductInfoCell.h
//  DPH
//
//  Created by cym on 16/1/26.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductInfoCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *proBigImageView;

@property (weak, nonatomic) IBOutlet UILabel *proNumLab;
@property (weak, nonatomic) IBOutlet UILabel *proNameLab;
@property (weak, nonatomic) IBOutlet UILabel *marketPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *dphPriceLab;


@property (weak, nonatomic) IBOutlet UICollectionView *collectView;
@property (weak, nonatomic) IBOutlet UIButton *cutBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITextField *numTF;

@property (nonatomic, strong)NSString * numStr;

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate;


@end
