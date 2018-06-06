//
//  PhotoManager.h
//  selectPhotos
//
//  Created by Lina on 2018/5/30.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "LNSelectPhoto.h"

@interface LNAlbumInfoManager : NSObject
/** 获取单例对象 PhotoManager */
+ (instancetype)sharedManager;

/** 读取所有相册的信息 返回数组<LNAlbumModel *> */
- (void)loadAlbumInfoWithCompletionBlock:(void(^)(NSArray * albumsModelArray))completionBlock;

/** 读取某个asset的图片缩略图*/
- (void)getThumbnailImageWithAsset:(PHAsset *)asset completionBlock:(void(^)(UIImage *thumbnail))completionBlock;

/** 读取预览图片 屏幕的大小*/
- (void)getPreviewImageWithAsset:(PHAsset *)asset completionBlock:(void(^)(UIImage *result))completionBlock;

/** 读取原图图片 */
- (void)getOriginImageWithAsset:(PHAsset *)asset completionBlock:(void(^)(UIImage *result))completionBlock;
@end
