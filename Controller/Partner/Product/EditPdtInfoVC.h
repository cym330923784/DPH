//
//  EditPdtInfoVC.h
//  DPH
//
//  Created by Cym on 16/3/8.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseViewCtrl.h"

@interface EditPdtInfoVC : BaseViewCtrl

@property (weak, nonatomic) IBOutlet UITextField *contentTF;

@property (nonatomic, strong)NSString * content;
@property (nonatomic, strong)NSString * type;

@end
