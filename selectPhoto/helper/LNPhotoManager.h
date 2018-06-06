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

@interface LNPhotoManager : NSObject
+ (void)initWithMaxCount:(NSInteger )maxCount type:(NSInteger)type photoArrBlock:(photoArrBlock)photoArrBlock;
@end
