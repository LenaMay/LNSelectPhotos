//
//  LNPhotoModel.m
//  selectPhotos
//
//  Created by Lina on 2018/5/31.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import "LNPhotoModel.h"
#import "LNSelectPhoto.h"

@implementation LNPhotoModel

- (void)setAssetsResult:(PHAsset *)assetsResult{
    
    
    _assetsResult = assetsResult;
    weakifyself
    [[LNAlbumInfoManager sharedManager] getOriginImageWithAsset:assetsResult completionBlock:^(UIImage *result) {
        strongifyself
        if(result){
            self.image = result;
        }
    }];
}

@end
