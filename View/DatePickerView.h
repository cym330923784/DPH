//
//  DatePickerView.h
//  YeTao
//
//  Created by cym on 15/12/16.
//  Copyright © 2015年 YeTao. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DatePickerView : UIView
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic)NSDate * userDate;

-(id)init;
-(void)show;



@end
