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
#import "ModelAddress.h"
#import <YYModel.h>
#import "AddAddressVC.h"

@interface AddressVC ()

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
    if ([cell.modelAddress.defaultstate isEqualToString:@"1"]) {
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
    
    if ([thisCell.modelAddress.defaultstate isEqualToString:@"1"]) {
        return;
    }
    else
    {
        [[NetworkHome sharedManager]setAddressByUserId:[UserDefaultUtils valueWithKey:@"userId"]
                                             addressId:thisCell.modelAddress.addressId
                                               success:^(id result) {
                                                   thisCell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"address_kuang"]];
                                                   thisCell.modelAddress.defaultstate = @"1";
                                                   for (AddressCell * c in self.cellArr) {
                                                       if (![c isEqual:thisCell]) {
                                                           c.backgroundView = nil;
                                                           c.modelAddress.defaultstate = @"0";
                                                       }
                                                   }
                                                   
                                                   NSData *data = [NSKeyedArchiver archivedDataWithRootObject:thisCell.modelAddress];                                          [UserDefaultUtils saveValue:data forKey:@"defaultAddress"];
                                               }
                                               failure:^(id result) {
                                                   [self showCommonHUD:result];
                                               }];
    }
    
   
}

//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
//{
//    AddressCell * thisCell = [tableView cellForRowAtIndexPath:indexPath];
//    thisCell.backgroundView = nil;
//    thisCell.modelAddress.defaultstate = @"0";
//}

- (IBAction)addAddressAction:(id)sender {
    NSLog(@"新增收货地址");
//    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
//    NSString *s = [[NSString alloc] initWithFormat:@"hello"];
//    [self.datas addObject:s];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [indexPaths addObject: indexPath];
//    [self.tableView beginUpdates];
//    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
//    [self.tableView endUpdates];
    
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
}


@end
