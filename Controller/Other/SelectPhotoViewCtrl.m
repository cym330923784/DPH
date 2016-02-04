//
//  SelectPhotoViewCtrl.m
//  YeTao
//
//  Created by cym on 15/12/8.
//  Copyright © 2015年 YeTao. All rights reserved.
//

#import "SelectPhotoViewCtrl.h"
#import "ToolPhoto.h"

@interface SelectPhotoViewCtrl ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    photoBlock myblock;
}

@end

@implementation SelectPhotoViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.delegate = self;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = nil;
    UIImage *newImage = nil;
    if (self.allowsEditing) {
        newImage = [info valueForKey:@"UIImagePickerControllerEditedImage"];
    }else{
        image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
        newImage = [ToolPhoto imageWithImage:image scaledToSize:CGSizeMake(image.size.width/4, image.size.height/4)];
    }
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
    if (myblock) {
        myblock(newImage);
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error)
    {
        NSLog(@"保存照片失败");
    }
    else
    {
        NSLog(@"保存照片成功");
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)getImage:(photoBlock)action{
    
    if (action) {
        myblock = action;
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
