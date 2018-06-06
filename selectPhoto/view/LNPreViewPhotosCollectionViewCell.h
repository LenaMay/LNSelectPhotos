//
//  LNPreViewPhotosCollectionViewCell.h
//  selectPhotos
//
//  Created by Lina on 2018/6/4.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNSelectPhoto.h"

@interface LNPreViewPhotosCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *imageView;
-(void)getImageWithAsset:(PHAsset *)asset;
@end
