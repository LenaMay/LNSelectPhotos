//
//  LNPhotoManager.m
//  selectPhotos
//
//  Created by Lina on 2018/5/31.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import "LNPhotoManager.h"
#import "LNPhotoSelectManager.h"
#import "LNPhotoAlbumListViewController.h"

@implementation LNPhotoManager

+ (void)initWithMaxCount:(NSInteger )maxCount type:(NSInteger)type photoArrBlock:(photoArrBlock)photoArrBlock{
    [[LNPhotoSelectManager sharedManager] clear];
    LNPhotoSelectManager *manager = [LNPhotoSelectManager sharedManager];
    [manager clear];
    manager.maxCount = maxCount;
    manager.type = type;
    manager.isCanEdit = NO;
    manager.isCanPreView  = NO;
    manager.isOnly = YES;
    manager.selectPhotosBlock = photoArrBlock;
    [self loadinfo];
   
}

+ (void)loadinfo{
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [LNPhotoManager  tiaozhuan];
                });
            }else{
                NSLog(@"关闭了权限，需要授权");
            }
        }];
    }else if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized) {
        //授权路径
        //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }else{
        [LNPhotoManager  tiaozhuan];
    }
}

+ (void)tiaozhuan{
    LNPhotoAlbumListViewController * vc = [[LNPhotoAlbumListViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:nav animated:YES completion:nil];
}





@end
