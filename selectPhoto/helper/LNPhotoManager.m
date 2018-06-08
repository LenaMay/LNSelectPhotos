//
//  LNPhotoManager.m
//  selectPhotos
//
//  Created by Lina on 2018/5/31.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import "LNPhotoManager.h"
#import "LNPhotoAlbumListViewController.h"
#import "LNSelectPhoto.h"
@interface LNPhotoManager()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end
@implementation LNPhotoManager

+ (instancetype)sharedManager{
    static LNPhotoManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LNPhotoManager alloc] init];
    });
    return instance;
}

+ (void)selectPhotsWithCount:(NSInteger )maxCount type:(LNPhotoManagerType)type photoArrBlock:(photoArrBlock)photoArrBlock{
    [[LNPhotoSelectManager sharedManager] clear];
    LNPhotoSelectManager *manager = [LNPhotoSelectManager sharedManager];
    [manager clear];
    manager.maxCount = maxCount;
    manager.type = type;
    manager.selectPhotosBlock = photoArrBlock;
    [[LNPhotoManager sharedManager] judgeType:type];
   
}

 -(void)judgeType:(LNPhotoManagerType)type{
     LNPhotoSelectManager *manager = [LNPhotoSelectManager sharedManager];
     if (type == LNPhotoManagerTypeAlbumSelectMore) {
         manager.isCanEdit = NO;
         manager.isCanPreView  = YES;
         manager.isOnly = NO;
     }
     switch (type) {
             
         case LNPhotoManagerTypeAlbumSelectMore:
             manager.isCanPreView  = YES;
             [self  loadinfo];
             break;
             
         case LNPhotoManagerTypeAlbumSelectOnly:
             manager.isCanPreView  = YES;
             manager.isOnly = YES;
             [self  loadinfo];

             break;
         case LNPhotoManagerTypeCameraNOEdit:
             [self showImagePicker];
             break;
         case LNPhotoManagerTypeCameraCanEdit:
             [self showImagePicker];
             manager.isCanEdit = YES;
             break;
             
         default:
             break;
     }
}

- (void)loadinfo{
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [LNPhotoManager  tiaozhuan];
                });
            }else{
                UIAlertController * alter = [UIAlertController alertControllerWithTitle:@"温馨提示"  message:@"请您设置允许APP访问您的相册->设置->隐私->相册" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alter addAction:action1];
                [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alter animated:YES completion:NULL];
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


 -  (void) showImagePicker {
     self.imagePicker = [[UIImagePickerController alloc] init];
     self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
     //是否允许编辑照
     [self.imagePicker setAllowsEditing:[LNPhotoSelectManager sharedManager].isCanEdit];
     self.imagePicker.delegate = self;
     [self.imagePicker setCameraDevice:UIImagePickerControllerCameraDeviceRear];
     
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        //无权限 做一个友好的提示
        UIAlertController * alter = [UIAlertController alertControllerWithTitle:@"温馨提示"  message:@"请您设置允许APP访问您的相机->设置->隐私->相机" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alter addAction:action1];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alter animated:YES completion:NULL];

    } else {
        //调用相机的代码写在这里
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self.imagePicker animated:YES completion:NULL];
    }
     
}


#pragma mark - UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSArray *array = @[image];
    [LNPhotoSelectManager sharedManager].selectPhotosBlock(array);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}




@end
