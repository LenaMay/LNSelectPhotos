//
//  PictureBrowserCollectionViewCell.m
//  BJEducation_student
//
//  Created by Mac_ZL on 15/5/18.
//  Copyright (c) 2015年 Baijiahulian. All rights reserved.
//

#import "BJNPictureBrowserCollectionViewCell.h"
#import "BJNZoomingScrollView.h"
@implementation BJNPictureBrowserCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _zoomView = [[BJNZoomingScrollView alloc] initWithFrame:CGRectInset(self.bounds, PADDING + 2, 0)];
        _zoomView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_zoomView];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [_zoomView prepareForReuse];
}

- (void)setBrowser:(BJNPictueBrowser *)browser
{
    _browser = browser;
    [_zoomView setPhotoBrowser:_browser];
}
- (void)setPhoto:(id<BJNPicture>)photo
{
    _photo = photo;
    [_zoomView setPhoto:photo];
}
- (void)setThumbPhoto:(id<BJNPicture>)thumbPhoto
{
    _thumbPhoto = thumbPhoto;
    [_zoomView setThumbPhoto:thumbPhoto];
    
}

- (void)displayThumbImage
{
    [_zoomView displayThumbImage];
}
- (void)displayImage
{
    [_zoomView displayImage];
}
- (void)displayImageFailure;
{
    [_zoomView displayImageFailure];
}

- (void)setImageDidLoadBlock:(void (^)(BJNPictureBrowserCollectionViewCell *, id<BJNPicture>))imageDidLoadBlock {
//    weakifyself;
//    [_zoomView setImageDidLoadBlock:^(id<BJPicture> picture) {
//        strongifyself;
//        if (imageDidLoadBlock) {
//            imageDidLoadBlock(self, picture);
//        }
//    }];
}

@end
