//
//  PersonVC.m
//  DPH
//
//  Created by cym on 16/1/26.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PersonVC.h"
#import "PersonMenuCell.h"
#import "AddressVC.h"
#import "ModelUser.h"
#import "NetworkUser.h"
#import "UserDefaultUtils.h"
#import <YYModel.h>
#import <UIImageView+WebCache.h>
#import "MyInfoVC.h"
#import "CompnayInfoVC.h"

@interface PersonVC ()
{
    NSMutableArray * titleArr;
}
@property (nonatomic, strong)ModelUser * modelUser;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

@property (weak, nonatomic) IBOutlet UILabel *phoneLab;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end

@implementation PersonVC

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showtabbar" object:nil];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidetabbar" object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titleArr = [[NSMutableArray alloc]initWithObjects:@"我的账号",@"收货地址",@"公司信息", nil];
    [self getUserInfo];
}

-(void)getUserInfo
{
    [[NetworkUser sharedManager]getUserInfoByUserId:[UserDefaultUtils valueWithKey:@"userId"]
                                            success:^(id result) {
                                                self.modelUser = [ModelUser yy_modelWithDictionary:result];
                                                self.phoneLab.text = self.modelUser.contactMobile;
                                                self.nameLab.text = self.modelUser.name;
                                                [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_ImageUrl,self.modelUser.image]] placeholderImage:[UIImage imageNamed:@"default_pic"]];
                                                
                                            }
                                            failure:^(id result) {
                                                
                                            }];
}

#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"personMenuCell"];

    cell.titleLab.text = titleArr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"toMyInfo" sender:nil];
    }
    else if (indexPath.row == 1)
    {
        AddressVC * addressVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil]instantiateViewControllerWithIdentifier:@"addressVC"];
        addressVC.isSetDefault = NO;
        [self.navigationController pushViewController:addressVC animated:YES];
    }
    else
    {
        [self performSegueWithIdentifier:@"toCompanyInfo" sender:nil];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toMyInfo"]) {
        MyInfoVC * infoView = [[MyInfoVC alloc]init];
        infoView = segue.destinationViewController;
        infoView.modelUser = self.modelUser;
    }
//    else
//    {
//        CompnayInfoVC * comView = [[CompnayInfoVC alloc]init];
//        comView = segue.destinationViewController;
//        
//    }
}


@end
