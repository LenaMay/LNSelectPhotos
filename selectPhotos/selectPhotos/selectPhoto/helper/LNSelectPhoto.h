//
//  LNSelectPhoto.h
//  selectPhotos
//
//  Created by Lina on 2018/5/31.
//  Copyright © 2018年 Lina. All rights reserved.
//

#define __WeakSelf__  __weak typeof (self)
#define weakifyself __WeakSelf__ wSelf = self;
#define __StrongSelf__  __strong typeof (self)
#define strongifyself __StrongSelf__ self = wSelf;

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "LNPhotoSelectManager.h"
#import "LNPhotoModel.h"
#import "LNAlbumModel.h"
#import "LNPhotoManager.h"
#import "LNAlbumInfoManager.h"
#import "LNPhotoSelectManager.h"
