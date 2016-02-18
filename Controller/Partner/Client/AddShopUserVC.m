//
//  AddShopUserVC.m
//  DPH
//
//  Created by cym on 16/2/1.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "AddShopUserVC.h"
#import "SelectPhotoViewCtrl.h"
#import "NetworkQNImg.h"
#import <QiniuSDK.h>
#import "UserDefaultUtils.h"
#import "ModelShop.h"
#import "PNetworkClient.h"

@interface AddShopUserVC ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    NSArray *provinces, *cities, *areas;
}
@property (strong, nonatomic) NSString * areaValue;
@property (nonatomic,strong)ModelShop * modelShop;


@end

@implementation AddShopUserVC

@synthesize areaValue=_areaValue;

-(ModelLocation *)locate
{
    if (_locate == nil) {
        _locate = [[ModelLocation alloc] init];
    }
    
    return _locate;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
}

-(void)initData
{
    
    self.modelShop = [[ModelShop alloc]init];
    self.secondView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    cities = [[provinces objectAtIndex:0] objectForKey:@"cities"];
    
    self.locate.state = [[provinces objectAtIndex:0] objectForKey:@"state"];
    self.locate.city = [[cities objectAtIndex:0] objectForKey:@"city"];
    
    areas = [[cities objectAtIndex:0] objectForKey:@"areas"];
    if (areas.count > 0) {
        self.locate.district = [areas objectAtIndex:0];
    } else{
        self.locate.district = @"";
    }
    
}

- (IBAction)tapShopImgView:(id)sender {
    
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
                                self.modelShop.images = resp[@"key"];
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
                            self.modelShop.images = resp[@"key"];
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


- (IBAction)chooseStateAction:(id)sender {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil                                                                             message: nil                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    //添加Button
    [alertController addAction: [UIAlertAction actionWithTitle: @"已激活" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.stateBtn setTitle:@"已激活" forState:UIControlStateNormal];
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"未激活" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.stateBtn setTitle:@"未激活" forState:UIControlStateNormal];
        
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: alertController animated: YES completion: nil];

}




- (IBAction)saveAction:(id)sender {
    

    if (![self checkInfo]) {
        return;
    }
    
    self.modelShop.partnerId = [UserDefaultUtils valueWithKey:@"partnerId"];
    self.modelShop.name = self.shopNameTF.text;
    self.modelShop.addressDetail = [NSString stringWithFormat:@"%@%@",self.areaBtn.titleLabel.text,self.addressTF.text];
    self.modelShop.contactName = self.contectNameTF.text;
    self.modelShop.contactPosition = self.positionTF.text;
    self.modelShop.contactMobile = self.phoneTF.text;
    self.modelShop.contactEmail = self.emailTF.text;
    self.modelShop.contactQQ = self.QQTF.text;
    if ([self.stateBtn.titleLabel.text isEqualToString:@"未激活"]) {
        self.modelShop.loginStatus = @"0";
    }
    else
    {
        self.modelShop.loginStatus = @"1";
    }
    
    [self showDownloadsHUD:@"提交中..."];
    [[PNetworkClient sharedManager]addClientByObject:self.modelShop
                                             success:^(id result) {
                                                 [self dismissHUD];
                                                 [self showCommonHUD:@"提交成功!"];
                                                 [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:nil afterDelay:2];
                                                 
        
    }
                                             failure:^(id result) {
                                                 [self dismissHUD];
                                                 [self showCommonHUD:@"提交失败!"];
        
    }];
    
}


-(BOOL)checkInfo
{
    if ([self.shopNameTF.text isEqualToString:@""]) {
        [self showCommonHUD:@"请输入商户名称!"];
        return NO;
    }
    NSLog(@"%@",self.shopImgView.image);
    if (self.shopImgView.image == nil) {
        [self showCommonHUD:@"请选择商户图片!"];
        return NO;
    }
    if ([self.areaBtn.titleLabel.text isEqualToString:@"请选择地区"]) {
        [self showCommonHUD:@"请选择地区!"];
        return NO;
    }
    if ([self.addressTF.text isEqualToString:@""]) {
        [self showCommonHUD:@"请输入相信收货地址!"];
        return NO;
    }
    if ([self.contectNameTF.text isEqualToString:@""]) {
        [self showCommonHUD:@"请输入联系人姓名!"];
        return NO;
    }
    if ([self.phoneTF.text isEqualToString:@""]) {
        [self showCommonHUD:@"请输入联系人电话!"];
        return NO;
    }
    return YES;
}

-(void)setAreaValue:(NSString *)areaValue
{
    if (![_areaValue isEqualToString:areaValue]) {
        _areaValue = areaValue;
        self.areaLab.text = areaValue;
        
        //        [self.areaBtn setTitle:areaValue forState:UIControlStateNormal];
    }
}

- (IBAction)chooseAreaAction:(id)sender {

    [self resign];
    [self.view bringSubviewToFront:self.secondView];
}
- (IBAction)finishAction:(id)sender {
    [self.view sendSubviewToBack:self.secondView];
    [self.areaBtn setTitle:[NSString stringWithFormat:@"%@",self.areaLab.text] forState:UIControlStateNormal];
    [self.areaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}



-(void)resign
{
    [self.shopNameTF resignFirstResponder];
    [self.addressTF resignFirstResponder];
    [self.contectNameTF resignFirstResponder];
    [self.positionTF resignFirstResponder];
    [self.phoneTF resignFirstResponder];
    [self.emailTF resignFirstResponder];
    [self.QQTF resignFirstResponder];
}

- (IBAction)cancel:(id)sender {
    [self.view sendSubviewToBack:self.secondView];
}

- (IBAction)cancelAction:(id)sender {
     [self.view sendSubviewToBack:self.secondView];
}




#pragma mark - UIPickerviewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [provinces count];
            break;
        case 1:
            return [cities count];
            break;
        case 2:
            return [areas count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [[provinces objectAtIndex:row] objectForKey:@"state"];
            break;
        case 1:
            return [[cities objectAtIndex:row] objectForKey:@"city"];
            break;
        case 2:
            if ([areas count] > 0) {
                return [areas objectAtIndex:row];
                break;
            }
        default:
            return  @"";
            break;
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
            cities = [[provinces objectAtIndex:row] objectForKey:@"cities"];
            [self.pickerView selectRow:0 inComponent:1 animated:YES];
            [self.pickerView reloadComponent:1];
            
            areas = [[cities objectAtIndex:0] objectForKey:@"areas"];
            [self.pickerView selectRow:0 inComponent:2 animated:YES];
            [self.pickerView reloadComponent:2];
            
            self.locate.state = [[provinces objectAtIndex:row] objectForKey:@"state"];
            self.locate.city = [[cities objectAtIndex:0] objectForKey:@"city"];
            if ([areas count] > 0) {
                self.locate.district = [areas objectAtIndex:0];
            } else{
                self.locate.district = @"";
            }
            self.areaValue = [NSString stringWithFormat:@"%@%@%@", self.locate.state, self.locate.city, self.locate.district];
            
            break;
        case 1:
            areas = [[cities objectAtIndex:row] objectForKey:@"areas"];
            [self.pickerView selectRow:0 inComponent:2 animated:YES];
            [self.pickerView reloadComponent:2];
            
            self.locate.city = [[cities objectAtIndex:row] objectForKey:@"city"];
            if ([areas count] > 0) {
                self.locate.district = [areas objectAtIndex:0];
            } else{
                self.locate.district = @"";
            }
            self.areaValue = [NSString stringWithFormat:@"%@%@%@", self.locate.state, self.locate.city, self.locate.district];
            
            break;
        case 2:
            if ([areas count] > 0) {
                self.locate.district = [areas objectAtIndex:row];
            } else{
                self.locate.district = @"";
            }
            self.areaValue = [NSString stringWithFormat:@"%@%@%@", self.locate.state, self.locate.city, self.locate.district];
            
            break;
        default:
            break;
    }
    
    
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
