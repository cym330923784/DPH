//
//  ReasonSelectView.m
//  DPH
//
//  Created by Cym on 16/3/5.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "ReasonSelectView.h"
#import "ReasonCell.h"
#import "PNetworkOrder.h"
#import <MBProgressHUD.h>

#define kViewWidth 300.0f
//#define kAlertHeight 230.0f

@interface ReasonSelectView()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    CGFloat kViewHeight;
    NSInteger type;
}

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)UITextView * textView;
@property (nonatomic, strong)UIButton * leftBtn;
@property (nonatomic, strong)UIButton * rightBtn;
@property (nonatomic, strong)UILabel * titleLab;
@property (nonatomic, strong) UIView *backImageView;

@property (nonatomic, strong)NSArray * reasonArr;
@property (nonatomic, strong)NSString * orderId;
@property (nonatomic, strong)NSMutableArray * tempArr;


@end

@implementation ReasonSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithTitle:(NSString *)titleText
          reasonArr:(NSArray*)reasonArr
            typeNum:(NSInteger)typeNum
            orderId:(NSString *)orderId

{
    if (self = [super init]) {
        self.tempArr = [NSMutableArray array];
        type = typeNum;
        self.orderId = orderId;
        self.reasonArr = [NSArray arrayWithArray:reasonArr];
        kViewHeight = 10+20+5+40*reasonArr.count+85+40;
        
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor whiteColor];
        //标题
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, kViewWidth, 20)];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.text = titleText;
        [self addSubview:self.titleLab];
        //理由列表

        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 35, kViewWidth, 40*reasonArr.count)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.rowHeight = 40;
        [self addSubview:self.tableView];
        
        //textview
        
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 35+40*reasonArr.count+5, kViewWidth-20, 80)];
        self.textView.backgroundColor = [UIColor colorWithHexString:@"F0F0F0"];
        self.textView.delegate = self;
        self.textView.text = @"请输入其他原因";
        self.textView.textColor = [UIColor lightGrayColor];
        [self addSubview:self.textView];

        
        CGRect leftBtnFrame;
        CGRect rightBtnFrame;
#define kCoupleButtonWidth 100.0f
#define kButtonHeight 35.0f
#define kButtonBottomOffset 10.0f

        //底部两个btn
        leftBtnFrame = CGRectMake(0, kViewHeight - kButtonHeight, kViewWidth/2, kButtonHeight);
        rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame), kViewHeight - kButtonHeight, kViewWidth/2, kButtonHeight);
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftBtn.frame = leftBtnFrame;
        self.rightBtn.frame = rightBtnFrame;

        [self.rightBtn setBackgroundColor:[UIColor whiteColor]];
        [self.leftBtn setBackgroundColor:[UIColor whiteColor]];
        
        [self.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        
        self.leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.leftBtn setTitleColor:[UIColor colorWithHexString:@"3CA0E6"] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor colorWithHexString:@"3CA0E6"] forState:UIControlStateNormal];
        
        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.leftBtn.layer.masksToBounds = self.rightBtn.layer.masksToBounds = YES;
        self.leftBtn.layer.cornerRadius = self.rightBtn.layer.cornerRadius = 3.0;
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];

        
    }
   
    
    return self;
}

- (void)show
{
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kViewWidth) * 0.5, - kViewHeight - 30, kViewWidth, kViewHeight);
    [topVC.view addSubview:self];
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!self.backImageView) {
        self.backImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.backImageView.backgroundColor = [UIColor blackColor];
        self.backImageView.alpha = 0.6f;
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    [topVC.view addSubview:self.backImageView];
    self.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kViewWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - kViewHeight) * 0.3, kViewWidth, kViewHeight);
    self.transform = CGAffineTransformMakeRotation(0);
    self.frame = afterFrame;
    [super willMoveToSuperview:newSuperview];
    //    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
    //        self.transform = CGAffineTransformMakeRotation(0);
    //        self.frame = afterFrame;
    //    } completion:^(BOOL finished) {
    //    }];
    //    [super willMoveToSuperview:newSuperview];
}



- (void)leftBtnClicked:(id)sender
{
    [self dismissAlert];
//    if (self.leftBlock) {
//        self.leftBlock();
//    }
}

- (void)rightBtnClicked:(id)sender
{
    

    [self dismissAlert];
    NSLog(@"%ld   %@",(long)type,self.orderId);
    NSString * reasonStr = [AppUtils putArrToString:self.tempArr];
    
//    if (type == 1) {
//        //退回
//        [[PNetworkOrder sharedManager]backDeliveryOrderByOrder:self.orderId
//                                                        userId:[UserDefaultUtils valueWithKey:@"branchUserId"]
//                                                        reason:reasonStr
//                                                       success:^(id result) {
//                                                           [self showCommonHUD:@"提交成功!"];
//                                                           
//                                                       }
//                                                       failure:^(id result) {
//                                                           [self showCommonHUD:@"提交失败"];
//                                                       }];
//
//    }
//    else
//    {
//        //移除
//        
//        
//    }
    
    
    //将理由用逗号隔开按字符串传给后台
    
    
    
    
    if (self.rightBlock) {
        self.rightBlock(reasonStr);
    }
}

- (void)dismissAlert
{
    [self removeFromSuperview];
//    if (self.dismissBlock) {
//        self.dismissBlock();
//    }
}

- (void)removeFromSuperview
{
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
    UIViewController *topVC = [self appRootViewController];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kViewWidth) * 0.5, CGRectGetHeight(topVC.view.bounds), kViewWidth, kViewHeight);
    self.frame = afterFrame;
    [super removeFromSuperview];
}



#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.reasonArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReasonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"reasonCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ReasonCell" owner:self options:nil][0];
    }
    cell.reasonLab.text = self.reasonArr[indexPath.row];
//    cell.checkBtn addTarget:self action:@selector(changeCheckBtnAction:) forControlEvents:<#(UIControlEvents)#>
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    ReasonCell * thisCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!thisCell.checkBtn.selected) {
        [self.tempArr addObject:thisCell.reasonLab.text];
    }
    else
    {
        [self.tempArr removeObject:thisCell.reasonLab.text];
    }
    thisCell.checkBtn.selected = !thisCell.checkBtn.selected;
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入其他原因"]) {
        textView.text = @"";
    }
    textView.textColor = [UIColor blackColor];
    return YES;
}


-(void)showCommonHUD:(NSString *)status{
    MBProgressHUD *hud            = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode                      = MBProgressHUDModeText;
    hud.labelText                 = status;
    hud.margin                    = 10.f;
    hud.yOffset                   = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

@end
