//
//  PStaffDetailVC.m
//  DPH
//
//  Created by Cym on 16/2/25.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PStaffDetailVC.h"
#import <UIImageView+WebCache.h>
#import "PNetworkManage.h"
#import "SelectPhotoViewCtrl.h"
#import "NetworkQNImg.h"
#import <QiniuSDK.h>
#import "Cym_PHD.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface PStaffDetailVC ()
{
    BOOL isEditing;
}

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *positionBtn;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (nonatomic,strong)UIBarButtonItem * editItem;
@property (nonatomic,strong)UIBarButtonItem * cancelItem;

@property (nonatomic, strong)ModelStaff * nowModelStaff;

@end

@implementation PStaffDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.nowModelStaff = self.modelStaff;
    [self initView];
    [self initData];
}

-(void)initView
{
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = self.headImage.bounds.size.width/2;
    
    self.editItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(change)];
    self.cancelItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEdit)];
    self.navigationItem.rightBarButtonItem = self.editItem;
    isEditing = NO;

}


-(void)initData
{
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_ImageUrl,self.modelStaff.image]] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    self.nameTF.text = self.modelStaff.name;
    self.phoneTF.text = self.modelStaff.contactMobile;
    [self.positionBtn setTitle:self.modelStaff.duties forState:UIControlStateNormal];
}

-(void)saveToserver
{
    [self showDownloadsHUD:@"提交中..."];
    self.nowModelStaff.name = self.nameTF.text;
    self.nowModelStaff.contactMobile = self.phoneTF.text;
    self.nowModelStaff.duties = self.positionBtn.titleLabel.text;
    [[PNetworkManage sharedManager]editStaffObject:self.nowModelStaff
                                           success:^(id result) {
                                               [self dismissHUD];
                                               isEditing = NO;
                                               self.navigationItem.rightBarButtonItem = self.editItem;
                                               [self setControlState];
                                               [Cym_PHD showSuccess:@"修改成功!"];
        
    }
                                           failure:^(id result) {
                                               [self dismissHUD];
                                               [self showCommonHUD:result];
        
    }];
}

- (IBAction)tapHeadImage:(UITapGestureRecognizer *)tap
{
    NSLog(@"点击头像");
    
    if (isEditing) {//编辑状态下点击图片编辑
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
                                    self.nowModelStaff.image = resp[@"key"];
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
                                self.nowModelStaff.image = resp[@"key"];
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
    else//非编辑状态下，点击图片放大查看
    {
        NSArray *arr = [AppUtils cutStringToArray:self.modelStaff.image symbol:@","];
        
        NSInteger count = arr.count;
        //     1.封装图片数据
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i<count; i++) {
            // 替换为中等尺寸图片
            NSString *url = [[NSString stringWithFormat:@"%@%@",QN_ImageUrl,arr[i]] stringByReplacingOccurrencesOfString:@"mdpi.jpg" withString:@"hdpi.jpg"];
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:url]; // 图片路径
            photo.srcImageView = self.headImage; // 来源于哪个UIImageView
            [photos addObject:photo];
        }
        
        //    // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];

    }
    
    

}

- (IBAction)saveAction:(id)sender {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认保存?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveToserver];
        
    }]];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self initData];
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)cancelEdit
{
    isEditing = NO;
    self.navigationItem.rightBarButtonItem = self.editItem;
    
    /*
     此处需给所有空间内容赋原来的值
     */
    [self initData];
    [self setControlState];
}

-(void)change
{
    isEditing = YES;
    [self.nameTF becomeFirstResponder];
    self.navigationItem.rightBarButtonItem = self.cancelItem;
    [self setControlState];
    
}


//刷新控件的状态，是否可编辑
-(void)setControlState
{
    self.nameTF.enabled = isEditing;
    self.phoneTF.enabled = isEditing;
    self.saveBtn.hidden = !isEditing;
    
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
