//
//  BaseViewCtrl.m
//  DPH
//
//  Created by cym on 16/1/25.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "BaseViewCtrl.h"
#import <MBProgressHUD.h>
#import <IQKeyboardManager.h>

@interface BaseViewCtrl ()

@end

@implementation BaseViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:nil];
    //    self.navigationItem.
    //    backBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backBtn;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

}


-(void)showCommonHUD:(NSString *)status{
    MBProgressHUD *hud            = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode                      = MBProgressHUDModeText;
    hud.labelText                 = status;
    hud.margin                    = 10.f;
    hud.yOffset                   = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

-(void)showDownloadsHUD:(NSString *)status{
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [self.view bringSubviewToFront:hud];
    hud.labelText = status;
    [hud show:YES];
}

-(void)dismissHUD{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
