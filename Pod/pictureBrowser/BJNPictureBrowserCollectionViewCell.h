//
//  PictureBrowserCollectionViewCell.h
//  BJEducation_student
//
//  Created by Mac_ZL on 15/5/18.
//  Copyright (c) 2015年 Baijiahulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BJNPictureProtocol.h"
#import "BJNPictureCommon.h"
@class BJNZoomingScrollView;
@class BJNCaptionView;
@class BJNPictueBrowser;
@interface BJNPictureBrowserCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) BJNZoomingScrollView  *zoomView;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic) id <BJNPicture> photo;
@property (nonatomic) id <BJNPicture> thumbPhoto;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, weak) BJNCaptionView *captionView;
@property (nonatomic, weak) UIButton *selectedButton;
@property (nonatomic,assign) BJNPictueBrowser *browser;

@property (nonatomic, copy) void(^imageDidLoadBlock)(BJNPictureBrowserCollectionViewCell *cell, id<BJNPicture> picture);

- (void)displayImage;
- (void)displayImageFailure;
- (void)displayThumbImage;
@end
