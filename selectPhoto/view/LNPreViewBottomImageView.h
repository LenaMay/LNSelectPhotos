//
//  LNPreViewBottomImageView.h
//  selectPhotos
//
//  Created by Lina on 2018/6/4.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNSelectPhoto.h"


@interface LNPreViewBottomImageView : UIView
@property (nonatomic, assign) BOOL  isSelect;
@property (nonatomic, strong) LNPhotoModel  *model;
@property(nonatomic,copy) void (^selectBlock)(LNPreViewBottomImageView *view);
@end
