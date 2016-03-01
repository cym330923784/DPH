//
//  QuicklyBuyView.h
//  DPH
//
//  Created by Cym on 16/3/1.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelProduct.h"

@interface QuicklyBuyView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UITextField *numTF;
@property (weak, nonatomic) IBOutlet UIButton *cutBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic, strong)NSString * numStr;

@property (nonatomic, retain)ModelProduct * modelProduct;
@property (nonatomic, strong)UIImage * image;


-(id)initWithModelProduct:(ModelProduct *)modelProduct;
-(void)show;

@end
