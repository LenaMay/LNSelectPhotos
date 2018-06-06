//
//  LNPhotoManager.h
//  selectPhotos
//
//  Created by Lina on 2018/5/31.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "LNPhotoSelectManager.h"
typedef NS_ENUM(NSInteger, LNPhotoManagerType) {
    LNPhotoManagerTypeAlbumSelectMore = 0,//相册多选
    LNPhotoManagerTypeAlbumSelectOnly,//相册单选（待完成）
    LNPhotoManagerTypeCameraNOEdit,//相机不可编辑
    LNPhotoManagerTypeCameraCanEdit//相机可编辑
};


@interface LNPhotoManager : NSObject

//如果是相机拍照 或者单选 取数组第一个元素  block 返回的数组是UIimage类型
+ (void)selectPhotsWithCount:(NSInteger )maxCount type:(LNPhotoManagerType)type photoArrBlock:(photoArrBlock)photoArrBlock;

@end
