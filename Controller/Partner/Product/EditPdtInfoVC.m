//
//  EditPdtInfoVC.m
//  DPH
//
//  Created by Cym on 16/3/8.
//  Copyright © 2016年 DPH. All rights reserved.
//

#import "EditPdtInfoVC.h"

@interface EditPdtInfoVC ()


@end

@implementation EditPdtInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentTF.text = self.content;

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
