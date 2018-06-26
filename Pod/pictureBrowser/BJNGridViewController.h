//
//  MWGridViewController.h
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 08/10/2013.
//
//

#import <UIKit/UIKit.h>
#import "BJNPictueBrowser.h"

@interface BJNGridViewController : UICollectionViewController {}

@property (nonatomic, assign) BJNPictueBrowser *browser;
@property (nonatomic) BOOL selectionMode;
@property (nonatomic) CGPoint initialContentOffset;

@end
