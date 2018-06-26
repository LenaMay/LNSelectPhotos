//
//  ZoomingScrollView.h
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 14/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BJNPictureProtocol.h"
#import "BJNTapDetectingImageView.h"
#import "BJNTapDetectingView.h"

@class BJNPictueBrowser, BJNPicture, BJNCaptionView;

@interface BJNZoomingScrollView : UIScrollView <UIScrollViewDelegate, BJNTapDetectingImageViewDelegate, BJNTapDetectingViewDelegate> {

}

@property () NSUInteger index;
@property (nonatomic) id <BJNPicture> photo;
@property (nonatomic) id <BJNPicture> thumbPhoto;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong, readonly) BJNTapDetectingImageView *photoImageView;
@property (nonatomic, weak) BJNCaptionView *captionView;
@property (nonatomic, weak) UIButton *selectedButton;
@property (nonatomic, weak) BJNPictueBrowser *photoBrowser;

@property (nonatomic, copy) void(^imageDidLoadBlock)(BJNZoomingScrollView *page,id<BJNPicture> picture);

- (void)displayThumbImage;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)displayImage;
- (void)adjustMaxMinZoomScalesForCurrentBounds;
- (void)displayImageFailure;
- (void)prepareForReuse;

@end
