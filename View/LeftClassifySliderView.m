//
//  LeftClassifySliderView.m
//  DPH
//
//  Created by Cym on 16/2/29.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "LeftClassifySliderView.h"
#import "ModelCategory.h"
#import "NetworkHome.h"
#import <MBProgressHUD.h>



@interface LeftClassifySliderView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView *backImageView;



@end

@implementation LeftClassifySliderView

//-(void)awakeFromNib
//{
//    
//    UIView  * nagc = [[NSBundle mainBundle] loadNibNamed:@"LeftClassifySliderView" owner:self options:nil][0];
//    [self addSubview:nagc];
//    [self getData];
//}
//
//-(id)init
//{
//    self = [super init];
//    if (self) {
//        [self getData];
//    }
//    return self;
//}
//
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        ModelCategory * model = self.myCategoryArr.firstObject;
        self.childCtyArr = model.data;
        NSLog(@"%@",model.data);
        
    }
    return self;
}



- (void)drawRect:(CGRect)rect {
    [self showDownloadsHUD:@"加载中..."];
    [[NetworkHome sharedManager]getCategoriesByUserId:[UserDefaultUtils valueWithKey:@"userId"]
                                              success:^(id result) {
                                                  [self dismissHUD];
                                                  self.myCategoryArr = [[NSMutableArray alloc]initWithCapacity:0];
                                                  
                                                  for (NSDictionary * categoryDic in result) {
                                                      ModelCategory * categoryDomo = [ModelCategory yy_modelWithDictionary:categoryDic];
                                                      [self.myCategoryArr addObject:categoryDomo];
                                                      [self.leftTableView reloadData];
                                                      [self.rightTableView reloadData];
                                                  }
                                              }
                                              failure:^(id result) {
                                                  [self dismissHUD];
                                                  [self showCommonHUD:result];
                                                  
                                              }];

    
}

 -(void)getData
{
    [self showDownloadsHUD:@"加载中..."];
    [[NetworkHome sharedManager]getCategoriesByUserId:[UserDefaultUtils valueWithKey:@"userId"]
                                              success:^(id result) {
                                                  [self dismissHUD];
                                                  self.myCategoryArr = [[NSMutableArray alloc]initWithCapacity:0];
                                                  
                                                  for (NSDictionary * categoryDic in result) {
                                                      ModelCategory * categoryDomo = [ModelCategory yy_modelWithDictionary:categoryDic];
                                                      [self.myCategoryArr addObject:categoryDomo];
                                                      [self.leftTableView reloadData];
                                                      [self.rightTableView reloadData];
                                                  }
                                              }
                                              failure:^(id result) {
                                                  [self dismissHUD];
                                                  [self showCommonHUD:result];
                                                  
                                              }];

}

- (IBAction)cancelAction:(id)sender {
    if (self.myBlock) {
        self.myBlock(nil);
    }
}

- (IBAction)sureAction:(id)sender {
    if (self.myBlock) {
        self.myBlock(@"刷新");
    }
}




- (void)returnText:(classifyBlock)block
{
    self.myBlock = block;
}

#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.leftTableView]) {
        return  self.myCategoryArr.count;
    }
    else
    {
        return self.childCtyArr.count;
    }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"celli";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if ([tableView isEqual:self.leftTableView]) {
        ModelCategory * model = self.myCategoryArr[indexPath.row];
        cell.textLabel.text = model.name;
    }
    else
    {
        ModelCategory * model = self.childCtyArr[indexPath.row];
        cell.textLabel.text = model.name;

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    if ([tableView isEqual:self.leftTableView]) {
        ModelCategory * thisModel = self.myCategoryArr[indexPath.row];
        self.childCtyArr = thisModel.data;
        [self.rightTableView reloadData];
    }
    else
    {
        ModelCategory * model = self.childCtyArr[indexPath.row];
        if (self.myBlock) {
            self.myBlock(model.name);
        }

    }
}


-(void)showCommonHUD:(NSString *)status{
    MBProgressHUD *hud            = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode                      = MBProgressHUDModeText;
    hud.labelText                 = status;
    hud.margin                    = 10.f;
    hud.yOffset                   = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

-(void)showDownloadsHUD:(NSString *)status{
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:hud];
    [self bringSubviewToFront:hud];
    hud.labelText = status;
    [hud show:YES];
}

-(void)dismissHUD{
    
    [MBProgressHUD hideHUDForView:self animated:YES];
}


@end
