//
//  LNPhotoSelectManager.m
//  selectPhotos
//
//  Created by Lina on 2018/5/31.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import "LNPhotoSelectManager.h"
#import "LNSelectPhoto.h"

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
    _selectPhotoArray = nil;
    _selectCount = 0;
    _maxCount = 0;
    _isCanEdit = NO;
    _isCanPreView = NO;
    _type = 0;

}

- (LNPhotoModel *)modelWithPhotoIdentifier:(NSString *)photoIdentifier{
    LNPhotoModel *model = nil;
    NSArray *array = self.selectPhotoArray;
    for (int i = 0; i<array.count; i++) {
        LNPhotoModel *pmodel = array[i];
        if ([pmodel.photoIdentifier isEqualToString:photoIdentifier]) {
            model = pmodel;
        }
    }
    return  model;
}

@end
