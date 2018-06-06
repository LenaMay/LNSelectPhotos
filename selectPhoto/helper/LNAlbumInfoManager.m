//
//  PhotoManager.m
//  selectPhotos
//
//  Created by Lina on 2018/5/30.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import "LNAlbumInfoManager.h"
#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "LNAlbumModel.h"
@interface LNAlbumInfoManager ()
@property (nonatomic, strong) PHCachingImageManager *cacheImageManager;
@end

@implementation LNAlbumInfoManager
+ (instancetype)sharedManager{
    static LNAlbumInfoManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LNAlbumInfoManager alloc] init];
    });
    
    return instance;
}

- (void)loadAlbumInfoWithCompletionBlock:(void (^)(NSArray *))completionBlock{
    //用来存放每个相册model
    NSMutableArray *albumModelsArray = [NSMutableArray array];
    
    //创建读取哪些相册的subType
    PHAssetCollectionSubtype subType = PHAssetCollectionSubtypeSmartAlbumVideos|PHAssetCollectionSubtypeSmartAlbumUserLibrary|PHAssetCollectionSubtypeSmartAlbumScreenshots;
    
    //1.获取所有相册的信息PHFetchResult<PHAssetCollection *>
    PHFetchResult *albumsCollection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:subType options:nil];
    
    //2.遍历albumsCollection获取每一个相册的具体信息
    __block NSUInteger max = 0;
    [albumsCollection enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //将obj转化为某个具体类型 PHAssetCollection 代表一个相册
        PHAssetCollection *collection = (PHAssetCollection *)obj;
        //创建读取相册信息的options
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        
        //读取相册里面的所有信息 PHFetchResult <PHAsset *>
        PHFetchResult *assetsResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
        
        
        if (assetsResult.count > 0) {
            //创建一个model封装这个相册的信息
            LNAlbumModel *model = [[LNAlbumModel alloc] init];
            model.name = collection.localizedTitle;//相册名
            model.albumIdentifier = collection.localIdentifier;//相册ID
            model.count = assetsResult.count; //相册里面内容的个数（多少图片或者视频）
            model.assetsResult = assetsResult; //保存这个相册的内容
            
            //简单排序把照片个数最多的放在最上面
            if (assetsResult.count>max) {
                [albumModelsArray insertObject:model atIndex:0];
                max = assetsResult.count;
            }else{
                [albumModelsArray addObject:model];
            }
        }
    }];
    //排序最多的放最上面
    
    
    
    //回调
    //completionBlock ? completionBlock(albumModelsArray) : nil;
    if (completionBlock != nil) {
        completionBlock(albumModelsArray);
    }
}


- (PHCachingImageManager *)cacheImageManager{
    if (_cacheImageManager == nil) {
        self.cacheImageManager = [[PHCachingImageManager alloc] init];
    }
    return _cacheImageManager;
}

- (void)getThumbnailImageWithAsset:(PHAsset *)asset  completionBlock:(void (^)(UIImage *))completionBlock{
    
    //创建异步读取图片的选项options
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.synchronous = NO;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    [self.cacheImageManager requestImageForAsset:asset targetSize:CGSizeMake(70*scale, 70*scale) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        //回调读取的图片
        completionBlock ? completionBlock(result) : nil;
    }];
}

- (void)getPreviewImageWithAsset:(PHAsset *)asset completionBlock:(void (^)(UIImage *))completionBlock{
    //创建异步读取图片的选项options
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.synchronous = NO;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    [self.cacheImageManager requestImageForAsset:asset targetSize:CGSizeMake(screenSize.width*scale, screenSize.height*scale) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        //回调读取的图片
        completionBlock ? completionBlock(result) : nil;
    }];
    
}

- (void)getOriginImageWithAsset:(PHAsset *)asset completionBlock:(void (^)(UIImage *))completionBlock{
    //创建异步读取图片的选项options
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = NO;
    
    [self.cacheImageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        //回调读取的图片
        completionBlock ? completionBlock(result) : nil;
    }];
}

@end
