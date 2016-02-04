//
//  ShopInfoVC.m
//  DPH
//
//  Created by cym on 16/2/1.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "ShopInfoVC.h"
#import "ShopInfoCell.h"
#import "PNetworkClient.h"
#import "ModelShop.h"
#import <YYModel.h>
#import <UIImageView+WebCache.h>

@interface ShopInfoVC ()
{
    NSArray * titleArr;
}

@property(nonatomic,strong)ModelShop * modelShop;


@end

@implementation ShopInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titleArr = @[@"地址",@"姓名",@"职位",@"电话",@"邮箱",@"QQ",@"状态"];
    [self getClientDetail];
}

-(void)getClientDetail
{
    [self showDownloadsHUD:@"加载中..."];
    [[PNetworkClient sharedManager]getClientDetailByEndClientId:self.endClientId
                                                        success:^(id result) {
                                                            [self dismissHUD];
                                                            self.modelShop = [ModelShop yy_modelWithDictionary:result];
                                                            [self.shopImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_ImageUrl,self.modelShop.images]] placeholderImage:[UIImage imageNamed:@"default_pic"]];
                                                            self.shopNameLab.text = self.modelShop.name;
                                                            [self.tableView reloadData];
        
    }
                                                        failure:^(id result) {
                                                            [self dismissHUD];
                                                            [self showCommonHUD:result];
        
                                                        }];
}

#pragma mark - TableViewDelegate

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%lu",(unsigned long)titleArr.count);
    return titleArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"shopInfoCell"];
    cell.titleLab.text = titleArr[indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            cell.infoLab.text = self.modelShop.addressDetail;
        }
            break;
        case 1:
        {
            cell.infoLab.text = self.modelShop.contactName;
        }
            break;
        case 2:
        {
            cell.infoLab.text = self.modelShop.contactPosition;
        }
            break;
        case 3:
        {
            cell.infoLab.text = self.modelShop.contactMobile;
        }
            break;
        case 4:
        {
            cell.infoLab.text = self.modelShop.contactEmail;
        }
            break;
        case 5:
        {
            cell.infoLab.text = self.modelShop.contactQQ;
        }
            break;
        case 6:
        {
            if ([self.modelShop.loginStatus isEqualToString:@"0"]) {
                cell.infoLab.text = @"未激活";
            }
            else
            {
                cell.infoLab.text = @"已激活";
            }
        }
            break;
            
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
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
