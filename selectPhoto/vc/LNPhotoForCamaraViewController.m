//
//  LNPhotoForCamaraViewController.m
//  selectPhotos
//
//  Created by Lina on 2018/6/6.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import "LNPhotoForCamaraViewController.h"
//导入相机框架
#import <AVFoundation/AVFoundation.h>
//将拍摄好的照片写入系统相册中，所以我们在这里还需要导入一个相册需要的头文件iOS8
#import <Photos/Photos.h>

#define KScreenWidth  [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface LNPhotoForCamaraViewController ()

@end

@implementation LNPhotoForCamaraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
