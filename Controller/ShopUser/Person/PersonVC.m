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
#import <UIImageView+WebCache.h>
#import "MyInfoVC.h"
#import "CompnayInfoVC.h"
#import "AppDelegate.h"

@interface PersonVC ()<UITableViewDelegate>
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
    titleArr = [[NSMutableArray alloc]initWithObjects:@"收货地址",@"公司信息", nil];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
        return 20;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    }
    else
    {
        return 40;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return titleArr.count;
    }
    else
    {
        return 1;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PersonMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"personMenuCell"];
        
        cell.titleLab.text = titleArr[indexPath.row];
        return cell;

    }
    else
    {
        static NSString * cellIndentifier = @"cellIndentifier";
        UITableViewCell * cancelCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (!cancelCell) {
            cancelCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        }
        cancelCell.backgroundColor = [UIColor redColor];
        UILabel * titleLab= [[UILabel alloc]initWithFrame:CGRectMake((Screen.width-100)/2,10 , 100, 20)];
        titleLab.text = @"退出账号";
        titleLab.textColor = [UIColor whiteColor];
        titleLab.font = [UIFont systemFontOfSize:17];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [cancelCell addSubview:titleLab];
        
        return cancelCell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
//    if (indexPath.row == 0) {
//        [self performSegueWithIdentifier:@"toMyInfo" sender:nil];
//    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
        {
            //管理收获地址
//            AddressVC * addressVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil]instantiateViewControllerWithIdentifier:@"addressVC"];
//            addressVC.isSetDefault = NO;
//            [self.navigationController pushViewController:addressVC animated:YES];
            [self performSegueWithIdentifier:@"toAddressManager" sender:nil];
        }
        else if(indexPath.row == 1)
        {
            [self performSegueWithIdentifier:@"toCompanyInfo" sender:nil];
        }

    }
    else
    {
        //注销
        
        NSLog(@"注销账号");
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您是否确认退出当前账号?" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [UserDefaultUtils saveValue:@"0" forKey:@"isLogin"];
            [UserDefaultUtils removeValueWithKey:@"userId"];
            [UserDefaultUtils removeValueWithKey:@"partnerId"];
            
            UIStoryboard *board         = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            UINavigationController * firstNav = [board instantiateViewControllerWithIdentifier:@"NavLogin"];
            
            AppDelegate *delete =  (AppDelegate *)[UIApplication sharedApplication].delegate;
            delete.window.rootViewController = firstNav;
            
            
            
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];

        
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
