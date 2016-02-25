//
//  PManageVC.m
//  DPH
//
//  Created by Cym on 16/2/24.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PManageVC.h"
#import "PManageCell.h"

@interface PManageVC ()
{
    NSArray * titleArr;
}

@end

@implementation PManageVC

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
    
    titleArr = @[@[@"个人中心",@"公司信息"],@[@"报表信息",@"收款记录"],@[@"用户管理"]];
    
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return titleArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [titleArr[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PManageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"pManageCell"];
    
    cell.titleLab.text = titleArr[indexPath.section][indexPath.row];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //个人信息
                    [self performSegueWithIdentifier:@"toPersonInfo" sender:nil];
                }
                    break;
                case 1:
                {
                    //公司信息
                    [self performSegueWithIdentifier:@"toCompanyInfo" sender:nil];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //报表信息
                    [self performSegueWithIdentifier:@"toReport" sender:nil];
                }
                    break;
                case 1:
                {
                    //收款纪录
                    [self performSegueWithIdentifier:@"toCollectCashRecord" sender:nil];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 2:
        {
            //用户管理
            [self performSegueWithIdentifier:@"toStaffManage" sender:nil];
        }
            break;
            
        default:
            break;
    }
    
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
