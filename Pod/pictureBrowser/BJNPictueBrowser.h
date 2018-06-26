//
//  MWPhotoBrowser.h
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 14/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "BJNPicture.h"
#import "BJNPictureProtocol.h"
#import "BJNCaptionView.h"
#import "BJNPictureZoomAnimator.h"

// Debug Logging
#if 0 // Set to 1 to enable debug logging
#define BJNLog(x, ...) NSLog(x, ## __VA_ARGS__);
#else
#define BJNLog(x, ...)
#endif

@class BJNPictueBrowser;

@protocol BJNPictureBrowserDelegate <NSObject>

- (NSUInteger)numberOfPhotosInPhotoBrowser:(BJNPictueBrowser *)photoBrowser;
- (id <BJNPicture>)photoBrowser:(BJNPictueBrowser *)photoBrowser photoAtIndex:(NSUInteger)index;

@optional

- (UIView *)photoBrowser:(BJNPictueBrowser *)photoBrowser thumbImageViewAtIndex:(NSUInteger)index;

- (id <BJNPicture>)photoBrowser:(BJNPictueBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index;
- (BJNCaptionView *)photoBrowser:(BJNPictueBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index;
- (NSString *)photoBrowser:(BJNPictueBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index;
- (void)photoBrowser:(BJNPictueBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index;
- (void)photoBrowser:(BJNPictueBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index;
- (BOOL)photoBrowser:(BJNPictueBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index;
- (void)photoBrowser:(BJNPictueBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected;
- (void)photoBrowserDidFinishModalPresentation:(BJNPictueBrowser *)photoBrowser;

- (void)photoBrowserWillFinishModalPresentation:(BJNPictueBrowser *)photoBrowser;


@end

@interface BJNPictueBrowser : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIViewControllerTransitioningDelegate, BJPictureZoomAnimatorDelegate>

@property (nonatomic, weak) id<BJNPictureBrowserDelegate> delegate;
@property (nonatomic) BOOL zoomPhotosToFill;
@property (nonatomic, readonly) NSUInteger currentIndex;

// Init
- (id)initWithDelegate:(id <BJNPictureBrowserDelegate>)delegate;

// Reloads the photo browser and refetches data
- (void)reloadData;

// Set page that photo browser starts on
- (void)setCurrentPhotoIndex:(NSUInteger)index;


- (void)presentInViewController:(UIViewController *)viewController
                     completion:(void (^)(void))completion;

- (void)dismissViewControllerAnimated: (BOOL)flag completion: (void (^)(void))completion;

@end
