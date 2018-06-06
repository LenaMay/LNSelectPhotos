//
//  LNBackBlackView.m
//  selectPhotos
//
//  Created by Lina on 2018/6/4.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import "LNBackBlackView.h"
@interface LNBackBlackView()

@end
@implementation LNBackBlackView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView{
    self.backgroundColor = [UIColor blackColor];
    [self addSubview:self.currentScroll];
    [self.currentScroll addSubview:self.currentImage];
}

- (UIScrollView *)currentScroll{
    if (!_currentScroll) {
        _currentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _currentScroll.showsVerticalScrollIndicator = NO;
        _currentScroll.showsHorizontalScrollIndicator = NO;
        _currentScroll.pagingEnabled = NO;
        _currentScroll.contentInsetAdjustmentBehavior = NO;
        [_currentScroll setBackgroundColor:[UIColor clearColor]];
        _currentScroll.maximumZoomScale=3.0;//图片的放大倍数
        _currentScroll.minimumZoomScale=1.0;//图片的最小倍率

    }
    return _currentScroll;
}

- (UIImageView *)currentImage{
     if (!_currentImage) {
         _currentImage =  [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
         _currentImage.contentMode = UIViewContentModeScaleAspectFit;
     }
    return _currentImage;
}

@end
