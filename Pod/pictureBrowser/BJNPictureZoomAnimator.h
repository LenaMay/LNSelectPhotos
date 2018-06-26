//
//  BJPictureAnimator.h
//  BJEducation_student
//
//  Created by binluo on 15/5/18.
//  Copyright (c) 2015年 Baijiahulian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BJNPictureZoomAnimator;

@protocol BJPictureZoomAnimatorDelegate <NSObject>

- (UIView *)fromViewForAnimator:(BJNPictureZoomAnimator *)animator;
- (UIInterfaceOrientation)fromOrientationForAnimator:(BJNPictureZoomAnimator *)animator;

- (UIView *)toViewForAnimator:(BJNPictureZoomAnimator *)animator;
- (UIInterfaceOrientation)toOrientationForAnimator:(BJNPictureZoomAnimator *)animator;

@end

@interface BJNPictureZoomAnimator : NSObject <UIViewControllerAnimatedTransitioning>

/**
 The direction of the animation.
 */
@property (nonatomic, assign) BOOL reverse;

/**
 The animation duration.
 */
@property (nonatomic, assign) NSTimeInterval duration;

@property (nonatomic, strong) UIImage *fromImage;

@property (nonatomic, weak) id<BJPictureZoomAnimatorDelegate> delegate;

@end
