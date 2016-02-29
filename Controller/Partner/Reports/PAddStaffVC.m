//
//  PAddStaffVC.m
//  DPH
//
//  Created by Cym on 16/2/26.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PAddStaffVC.h"
#import "ModelStaff.h"
#import "SelectPhotoViewCtrl.h"
#import "NetworkQNImg.h"
#import <QiniuSDK.h>
#import "PNetworkManage.h"
#import "Cym_PHD.h"

@interface PAddStaffVC ()

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *dutiesTF;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (nonatomic, strong)ModelStaff * modelStaff;


@end

@implementation PAddStaffVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)tapHeadImage:(id)sender {
    
    SelectPhotoViewCtrl * selectPhotoVc = [[SelectPhotoViewCtrl alloc]init];
    selectPhotoVc.allowsEditing = YES;
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
        // 点击按钮后的方法直接在这里面写
        NSLog(@"取消");
    }];
    
    UIAlertAction *photographAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        // 点击按钮后的方法直接在这里面写
        NSLog(@"拍照");
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            selectPhotoVc.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:selectPhotoVc animated:YES completion:nil];
            
            [selectPhotoVc getImage:^(UIImage *img){
                
                self.headImage.image = img;
                [self showDownloadsHUD:@"上传中..."];
                [[NetworkQNImg sharedManager]getQNTokenSuccess:^(id result) {
                    QNUploadManager * manager = [[QNUploadManager alloc]init];
                    NSData *imageData = UIImagePNGRepresentation(img);// png
                    [manager putData:imageData key:nil
                               token:result[@"token"]
                            complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                                [self dismissHUD];
                                NSLog(@"key == %@",resp[@"key"]);
                                self.modelStaff.image = resp[@"key"];
                                self.headImage.image = img;
                            }
                              option:nil];
                    
                } failure:^(id result) {
                    [self dismissHUD];
                    [self showCommonHUD:result];
                    
                }];
            }];
        }
        
    }];
    UIAlertAction *photoalbumAction = [UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        // 点击按钮后的方法直接在这里面写
        NSLog(@"相册");
        
        selectPhotoVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:selectPhotoVc animated:YES completion:nil];
        
        [selectPhotoVc getImage:^(UIImage *img){
            [self showDownloadsHUD:@"上传中..."];
            [[NetworkQNImg sharedManager]getQNTokenSuccess:^(id result) {
                QNUploadManager * manager = [[QNUploadManager alloc]init];
                NSData *imageData = UIImagePNGRepresentation(img);// png
                [manager putData:imageData key:nil
                           token:result[@"token"]
                        complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                            [self dismissHUD];
                            NSLog(@"key == %@",resp[@"key"]);
                            self.modelStaff.image = resp[@"key"];
                            self.headImage.image = img;
                        }
                          option:nil];
                
            } failure:^(id result) {
                [self dismissHUD];
                [self showCommonHUD:result];
                
            }];
            
        }];
        
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:photographAction];
    [alert addAction:photoalbumAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)saveAction:(id)sender {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认保存?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveToserver];
        
    }]];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];

    
}

-(void)saveToserver
{
    [self showDownloadsHUD:@"提交中..."];
    self.modelStaff.name = self.nameTF.text;
    self.modelStaff.contactMobile = self.phoneTF.text;
    self.modelStaff.duties = self.dutiesTF.text;
    [[PNetworkManage sharedManager]addStaffObject:self.modelStaff
                                          success:^(id result) {
                                              [self dismissHUD];
                                              self.saveBtn.hidden = YES;
                                              
                                              [Cym_PHD showSuccess:@"新建成功!"];
                                              [self.navigationController popViewControllerAnimated:YES];
                                              
                                          }
                                          failure:^(id result) {
                                              [self dismissHUD];
                                              [self showCommonHUD:result];
                                              
                                          }];

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
