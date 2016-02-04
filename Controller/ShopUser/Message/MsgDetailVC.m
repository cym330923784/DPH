//
//  MsgDetailVC.m
//  DPH
//
//  Created by cym on 16/1/29.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "MsgDetailVC.h"

@interface MsgDetailVC ()


@property (weak, nonatomic) IBOutlet UILabel *bigTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;


@end

@implementation MsgDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
}

-(void)initData
{
    if ([self.msgType isEqualToString:@"1"]) {
        self.bigTitleLab.text = @"系统通知";
    }
    else
    {
        self.bigTitleLab.text = @"订单消息";
    }
    
    self.titleLab.text = self.modelMsg.title;
    self.contentTextView.text = self.modelMsg.content;
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
