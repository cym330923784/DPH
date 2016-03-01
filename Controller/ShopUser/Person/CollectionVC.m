//
//  CollectionVC.m
//  DPH
//
//  Created by Cym on 16/3/1.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "CollectionVC.h"
#import "ProductCell.h"
#import "QuicklyBuyView.h"
#import "NetworkHome.h"

@interface CollectionVC ()

@end

@implementation CollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTable];
}

-(void)initTable
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_header endRefreshing];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.tableView.mj_footer endRefreshing];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)collectAction:(id)sender
{
    UIButton *collectBtn = (UIButton *)sender;
    ProductCell * cell = (ProductCell *)[[collectBtn superview] superview];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"删除商品" message:@"您确定要删除所选的商品?" preferredStyle:UIAlertControllerStyleAlert];
    
    [al addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
//        [[NetworkHome sharedManager]collectProductByUserId:[UserDefaultUtils valueWithKey:@"userId"]
//                                                 productId:cell.modelProduct.productId
//                                                   success:^(id result) {
//                                                       collectBtn.selected = !collectBtn.selected;
//                                                       
//                                                   }
//                                                   failure:^(id result) {
//                                                       [self showCommonHUD:result];
//                                                       
//                                                   }];

        
//        ModelProduct * model = self.productArr[indexPath.row];
//        [ShopCartSQL removeProductById:model.productId];
//        
//        [self.productArr removeObjectAtIndex:indexPath.row];
//        
//        //    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                              withRowAnimation:UITableViewRowAnimationLeft];
//        [self.cellArr removeAllObjects];
//        [self.tableView reloadData];
        
        
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:al animated:YES completion:nil];
    

    }

-(void)quicklyBuyAction:(id)sender
{
    UIButton *quickBuyBtn = (UIButton *)sender;
    ProductCell * cell = (ProductCell *)[[quickBuyBtn superview] superview];
    QuicklyBuyView * view = [[QuicklyBuyView alloc]initWithModelProduct:cell.modelProduct];
    //    view.modelProduct = cell.modelProduct;
    //    view.imageView.image = cell.proImageView.image;
    //    view.nameLab.text = cell.proNameLab.text;
    [view show];
}



#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndentifier = @"productCell";
    ProductCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        NSArray * nibArr = [[NSBundle mainBundle]loadNibNamed:@"ProductCell" owner:self options:nil];
        cell = nibArr[0];
        
    }
    [cell.collectBtn addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addShopcartBtn addTarget:self action:@selector(quicklyBuyAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    [self performSegueWithIdentifier:@"toPdtInfo" sender:indexPath];
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
