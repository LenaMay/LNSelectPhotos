//
//  LNPhotoSelectManager.h
//  selectPhotos
//
//  Created by Lina on 2018/5/31.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNSelectPhoto.h"

typedef void (^photoArrBlock)(NSArray  *selectPhotoArray);
@interface LNPhotoSelectManager : NSObject

//对应的相册里选择的图片 {相册名：选中的照片数组}
@property (nonatomic, strong) NSDictionary *albumSelectDic;

//数组内为LNPhotoModel对象包含三个参数：photoIdentifier  照片id   photoAsset照片信息    albumIdentifier照片ID
@property (nonatomic, strong) NSArray  *selectPhotoArray;
@property (nonatomic, assign) NSInteger selectCount;
@property (nonatomic, assign)NSInteger  maxCount;
@property (nonatomic, assign)BOOL  isOnly;

@property (nonatomic, assign)BOOL  isCanEdit;
@property (nonatomic, assign)BOOL  isCanPreView;
@property (nonatomic, assign)NSInteger  type;

@property(nonatomic,copy) photoArrBlock  selectPhotosBlock;






/** 获取单例对象 PhotoManager */
+ (instancetype)sharedManager;
//所有数据置空  每一次 调用相册都要将其置空
- (void)clear;
@end
