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
#import "categoryCell.h"



@interface LeftClassifySliderView ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *leftAllBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightAllBtn;

@property (nonatomic, strong)NSString * idsStr;
@property (nonatomic, strong)NSString * fatherId;
@property (nonatomic,strong)NSString * level;

@property (nonatomic, strong)NSMutableArray * selectArr;
@property (nonatomic, strong)NSMutableArray * idsArr;



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
-(id)init
{
    self = [super init];
    if (self) {
        UIView  * nagc = [[NSBundle mainBundle] loadNibNamed:@"LeftClassifySliderView" owner:self options:nil][0];
        [self addSubview:nagc];
        [self getData];

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView  * nagc = [[NSBundle mainBundle] loadNibNamed:@"LeftClassifySliderView" owner:self options:nil][0];
        [self addSubview:nagc];
        [self getData];

        
    }
    return self;
}



- (void)drawRect:(CGRect)rect {
    
    self.selectArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.idsArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.idsStr = [NSString string];
    self.level = [NSString string];
    self.fatherId = [NSString string];
    
    [self.leftAllBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.leftAllBtn setBackgroundColor:[UIColor colorWithHexString:@"3CA0E6"]];
    
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

- (IBAction)leftAllBtnAction:(id)sender {
    [self.leftAllBtn setBackgroundColor:[UIColor colorWithHexString:@"3CA0E6"]];
    [self.leftAllBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.rightAllBtn.hidden = YES;
    NSIndexPath* indexPath = [self.leftTableView indexPathForSelectedRow];
    [self.leftTableView deselectRowAtIndexPath:indexPath animated:YES];


    self.childCtyArr = nil;
    [self.rightTableView reloadData];
    
    
}

- (IBAction)rightAllBtnAction:(id)sender {
    [self.rightAllBtn setBackgroundColor:[UIColor colorWithHexString:@"3CA0E6"]];
    [self.rightAllBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    for (categoryCell * cell in self.selectArr) {
        [cell changeMSelectedState];
    }
    [self.selectArr removeAllObjects];
    [self.idsArr removeAllObjects];
    
}


- (IBAction)cancelAction:(id)sender {
    [self.selectArr removeAllObjects];
    if (self.myBlock) {
        self.myBlock(nil,nil);
    }
}

- (IBAction)sureAction:(id)sender {

    if (self.selectArr.count == 0) {
        if (self.myBlock) {
            self.myBlock(@"0",self.fatherId);
        }
    }
    else
    {
        if (self.myBlock) {
            self.myBlock(@"1",[AppUtils putArrToString:self.idsArr]);
        }
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

    static NSString * cellIndentifier = @"categoryCell";
    categoryCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        NSArray * nibArr = [[NSBundle mainBundle]loadNibNamed:@"categoryCell" owner:self options:nil];
        cell = nibArr[0];
        
    }
    if ([tableView isEqual:self.leftTableView]) {
        ModelCategory * model = self.myCategoryArr[indexPath.row];
        cell.modelCategory = model;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"3CA0E6"];
        cell.categoryNameLab.highlightedTextColor = [UIColor whiteColor];

    }
    else
    {
        ModelCategory * model = self.childCtyArr[indexPath.row];
        cell.modelCategory = model;
        cell.mSelected = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    categoryCell * thisCell = (categoryCell *)[tableView cellForRowAtIndexPath:indexPath];

    if ([tableView isEqual:self.leftTableView]) {
        [self.leftAllBtn setBackgroundColor:[UIColor whiteColor]];
        [self.leftAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.rightAllBtn.hidden = NO;
        [self.rightAllBtn setBackgroundColor:[UIColor colorWithHexString:@"3CA0E6"]];
        [self.rightAllBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        ModelCategory * thisModel = self.myCategoryArr[indexPath.row];
        self.fatherId = thisModel.ctyId;
        self.childCtyArr = thisModel.data;
        [self.rightTableView reloadData];
    }
    else
    {
        [thisCell changeMSelectedState];
        self.rightAllBtn.backgroundColor = [UIColor whiteColor];
        [self.rightAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (thisCell.mSelected) {
            [self.idsArr addObject:thisCell.modelCategory.ctyId];
            [self.selectArr addObject:thisCell];
        }
        else
        {
            [self.idsArr removeObject:thisCell.modelCategory.ctyId];
            [self.selectArr removeObject:thisCell];
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
