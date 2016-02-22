//
//  AddressVC.m
//  DPH
//
//  Created by cym on 16/1/27.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "AddressVC.h"
#import "AddressCell.h"
#import "NetworkHome.h"
#import "UserDefaultUtils.h"
#import <YYModel.h>
#import "AddAddressVC.h"
#import "CheckOrderVC.h"

@interface AddressVC ()

@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (nonatomic, strong)NSMutableArray * addressArr;
@property (nonatomic, strong)NSMutableArray * cellArr;


@end

@implementation AddressVC

-(void)viewWillAppear:(BOOL)animated
{
    self.addressArr = [[NSMutableArray alloc]init];
    self.cellArr = [[NSMutableArray alloc]init];
    [self getAddressList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self getAddressList];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    
//    self.titleView.backgroundColor = [UIColor colorWithRed:45.0/255 green:160.0/255 blue:230.0/255 alpha:0.7];
//}


-(void)getAddressList
{
    [self showDownloadsHUD:@"加载中..."];
    [[NetworkHome sharedManager]getAddressListByUserId:[UserDefaultUtils valueWithKey:@"userId"]
                                               success:^(id result) {
                                                   for (NSDictionary * addressDic in result) {
                                                       ModelAddress * addressDemo = [ModelAddress yy_modelWithDictionary:addressDic];
                                                       [self.addressArr addObject:addressDemo];
                                                   }
                                                   [self dismissHUD];
                                                   [self.tableView reloadData];
                                               }
                                               failure:^(id result) {
                                                   [self dismissHUD];
                                                   [self showCommonHUD:result];
                                               }];
}

#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell"];
    cell.modelAddress = self.addressArr[indexPath.row];
    if ([cell.modelAddress.addressId isEqual:self.modelAddress.addressId]) {
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"address_kuang"]];
    }
    else
    {
        cell.backgroundView = nil;
    }
    [self.cellArr addObject:cell];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressCell * thisCell = [tableView cellForRowAtIndexPath:indexPath];
    
           thisCell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"address_kuang"]];
        for (AddressCell * c in self.cellArr) {
            if (![c isEqual:thisCell]) {
                c.backgroundView = nil;
            }
        }
        [self showCommonHUD:@"设置成功!"];
        self.modelAddress = thisCell.modelAddress;
        [self performSegueWithIdentifier:@"backToCheckOrder" sender:nil];
   
}


- (IBAction)addAddressAction:(id)sender {
    NSLog(@"新增收货地址");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toAddAddress"]) {
        AddAddressVC * view = [[AddAddressVC alloc]init];
        view = segue.destinationViewController;
        view.isSetDefault = self.isSetDefault;
    }
    
    else if ([segue.identifier isEqualToString:@"backToCheckOrder"])
    {
        CheckOrderVC * checkOrder = [[CheckOrderVC alloc]init];
        checkOrder = segue.destinationViewController;
        checkOrder.modelAddress = self.modelAddress;
    }
}


@end
