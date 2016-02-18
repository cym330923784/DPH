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
#import "ModelAddress.h"
#import "UserDefaultUtils.h"
#import "ModelTempProduct.h"
#import "ModelProduct.h"
#import "NetworkHome.h"
#import "ModelOrder.h"
#import "SubmitOrderSuccessVC.h"
#import "ShopCartSQL.h"
#import "AddressVC.h"


@interface CheckOrderVC ()
{
    NSString * orderNo;
}

@property(nonatomic ,strong)NSString * remarkStr;
@property (nonatomic, strong)ModelAddress * modelAddress;
@property (nonatomic, strong)NSMutableArray * tempProductArr;
@property (nonatomic, strong)ModelOrder * modelOrder;


@end

@implementation CheckOrderVC

-(void)viewDidAppear:(BOOL)animated
{
    NSData * data = [UserDefaultUtils valueWithKey:@"defaultAddress"];
    self.modelAddress = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
}

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
    self.modelOrder.endClientId = [UserDefaultUtils valueWithKey:@"userId"];
    self.modelOrder.deliveryName = self.modelAddress.name;
    self.modelOrder.deliveryPhone = self.modelAddress.phone;
    self.modelOrder.deliveryAddress = self.modelAddress.addressdetails;
    self.modelOrder.note = self.remarkStr;
    self.modelOrder.totalCost = self.totalPrice;
    
    
    [[NetworkHome sharedManager]submitOrderByObject:self.modelOrder
                                            success:^(id result) {
                                                [self dismissHUD];
                                                orderNo = result[@"orderNo"];
                                                [ShopCartSQL removeAllProInShopCart];
                                                [self performSegueWithIdentifier:@"toSubmitSuccess" sender:nil];
                                            }
                                            failure:^(id result) {
                                                [self dismissHUD];
                                                [self showCommonHUD:result];
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
                return 65;
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
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else if (section == 1)
    {
        return 3;
    }
    else
    {
        return 2;
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
    else
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
            cell.addressLab.text = self.modelAddress.addressdetails;
        }
    }
//    else
//    {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
//        if (!cell) {
//            NSArray * nibArray =[[NSBundle mainBundle]loadNibNamed:@"OrderMenuCell" owner:nil options:nil];
//            cell = nibArray[2];
//        }
//        cell.menuNameLab.text = @"商品清单";
//    }
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
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    }

}


@end
