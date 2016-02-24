//
//  OrderProductListVC.m
//  DPH
//
//  Created by cym on 16/1/31.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "OrderProductListVC.h"
#import "ProductListCell.h"
#import "NetworkOrder.h"
#import "ModelProduct.h"

@interface OrderProductListVC ()

@property (nonatomic, strong)NSMutableArray * productArr;

@end

@implementation OrderProductListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.productArr = [[NSMutableArray alloc]init];
    
    self.numLab.text = self.numStr;
    self.totalPriceLab.text = self.totalPriceStr;
    
    [self getOrderProductList];
}

-(void)getOrderProductList
{
    [[NetworkOrder sharedManager]getORderProductListByOrderId:self.orderId
                                                      success:^(id result) {
                                                          for (NSDictionary * proDic in result) {
                                                              ModelProduct * proDemo = [ModelProduct yy_modelWithDictionary:proDic];
                                                              [self.productArr addObject:proDemo];
                                                          }
                                                          [self.tableView reloadData];
                                                          
                                                      }
                                                      failure:^(id result) {
                                                          [self showCommonHUD:result];
                                                      }];
}

- (IBAction)finishAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma marks - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.productArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"productListCell"];
    cell.modelProduct = self.productArr[indexPath.row];
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
