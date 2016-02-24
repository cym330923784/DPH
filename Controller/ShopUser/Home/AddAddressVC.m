//
//  AddAddressVC.m
//  DPH
//
//  Created by cym on 16/1/27.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "AddAddressVC.h"
#import "ModelAddress.h"
#import "NetworkHome.h"
#import "NSString+Check.h"

@interface AddAddressVC ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray *provinces, *cities, *areas;
}
@property (strong, nonatomic) NSString * areaValue;
@property (strong, nonatomic)ModelAddress * modelAddress;




@end

@implementation AddAddressVC
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
    self.modelAddress = [[ModelAddress alloc]init];
    
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
-(void)resign
{
    [self.nameTF resignFirstResponder];
    [self.phoneTF resignFirstResponder];
    [self.detailAddressTF resignFirstResponder];
}
- (IBAction)finishAction:(id)sender {
    [self.view sendSubviewToBack:self.secondView];
    [self.areaBtn setTitle:[NSString stringWithFormat:@"%@",self.areaLab.text] forState:UIControlStateNormal];
    [self.areaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
- (IBAction)cancelAction:(id)sender {
     [self.view sendSubviewToBack:self.secondView];
}
- (IBAction)cancel:(id)sender {
     [self.view sendSubviewToBack:self.secondView];
}

- (IBAction)saveAction:(id)sender {
    
    if ([self.nameTF.text isEqualToString:@""]) {
        [self showCommonHUD:@"收货人姓名不能为空!"];
        return;
    }
    if ([self.phoneTF.text isEqualToString:@""])
    {
        [self showCommonHUD:@"手机号码不能为空!"];
        return;
    }
    else
    {
        if (![NSString isMobileNumber:self.phoneTF.text]) {
            [self showCommonHUD:@"请输入正确的手机号!"];
            return;
        }
    }
    if ([self.areaBtn.titleLabel.text isEqualToString:@"请选择收货区域"]) {
        [self showCommonHUD:@"收货区域不能为空!"];
        return;
    }
    if ([self.detailAddressTF.text isEqualToString:@""])
    {
        [self showCommonHUD:@"详细地址不能为空!"];
        return;
    }
    
    self.modelAddress.name = self.nameTF.text;
    self.modelAddress.phone = self.phoneTF.text;
    self.modelAddress.addressDetails = [NSString stringWithFormat:@"%@%@",self.areaBtn.titleLabel.text,self.detailAddressTF.text];
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认保存?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showDownloadsHUD:@"提交中..."];
        [[NetworkHome sharedManager] addAddressByUserId:[UserDefaultUtils valueWithKey:@"userId"]
                                                   name:self.modelAddress.name
                                                  phone:self.modelAddress.phone
                                                address:self.modelAddress.addressDetails
                                                success:^(id result) {
                                                    
                                                    NSLog(@"%d",self.isSetDefault);
                                                    if (self.isSetDefault) {
                                                        self.modelAddress.addressId = result[@"id"];
                                                        
                                                        //发送设为默认请求
                                                        
                                                        [[NetworkHome sharedManager]setAddressByUserId:[UserDefaultUtils valueWithKey:@"userId"]
                                                                                             addressId:result[@"id"]
                                                                                               success:^(id result) {
                                                                                                   [self dismissHUD];
                                                                                                   NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.modelAddress];                                          [UserDefaultUtils saveValue:data forKey:@"defaultAddress"];
                                                                                                   [self showCommonHUD:@"成功!"];
                                                                                                   [self.navigationController popViewControllerAnimated:YES];
                                                                                               }
                                                                                               failure:^(id result) {
                                                                                                   [self showCommonHUD:result];
                                                                                               }];
                                                    }
                                                    else
                                                    {
                                                        [self dismissHUD];
                                                        [self showCommonHUD:@"提交成功!"];
                                                        [self.navigationController popViewControllerAnimated:YES];
                                                    }
                                                    
                                                }
                                                failure:^(id result) {
                                                    [self dismissHUD];
                                                    [self showCommonHUD:result];
                                                }];
        
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
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
