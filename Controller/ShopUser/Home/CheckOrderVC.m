//
//  CheckOrderVC.m
//  DPH
//
//  Created by cym on 16/1/27.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "CheckOrderVC.h"
#import "OrderMenuCell.h"
#import "TextViewAlertView.h"
#import "ModelTempProduct.h"
#import "ModelProduct.h"
#import "NetworkHome.h"
#import "ModelOrder.h"
#import "SubmitOrderSuccessVC.h"
#import "ShopCartSQL.h"
#import "AddressVC.h"
#import "NetworkHome.h"
#import "OrderProductListVC.h"
#import "ProductListVC.h"
#import "ModelFullStorage.h"


@interface CheckOrderVC ()
{
    NSString * orderNo;
    BOOL isTest;
}

@property(nonatomic ,strong)NSString * remarkStr;

@property (nonatomic, strong)NSMutableArray * tempProductArr;
@property (nonatomic, strong)NSMutableArray * errorArr;
@property (nonatomic, strong)ModelOrder * modelOrder;


@end

@implementation CheckOrderVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.errorArr = [NSMutableArray array];
    
    NSData * data = [UserDefaultUtils valueWithKey:@"defaultAddress"];
    self.modelAddress = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    isTest = NO;
    [self initData];

    [self.tableView reloadData];
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    self.errorArr = [NSArray array];
//    
//    NSData * data = [UserDefaultUtils valueWithKey:@"defaultAddress"];
//    self.modelAddress = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    isTest = NO;
//    [self initData];
//}

-(void)initData
{
    self.remarkStr = [NSString string];
    self.numLab.text = self.num;
    self.totalPriceLab.text = self.totalPrice;
    self.modelOrder = [[ModelOrder alloc]init];
    
    NSData * data = [UserDefaultUtils valueWithKey:@"defaultAddress"];
    self.modelAddress = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    self.tempProductArr = [[NSMutableArray alloc]init];
    for (ModelProduct * modelPro in self.productArr) {
        ModelTempProduct * tempProduct = [[ModelTempProduct alloc]init];
        tempProduct.productId = modelPro.productId;
        tempProduct.price = modelPro.sellingPrice;
        tempProduct.qty = modelPro.qty;
        
        tempProduct.specifications = modelPro.specifications;
        
        [self.tempProductArr addObject:tempProduct];
    }
    
    self.modelOrder.inventoryData = self.tempProductArr;
}

- (IBAction)submitOrderAction:(id)sender {
    [self showCommonHUD:@"提交中..."];
//    self.modelOrder.partnerId = [UserDefaultUtils valueWithKey:@"partnerId"];
    self.modelOrder.endClientId = [UserDefaultUtils valueWithKey:@"userId"];
    self.modelOrder.deliveryName = self.modelAddress.name;
    self.modelOrder.deliveryPhone = self.modelAddress.phone;
    self.modelOrder.deliveryAddress = self.modelAddress.addressDetails;
    self.modelOrder.note = self.remarkStr;
    self.modelOrder.totalCost = self.totalPrice;
    
    
    [[NetworkHome sharedManager]submitOrderByObject:self.modelOrder
                                          partnerId:[UserDefaultUtils valueWithKey:@"partnerId"]
                                            success:^(id result) {
                                                [self dismissHUD];
                                                
                                                orderNo = result[@"orderNo"];
                                                
                                                if ([result[@"state"] isEqualToString:@"success"])
                                                {
                                                    
                                                    [ShopCartSQL removeAllProInShopCart];
                                                    [UserDefaultUtils saveValue:@"0" forKey:@"badgeValue"];
                                                    [[NSNotificationCenter defaultCenter]postNotificationName:@"cleanUpBadgeValue" object:nil];
                                                    [self performSegueWithIdentifier:@"toSubmitSuccess" sender:nil];
                                                }
                                                //如果库存不足，后台返回状态码“lowStocks”
                                                else
                                                {
                                                    isTest = YES;
                                                    
                                                    NSMutableArray *arr = [NSMutableArray array];
                                                    for (NSDictionary * stoDic in result[@"data"]) {
                                                        ModelFullStorage * stoDemo = [ModelFullStorage yy_modelWithDictionary:stoDic];
                                                        [arr addObject:stoDemo];
                                                    }
                                                    [self.errorArr addObjectsFromArray:arr];
//                                                    [self showCommonHUD:@"大噶山东省的根深蒂固"];
                                                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:3];
                                                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                                                    [AppUtils showAlert:nil message:@"订单提交失败,请修改货品数量!" objectSelf:self defaultAction:nil cancelAction:nil];
                                                    [AppUtils showAlert:nil message:@"订单提交失败,请修改货品数量!" objectSelf:self defaultAction:^(id result) {
                                                        
                                                    } cancelAction:nil];

                                                }
                                            }
                                            failure:^(id result) {
                                                [self dismissHUD];
                                                [self showCommonHUD:result];
                                            }];
    
}

-(void)isSetDefaultAction
{
    
    [AppUtils showAlert:@"提示" message:@"是否确认?" objectSelf:self defaultAction:^(id result) {
        [self showDownloadsHUD:nil];
        [[NetworkHome sharedManager]setAddressByUserId:[UserDefaultUtils valueWithKey:@"userId"]
                                             addressId:self.modelAddress.addressId
                                               success:^(id result) {
                                                   [self dismissHUD];
                                                   NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.modelAddress];                                          [UserDefaultUtils saveValue:data forKey:@"defaultAddress"];
                                                   self.modelAddress.defaultState = @"1";
                                                   NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
                                                   [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                                                   
                                                   [self showCommonHUD:@"设置成功!"];
                                                   
                                               }
                                               failure:^(id result) {
                                                   [self dismissHUD];
                                                   [self showCommonHUD:@"设置失败"];
                                               }];

    } cancelAction:^(id result) {
        
    }];
    
}

#pragma mark - TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 5;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 30;
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0) {
            return 40;
        }
        else
        {
            if (self.modelAddress == nil) {
                return 0;
            }
            else
            {
                return 85;
            }
        }
    }
    else
    {
        if (indexPath.row == 2) {
            if ([self.remarkStr isEqualToString:@""]) {
                return 0;
            }
            else
            {
                return 60;
            }
            
        }
        else
        {
            return 40;
        }
        
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else if (section == 1)
    {
        return 3;
    }
    else if (section == 2)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderMenuCell * cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"OrderMenuCell" owner:nil options:nil];
            cell = nibArray[0];
        }
        

    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            if (!cell) {
                NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"OrderMenuCell" owner:nil options:nil];
                cell = nibArray[1];
            }
            cell.orderPriceLab.text = self.orderPrice;

        }
        else if(indexPath.row == 1)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
            if (!cell) {
                NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"OrderMenuCell" owner:nil options:nil];
                cell = nibArray[2];
            }
            cell.menuNameLab.text = @"订单备注";
            cell.numLab.hidden = YES;
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell5"];
            if (!cell) {
                NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"OrderMenuCell" owner:nil options:nil];
                cell = nibArray[4];
            }
            cell.remarkLab.text = self.remarkStr;
        }
    }
    else if(indexPath.section == 2)
    {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
            if (!cell) {
                NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"OrderMenuCell" owner:nil options:nil];
                cell = nibArray[2];
            }
            cell.menuNameLab.text = @"收货信息";
            cell.numLab.hidden = YES;
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
            if (!cell) {
                NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"OrderMenuCell" owner:nil options:nil];
                cell = nibArray[3];
            }
            cell.nameLab.text = self.modelAddress.name;
            cell.phoneLab.text = self.modelAddress.phone;
            cell.addressLab.text = self.modelAddress.addressDetails;
//            NSLog(@"%@",self.modelAddress.)
            if ([self.modelAddress.defaultState isEqualToString:@"0"]) {
                cell.setDefaultBtn.hidden = NO;
            }
            else
            {
                cell.setDefaultBtn.hidden = YES;
            }
            [cell.setDefaultBtn addTarget:self action:@selector(isSetDefaultAction) forControlEvents:UIControlEventTouchUpInside];
            
            
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (!cell) {
            NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"OrderMenuCell" owner:nil options:nil];
            cell = nibArray[2];
        }
        cell.menuNameLab.text = @"商品清单";
        cell.numLab.text = self.num;
        cell.attentionImage.hidden = !isTest;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 1)
    {
        NSLog(@"备注信息");
        
        TextViewAlertView * alert = [[TextViewAlertView alloc]initWithContentText:self.remarkStr leftButtonTitle:@"取消" rightButtonTitle:@"确认"];
        [alert show];
        alert.leftBlock = ^() {
            NSLog(@"left button clicked");
        };
        alert.rightBlock =  ^(NSString * str) {
            NSLog(@"right button clicked");
            
            self.remarkStr = str;
            [self.tableView reloadData];
            
            
        };
        alert.dismissBlock = ^() {
            NSLog(@"Do something interesting after dismiss block");
        };
        
        
        
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"toAddress" sender:nil];
        }
    }
    else if (indexPath.section == 3)
    {
//        OrderProductListVC * productList = [[OrderProductListVC alloc]init];
//        [self.navigationController pushViewController:productList animated:YES];
        [self performSegueWithIdentifier:@"toProList" sender:nil];
        
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindSegueToRedViewController:(UIStoryboardSegue *)segue {
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toSubmitSuccess"]) {
        SubmitOrderSuccessVC * view = [[SubmitOrderSuccessVC alloc]init];
        view = segue.destinationViewController;
        view.codeStr = orderNo;
        view.totalPriceStr = self.totalPrice;
    }
    
    else if ([segue.identifier isEqualToString:@"toAddress"])
    {
        AddressVC * addressView = [[AddressVC alloc]init];
        addressView = segue.destinationViewController;
        addressView.isSetDefault = YES;
        addressView.modelAddress = self.modelAddress;
    }
    
    else if ([segue.identifier isEqualToString:@"toProList"])
    {
        ProductListVC * proListView = [[ProductListVC alloc]init];
        proListView = segue.destinationViewController;
        proListView.isTest = isTest;
        proListView.errorArr = self.errorArr;
    }

}


@end
