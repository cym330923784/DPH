//
//  ProductInfoCell.m
//  DPH
//
//  Created by cym on 16/1/26.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "ProductInfoCell.h"

@implementation ProductInfoCell

- (void)awakeFromNib {
    // Initialization code
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change) name:UITextFieldTextDidChangeNotification object:nil];
    
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    
//    layout.minimumLineSpacing = 5;
//    layout.minimumInteritemSpacing = 5;
//    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
//    layout.itemSize = CGSizeMake((Screen.width-100)/2, 25);
//    
//    self.collectView.collectionViewLayout = layout;
//    self.collectView.backgroundColor = [UIColor whiteColor];
//    
//    [self.collectView registerNib:[UINib nibWithNibName:@"ProductSizeCollectCell" bundle:nil] forCellWithReuseIdentifier:@"sizeLabelCell"];

    
    
}

//- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate {
//    self.collectView.dataSource = dataSourceDelegate;
//    self.collectView.delegate = dataSourceDelegate;
//    [self.collectView reloadData];
//}

-(void)change
{
    if ([self.numTF.text isEqualToString:@""]||[self.numTF.text isEqualToString:@"0"])
    {
        self.cutBtn.enabled = NO;
    }
    
    else
    {
        self.cutBtn.enabled = YES;
    }
//    self.totalPriceLab.text =[NSString stringWithFormat:@"%0.2lf",[self.uPriceLab.text floatValue]*[self.numTF.text floatValue]] ;
    self.numStr = self.numTF.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBottomView" object:nil];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)cutAction:(id)sender {
    int i = [self.numTF.text intValue];
    if (i == 1||[self.numTF.text isEqualToString:@""]) {
        return;
    }
    i = i-1;
    self.numTF.text = [NSString stringWithFormat:@"%d",i];
    self.numStr = self.numTF.text;
    if (i == 1) {
        self.cutBtn.enabled = NO;
    }

}
- (IBAction)addAction:(id)sender {
    int i = [self.numTF.text intValue];
    i = i+1;
    self.numTF.text = [NSString stringWithFormat:@"%d",i];
    self.numStr = self.numTF.text;
    self.cutBtn.enabled = YES;
}

@end
