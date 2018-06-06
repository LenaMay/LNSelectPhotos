//
//  LNPhotoSelectManager.m
//  selectPhotos
//
//  Created by Lina on 2018/5/31.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import "LNPhotoSelectManager.h"

@implementation LNPhotoSelectManager
+ (instancetype)sharedManager{
    static LNPhotoSelectManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LNPhotoSelectManager alloc] init];
    });
    return instance;
}

- (void)clear{
    _albumSelectDic = nil;
    _selectPhotoArray = nil;
    _selectCount = 0;
    _maxCount = 0;
    _isCanEdit = NO;
    _isCanPreView = NO;
    _type = 0;
}

@end
