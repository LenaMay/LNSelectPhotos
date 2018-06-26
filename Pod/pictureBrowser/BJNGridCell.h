//
//  MWGridCell.h
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 08/10/2013.
//
//

#import <UIKit/UIKit.h>
#import "BJNPicture.h"
#import "BJNGridViewController.h"


@interface BJNGridCell : UICollectionViewCell {}

@property (nonatomic, weak) BJNGridViewController *gridController;
@property (nonatomic) NSUInteger index;
@property (nonatomic) id <BJNPicture> photo;
@property (nonatomic) BOOL selectionMode;
@property (nonatomic) BOOL isSelected;

- (void)displayImage;

@end
