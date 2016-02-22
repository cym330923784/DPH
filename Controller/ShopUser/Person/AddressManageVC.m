//
//  AddressManageVC.m
//  DPH
//
//  Created by Cym on 16/2/22.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "AddressManageVC.h"
#import "DefaultAddressCell.h"
#import "CommonAddressCell.h"
#import "UIColor+TenSixColor.h"
#import "ModelAddress.h"
#import "NetworkHome.h"
#import "UserDefaultUtils.h"
#import <YYModel.h>
#import "Cym_PHD.h"

@interface AddressManageVC ()

@property(nonatomic, strong)NSMutableArray * addressArr;

@property (nonatomic,strong)ModelAddress * defaultAddress;

@end

@implementation AddressManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self getAddressList];
    
    
}

-(void)initData
{
    
    self.defaultAddress = [[ModelAddress alloc]init];
}

-(void)getAddressList
{
    [self showDownloadsHUD:@"加载中..."];
    [[NetworkHome sharedManager]getAddressListByUserId:[UserDefaultUtils valueWithKey:@"userId"]
                                               success:^(id result) {
                                                   self.addressArr  = [[NSMutableArray alloc]initWithCapacity:0];
                                                   for (NSDictionary * addressDic in result) {
                                                       [self dismissHUD];
                                                       ModelAddress * addressDemo = [ModelAddress yy_modelWithDictionary:addressDic];
                                                       [self.addressArr addObject:addressDemo];
                                                       for (ModelAddress * model in self.addressArr) {
                                                           if ([model.defaultState isEqualToString:@"1"]) {
                                                               self.defaultAddress = model;
                                                           }
                                                       }
                                                   }
                                                   [self.tableView reloadData];
        
    }
                                               failure:^(id result) {
                                                   [self dismissHUD];
                                                   [self showCommonHUD:result];
        
    }];
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    }
    else
    {
        return 30;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 20;
    }
    else
    {
        return 0;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView * defaultHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen.width, 50)];
        defaultHeaderView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Screen.width, 30)];
        view.backgroundColor = [UIColor yellowColor];
        UILabel * defaultTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 150, 20)];
        defaultTitleLab.text = @"默认收货地址";
        [view addSubview:defaultTitleLab];
        [defaultHeaderView addSubview:view];
        return defaultHeaderView;
        
    }
    else
    {
        UIView * commomHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, Screen.width, 30)];
        commomHeaderView.backgroundColor = [UIColor colorWithHexString:@"3CA0E6"];
        UILabel * commonTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 150, 20)];
        commonTitleLab.text = @"其他收货地址";
        commonTitleLab.textColor = [UIColor whiteColor];
        [commomHeaderView addSubview:commonTitleLab];
        return commomHeaderView;

    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen.width, 30)];
        footerView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
        return footerView;
    }
    else
    {
        return nil;
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70;
    }
    else
    {
        return 120;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.defaultAddress) {
            return 1;
        }
        else
        {
           return 0;
        }
        
    }
    else
    {
        if (self.defaultAddress) {
            return self.addressArr.count-1;
        }
        else
        {
            return self.addressArr.count-1;
        }
        
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        DefaultAddressCell * defaultCell = [tableView dequeueReusableCellWithIdentifier:@"defaultAddressCell"];
        if (self.defaultAddress) {
            defaultCell.modelAddress = self.defaultAddress;
        }
        return defaultCell;
        
    }
    else
    {
        CommonAddressCell * commonCell = [tableView dequeueReusableCellWithIdentifier:@"commonAddressCell"];
        if (self.defaultAddress) {
            commonCell.modelAddress = self.addressArr[indexPath.row+1];
        }
        else
        {
            commonCell.modelAddress = self.addressArr[indexPath.row];
        }
        
        [commonCell.setDefaultBtn addTarget:self action:@selector(setDefaultAction:) forControlEvents:UIControlEventTouchUpInside];
        [commonCell.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        return commonCell;
    }

}

-(void)setDefaultAction:(id)sender
{
    UIButton *delectBtn = (UIButton *)sender;
    CommonAddressCell *thisCell = (CommonAddressCell *)[[delectBtn superview] superview] ;
    
    [self showDownloadsHUD:nil];
    [[NetworkHome sharedManager]setAddressByUserId:[UserDefaultUtils valueWithKey:@"userId"]
                                         addressId:thisCell.modelAddress.addressId
                                           success:^(id result) {
                                               [self dismissHUD];
                                               
//                                               [self showCommonHUD:@"设置成功!"];
//                                               [Cym_PHD showSuccess:@"设为默认收货地址成功!"];
                                                [Cym_PHD showError:@"设为默认收货地址失败!"];
                                               [self getAddressList];
                                               
                                               NSData *data = [NSKeyedArchiver archivedDataWithRootObject:thisCell.modelAddress];                                          [UserDefaultUtils saveValue:data forKey:@"defaultAddress"];
                                           }
                                           failure:^(id result) {
                                               [self dismissHUD];
//                                               [self showCommonHUD:result];
                                               [Cym_PHD showError:@"设为默认收货地址失败!"];
                                           }];

}

-(void)deleteAction:(id)sender
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
