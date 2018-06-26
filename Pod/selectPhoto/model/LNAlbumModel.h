//
//  LNAlbumModel.h
//  selectPhotos
//
//  Created by Lina on 2018/5/30.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>


@interface LNAlbumModel : NSObject
@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, strong)NSString  *albumIdentifier;//相册ID
@property (nonatomic, strong)PHFetchResult *assetsResult;
@end
