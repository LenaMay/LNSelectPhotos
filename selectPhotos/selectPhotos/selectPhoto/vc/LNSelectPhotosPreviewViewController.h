//
//  LNSelectPhotosPreviewViewController.h
//  selectPhotos
//
//  Created by Lina on 2018/5/31.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNSelectPhoto.h"


@interface LNSelectPhotosPreviewViewController : UIViewController
@property (nonatomic, strong) LNAlbumModel  *model;
@property (nonatomic, assign) NSInteger currentItem;
@end
