//
//  CompnayInfoVC.m
//  DPH
//
//  Created by cym on 16/1/29.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "CompnayInfoVC.h"
#import "BaseTableViewCell.h"
#import "NetworkUser.h"

@interface CompnayInfoVC ()
{
    NSMutableArray * titleArr;
}
@property (nonatomic, strong)NSString * name;
@property (nonatomic, strong)NSString * address;

@end

@implementation CompnayInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titleArr = [[NSMutableArray alloc]initWithObjects:@"商户名称",@"地址", nil];
    [self getCompanyInfo];
}

-(void)getCompanyInfo
{
    [[NetworkUser sharedManager]getCompanyInfoByPartnerId:[UserDefaultUtils valueWithKey:@"partnerId"]
                                                  success:^(id result) {
                                                      self.name = result[@"name"];
                                                      self.address = result[@"addressDetails"];
                                                      [self.tableView reloadData];
                                                  }
                                                  failure:^(id result) {
                                                      [self showCommonHUD:result];
                                                      
                                                  }];
}

#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellIndentifier = @"baseTableViewCell";
    BaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        NSArray * nibArr = [[NSBundle mainBundle]loadNibNamed:@"BaseTableViewCell" owner:self options:nil];
        cell = nibArr[0];
        
    }
    if (indexPath.row == 0) {
        cell.detailLab.text = self.name;
    }
    else
    {
        cell.detailLab.text = self.address;
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
