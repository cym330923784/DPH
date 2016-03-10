//
//  ShopInfoVC.m
//  DPH
//
//  Created by cym on 16/2/1.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "ShopInfoVC.h"
#import "ShopInfoCell.h"
#import "PNetworkClient.h"
#import "ModelShop.h"
#import <UIImageView+WebCache.h>
#import "SelectPhotoViewCtrl.h"
#import <QiniuSDK.h>
#import "NetworkQNImg.h"
#import "PNetworkClient.h"
#import "Cym_PHD.h"
#import "ModelDeliveryArea.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface ShopInfoVC ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    BOOL isEditing;
    NSString * deliveryAreaStr,*deliveryAreaId;
}


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *shopImgView;

@property (weak, nonatomic) IBOutlet UITextField *shopNameTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UIButton *deliveryAreaBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *reservePhoneTF;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;


@property (nonatomic,strong)UIBarButtonItem * editItem;
@property (nonatomic,strong)UIBarButtonItem * cancelItem;

@property(nonatomic,strong)ModelShop * modelShop;


@end

@implementation ShopInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        isEditing = NO;

    [self getClientDetail];
}

-(void)initView
{
    if ([AppUtils userAuthJudgeBy:AUTH_update_endClientManage]) {
        self.editItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(change)];
        self.cancelItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEdit)];
        
        self.navigationItem.rightBarButtonItem = self.editItem;

    }
}
- (IBAction)saveAction:(id)sender {
    
    [AppUtils showAlert:@"提示" message:@"确认保存?" objectSelf:self defaultAction:^(id result) {
        [self saveToserver];
    } cancelAction:^(id result) {
        [self initData];
    }];
    
}
-(void)saveToserver
{
    [self showDownloadsHUD:@"提交中..."];
    self.modelShop.name = self.shopNameTF.text;
    self.modelShop.addressDetail = self.addressTF.text;
    self.modelShop.contactName = self.nameTF.text;
    self.modelShop.contactMobile = self.phoneTF.text;
    self.modelShop.secondaryPhone = self.reservePhoneTF.text;
    [[PNetworkClient sharedManager] editClientByUserId:[UserDefaultUtils valueWithKey:@"branchUserId"]
     
                                                Object:self.modelShop
                                               success:^(id result) {
                                                   [self dismissHUD];
                                                   isEditing = NO;
                                                   self.navigationItem.rightBarButtonItem = self.editItem;
                                                   [self setControlState];
                                                                                                  [Cym_PHD showSuccess:@"修改成功!"];
//                                                   [self showCommonHUD:@"成功!"];
                                                   
                                               }
                                               failure:^(id result) {
                                                   [self dismissHUD];
                                                   [self showCommonHUD:result];
                                                   
                                               }];
}


- (IBAction)tapHeadImage:(UITapGestureRecognizer *)tap
{
    
    NSLog(@"点击头像");
    //编辑状态下点击图片进行编辑
    if (isEditing) {
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
                    
                    self.shopImgView.image = img;
                    [self showDownloadsHUD:@"上传中..."];
                    [[NetworkQNImg sharedManager]getQNTokenSuccess:^(id result) {
                        QNUploadManager * manager = [[QNUploadManager alloc]init];
                        NSData *imageData = UIImagePNGRepresentation(img);// png
                        [manager putData:imageData key:nil
                                   token:result[@"token"]
                                complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                                    [self dismissHUD];
                                    NSLog(@"key == %@",resp[@"key"]);
                                    self.modelShop.image= resp[@"key"];
                                    self.shopImgView.image = img;
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
                                self.modelShop.image = resp[@"key"];
                                self.shopImgView.image = img;
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
    else// 非编辑状态下点击图片放大查看
    {
        NSArray *arr = [AppUtils cutStringToArray:self.modelShop.image symbol:@","];
        
        NSInteger count = arr.count;
        //     1.封装图片数据
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i<count; i++) {
            // 替换为中等尺寸图片
            NSString *url = [[NSString stringWithFormat:@"%@%@",QN_ImageUrl,arr[i]] stringByReplacingOccurrencesOfString:@"mdpi.jpg" withString:@"hdpi.jpg"];
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:url]; // 图片路径
            photo.srcImageView = self.shopImgView; // 来源于哪个UIImageView
            [photos addObject:photo];
        }
        
        //    // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];

    }

    
    
}

-(void)getClientDetail
{
    [self showDownloadsHUD:@"加载中..."];
    [[PNetworkClient sharedManager]getClientDetailByEndClientId:self.endClientId
                                                        success:^(id result) {
                                                            [self dismissHUD];
                                                            self.modelShop = [ModelShop yy_modelWithDictionary:result];
                                                            [self initData];
                                                            
                                                        }
                                                        failure:^(id result) {
                                                            [self dismissHUD];
                                                            [self showCommonHUD:result];
                                                            
                                                        }];
}

-(void)initData
{

    deliveryAreaStr = self.modelShop.businessAreas;
    deliveryAreaId = self.modelShop.areaId;
    [self.deliveryAreaBtn setTitle:self.modelShop.businessAreas forState:UIControlStateNormal];

    [self.shopImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_ImageUrl,self.modelShop.image]] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    self.shopNameTF.text = self.modelShop.name;
    self.addressTF.text = self.modelShop.addressDetail;
    self.nameTF.text = self.modelShop.contactName;
    self.phoneTF.text = self.modelShop.contactMobile;
    self.reservePhoneTF.text = self.modelShop.secondaryPhone;
    if ([self.modelShop.loginStatus isEqualToString:@"0"]) {
        self.stateLab.text = @"未激活";
    }
    else
    {
        self.stateLab.text = @"已激活";
    }
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
    [self.shopNameTF becomeFirstResponder];
    self.navigationItem.rightBarButtonItem = self.cancelItem;
    [self setControlState];
    
}
-(void)setControlState
{
    self.shopNameTF.enabled = isEditing;
    self.addressTF.enabled = isEditing;
    self.deliveryAreaBtn.userInteractionEnabled = isEditing;
    self.nameTF.enabled = isEditing;
    self.phoneTF.enabled = isEditing;
    self.reservePhoneTF.enabled = isEditing;
    self.saveBtn.hidden = !isEditing;
    
}

- (IBAction)chooseDeliveryArea:(id)sender {
    
    [self resign];
    
    UIPickerView * picker=  [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, Screen.width-100, 216)];
    
    //让pickview 默认选中原本的值
    
    NSInteger i = 0;
    NSInteger j = 0;
    for (ModelDeliveryArea * model in self.deliveryAreaArr) {
        if ([model.name isEqualToString:self.deliveryAreaBtn.titleLabel.text]) {
            j = i;
            
        }
        i++;
    }
    
    picker.tag = 200;
    picker.delegate = self;
    picker.dataSource = self;
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"\n\n\n\n\n\n\n\n"                                                                             message: nil                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController.view addSubview:picker];
    //让pickview 默认选中原本的值
    [picker selectRow:j inComponent:0 animated:NO];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.deliveryAreaBtn setTitle:deliveryAreaStr forState:UIControlStateNormal];

    }]];
    
    [self presentViewController: alertController animated: YES completion: nil];

    
}


-(void)resign
{
    [self.shopNameTF resignFirstResponder];
    [self.addressTF resignFirstResponder];
    [self.nameTF resignFirstResponder];
    [self.phoneTF resignFirstResponder];
    [self.reservePhoneTF resignFirstResponder];
}


#pragma mark - UIPickerviewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.deliveryAreaArr.count;

}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    ModelDeliveryArea * thisModel = self.deliveryAreaArr[row];
    return thisModel.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    ModelDeliveryArea * model =self.deliveryAreaArr[row];
    deliveryAreaId = model.areaId;
    deliveryAreaStr = model.name;
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
