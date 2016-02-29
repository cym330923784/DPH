//
//  PCompanyInfo.m
//  DPH
//
//  Created by Cym on 16/2/24.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "PCompanyInfo.h"
#import "PNetworkManage.h"
#import "Cym_PHD.h"


@interface PCompanyInfo ()<UITextFieldDelegate>
{
    BOOL isEditing;
    NSArray *provinces, *cities, *areas;
}


@property (strong, nonatomic) NSString * areaValue;


@property (weak, nonatomic) IBOutlet UITextField *comPanyTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UIButton *areaBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;


@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;


@property (nonatomic,strong)UIBarButtonItem * editItem;
@property (nonatomic,strong)UIBarButtonItem * cancelItem;

@property (nonatomic,strong)ModelCompany * modelCompany;

@end

@implementation PCompanyInfo
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
    self.editItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(change)];
    self.cancelItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEdit)];

    self.navigationItem.rightBarButtonItem = self.editItem;
    self.comPanyTF.delegate = self;
    isEditing = NO;
    [self initData];
    [self getCompanyInfo];
}

-(void)initData
{
    
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

-(void)getCompanyInfo
{
    [self showDownloadsHUD:@"加载中..."];
    [[PNetworkManage sharedManager]getCompanyInfoByPartnerId:[UserDefaultUtils valueWithKey:@"partnerId"]
                                                     success:^(id result) {
                                                         [self dismissHUD];
                                                         self.modelCompany = [ModelCompany yy_modelWithDictionary:result];
                                                         [self returnControlValue];
        
    }
                                                     failure:^(id result) {
                                                         [self dismissHUD];
                                                         [self showCommonHUD:result];
        
    }];
}

-(void)cancelEdit
{
    isEditing = NO;
    self.navigationItem.rightBarButtonItem = self.editItem;
    
    /*  
        此处需给所有空间内容赋原来的值
     */
    [self returnControlValue];
    [self setControlState];
}

-(void)change
{
    isEditing = YES;
    NSLog(@"%d",[self.comPanyTF becomeFirstResponder]);
    [self.comPanyTF becomeFirstResponder];
    self.navigationItem.rightBarButtonItem = self.cancelItem;
    [self setControlState];

}

//还原信息
-(void)returnControlValue
{
    self.comPanyTF.text = self.modelCompany.name;
    self.addressTF.text = self.modelCompany.addressDetails;
    [self.areaBtn setTitle:self.modelCompany.manageArea forState:UIControlStateNormal];
    self.nameTF.text = self.modelCompany.contactName;
    self.phoneTF.text = self.modelCompany.contactMobile;
}

//刷新控件的状态，是否可编辑
-(void)setControlState
{
    self.comPanyTF.enabled = isEditing;
    self.addressTF.enabled = isEditing;
    self.areaBtn.enabled = isEditing;
    self.nameTF.enabled = isEditing;
    self.phoneTF.enabled = isEditing;
    self.saveBtn.hidden = !isEditing;
    
}

- (IBAction)ChooseAreaAction:(id)sender {
    
    [self resign];
    [self.view bringSubviewToFront:self.secondView];
}

- (IBAction)saveAction:(id)sender {
    
     UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认保存?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveChangeToServer];
    }]];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self returnControlValue];
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)saveChangeToServer
{
    [self showDownloadsHUD:@"提交中..."];
    self.modelCompany.name = self.comPanyTF.text;
    self.modelCompany.addressDetails = self.addressTF.text;
    self.modelCompany.manageArea = self.areaBtn.titleLabel.text;
    self.modelCompany.contactName = self.nameTF.text;
    self.modelCompany.contactMobile = self.phoneTF.text;

    [[PNetworkManage sharedManager]editCompanyInfoByObject:self.modelCompany
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



-(void)resign
{
    [self.comPanyTF resignFirstResponder];
    [self.addressTF resignFirstResponder];
    [self.nameTF resignFirstResponder];
    [self.phoneTF resignFirstResponder];
    
}

-(void)setAreaValue:(NSString *)areaValue
{
    if (![_areaValue isEqualToString:areaValue]) {
        _areaValue = areaValue;
        self.areaLab.text = areaValue;
        
        //        [self.areaBtn setTitle:areaValue forState:UIControlStateNormal];
    }
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

//- (BOOL)becomeFirstResponder
//{
//    [super becomeFirstResponder];
//    NSLog(@"%d",[self.comPanyTF becomeFirstResponder]);
//    return [self.comPanyTF becomeFirstResponder];
//}


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
