//
//  LNPhotoModel.h
//  selectPhotos
//
//  Created by Lina on 2018/5/31.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface LNPhotoModel : NSObject
@property (nonatomic, copy) NSString * photoIdentifier;
@property (nonatomic, strong)UIImage *image;//原图
@property (nonatomic, copy)NSString  *albumIdentifier;//相册ID
@property (nonatomic, strong)PHAsset *assetsResult;
@end
