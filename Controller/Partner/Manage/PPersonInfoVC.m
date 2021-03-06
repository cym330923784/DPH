//
//  PPersonInfoVC.m
//  DPH
//
//  Created by Cym on 16/2/24.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PPersonInfoVC.h"
#import "BaseTableViewCell.h"
#import "AppDelegate.h"
#import "PNetworkManage.h"
#import "ModelPartner.h"
#import "Cym_PHD.h"
#import <UIImageView+WebCache.h>

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface PPersonInfoVC ()
{
    NSArray * titleArr;
}

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (nonatomic,strong)ModelPartner * modelPartner;
@end

@implementation PPersonInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titleArr = @[@"姓名",@"手机",@"职务"];
    [self getSelfInfo];
}

-(void)getSelfInfo
{
    [self showDownloadsHUD:@"加载中..."];
    [[PNetworkManage sharedManager]getUserInfoByPartnerId:[UserDefaultUtils valueWithKey:@"partnerId"]
                                                  success:^(id result) {
                                                      [self dismissHUD];
                                                      self.modelPartner = [ModelPartner yy_modelWithDictionary:result];
                                                      [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_ImageUrl,self.modelPartner.image]] placeholderImage:[UIImage imageNamed:@"default_pic"]];
                                                      [self.tableView reloadData];
                                                      
                                                  }
                                                  failure:^(id result) {
                                                      [self dismissHUD];
                                                      [Cym_PHD showError:@"加载失败!"];
                                                      
                                                  }];
}

- (IBAction)cancelAction:(id)sender {
    NSLog(@"注销账号");
    
    [AppUtils showAlert:@"提示" message:@"您是否确认退出当前账号?" objectSelf:self defaultAction:^(id result) {
        [UserDefaultUtils saveValue:@"0" forKey:@"isLogin"];
        [UserDefaultUtils removeValueWithKey:@"partnerId"];
        [UserDefaultUtils removeValueWithKey:@"branchUserId"];
        
        UIStoryboard *board         = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UINavigationController * firstNav = [board instantiateViewControllerWithIdentifier:@"NavLogin"];
        
        AppDelegate *delete =  (AppDelegate *)[UIApplication sharedApplication].delegate;
        delete.window.rootViewController = firstNav;

    } cancelAction:^(id result) {
        
    }];
    
}

- (IBAction)tapHeadImage:(UITapGestureRecognizer*)tap
{
    NSArray *arr = [AppUtils cutStringToArray:self.modelPartner.image symbol:@","];
    
    NSInteger count = arr.count;
    //     1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString *url = [[NSString stringWithFormat:@"%@%@",QN_ImageUrl,arr[i]] stringByReplacingOccurrencesOfString:@"mdpi.jpg" withString:@"hdpi.jpg"];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = self.headImg; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    //    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];



    
}


#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndentifier = @"baseTableViewCell";
    BaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        NSArray * nibArr = [[NSBundle mainBundle]loadNibNamed:@"BaseTableViewCell" owner:self options:nil];
        cell = nibArr[0];
    }
    cell.titleLab.text = titleArr[indexPath.row];
    switch (indexPath.row) {
        case 0:
            cell.detailLab.text = self.modelPartner.name;
            break;
        case 1:
            cell.detailLab.text = self.modelPartner.contactMobile;
            break;
        case 2:
            cell.detailLab.text = self.modelPartner.duties;
            break;
            
        default:
            break;
    }
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
