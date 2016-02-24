//
//  MyInfoVC.m
//  DPH
//
//  Created by cym on 16/1/29.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "MyInfoVC.h"
#import "AppDelegate.h"
#import "BaseTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface MyInfoVC ()
{
    NSMutableArray * titleArr;
}

@end

@implementation MyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titleArr = [[NSMutableArray alloc]initWithObjects:@"姓名",@"职位",@"手机",@"邮箱", nil];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_ImageUrl,self.modelUser.image]] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    self.phoneLab.text = self.modelUser.contactMobile;
}
- (IBAction)logoutAction:(id)sender {
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

#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndentifier = @"baseTableViewCell";
    BaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        NSArray * nibArr = [[NSBundle mainBundle]loadNibNamed:@"BaseTableViewCell" owner:self options:nil];
        cell = nibArr[0];
    }
    switch (indexPath.row) {
        case 0:
        {
            cell.detailLab.text = self.modelUser.name;
        }
            break;
        case 1:
        {
            cell.detailLab.text = self.modelUser.contactPosition;
        }
            break;
        case 2:
        {
            cell.detailLab.text = self.modelUser.contactMobile;
        }
            break;
        case 3:
        {
            cell.detailLab.text = self.modelUser.contactEmail;
        }
            break;
            
        default:
            break;
    }
    cell.titleLab.text = titleArr[indexPath.row];
    return cell;
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
