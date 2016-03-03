//
//  EditProductListCell.h
//  DPH
//
//  Created by Cym on 16/3/2.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelProduct.h"

@interface EditProductListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *proImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *attentionImgView;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *storageTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *storageNumLab;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

//可编辑时的View
@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UITextField *numTF;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *cutBtn;


//不可编辑时的view
@property (weak, nonatomic) IBOutlet UIView *noEditView;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

@property (nonatomic, strong)ModelProduct * modelProduct;

@property (nonatomic, strong)NSString * numStr;

@property (nonatomic, assign)BOOL isError;

@end
