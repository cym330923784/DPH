//
//  PProductInfoCell.h
//  DPH
//
//  Created by cym on 16/1/29.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PProductInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *proBigImgView;
@property (weak, nonatomic) IBOutlet UILabel *codeLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *marketPriceLab;

@property (weak, nonatomic) IBOutlet UIButton *sellingPriceBtn;
@property (weak, nonatomic) IBOutlet UILabel *sellingPriceLab;
@property (weak, nonatomic) IBOutlet UIButton *qtyBtn;
@property (weak, nonatomic) IBOutlet UILabel *qtyLab;


//@property (weak, nonatomic) IBOutlet UITextField *sellingPriceTF;
//@property (weak, nonatomic) IBOutlet UITextField *qtyTF;
@property (weak, nonatomic) IBOutlet UIButton *onShelfBtn;
@property (weak, nonatomic) IBOutlet UIButton *outShelfBtn;

@property (weak, nonatomic) IBOutlet UICollectionView *collectView;


- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate;

@end
