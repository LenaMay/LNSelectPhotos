//
//  UIImageViewTap.h
//  Momento
//
//  Created by Michael Waterfall on 04/11/2009.
//  Copyright 2009 d3i. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BJNTapDetectingImageViewDelegate;

@interface BJNTapDetectingImageView : UIImageView {}

@property (nonatomic, weak) id <BJNTapDetectingImageViewDelegate> tapDelegate;

@end

@protocol BJNTapDetectingImageViewDelegate <NSObject>

@optional

- (void)imageView:(UIImageView *)imageView singleTapDetected:(UIGestureRecognizer *)gest;
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UIGestureRecognizer *)gest;
- (void)imageView:(UIImageView *)imageView tripleTapDetected:(UIGestureRecognizer *)gest;
- (void)imageView:(UIImageView *)imageView longPressDetected:(UIGestureRecognizer *)gest;

@end
