//
//  PProductInfoCell.m
//  DPH
//
//  Created by cym on 16/1/29.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PProductInfoCell.h"

@implementation PProductInfoCell

- (void)awakeFromNib {
    // Initialization code
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.itemSize = CGSizeMake((Screen.width-100)/2, 25);
    
    self.collectView.collectionViewLayout = layout;
    self.collectView.backgroundColor = [UIColor whiteColor];
    
    [self.collectView registerNib:[UINib nibWithNibName:@"ProductSizeCollectCell" bundle:nil] forCellWithReuseIdentifier:@"sizeLabelCell"];

}

- (IBAction)changeShelfAction:(id)sender {
    UIButton * thisBtn = (UIButton *)sender;
    
    self.onShelfBtn.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
    [self.onShelfBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.onShelfBtn.selected = NO;
    self.outShelfBtn.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
    [self.outShelfBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.outShelfBtn.selected = NO;
    
    thisBtn.backgroundColor = [UIColor colorWithHexString:@"3CA0E6"];
    [thisBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

}

//- (IBAction)changeShelfAction:(id)sender {
//    
//    UIButton * thisBtn = (UIButton *)sender;
//    
//    self.onShelfBtn.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
//    [self.onShelfBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    self.onShelfBtn.selected = NO;
//    self.outShelfBtn.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
//    [self.outShelfBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    self.outShelfBtn.selected = NO;
//    
//    thisBtn.backgroundColor = [UIColor colorWithHexString:@"3CA0E6"];
//    [thisBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    
//}


- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate {
    self.collectView.dataSource = dataSourceDelegate;
    self.collectView.delegate = dataSourceDelegate;
    [self.collectView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
