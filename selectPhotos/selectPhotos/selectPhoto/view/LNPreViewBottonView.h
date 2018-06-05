//
//  LNPreViewBottonView.h
//  selectPhotos
//
//  Created by Lina on 2018/6/4.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNSelectPhoto.h"

@protocol LNPreViewBottonViewDelegate;
@interface LNPreViewBottonView : UIView
@property (nonatomic, strong) NSString *photoIdentifier;
@property (nonatomic, weak) id<LNPreViewBottonViewDelegate>delegate;
- (void)updateInfo;
@end
@protocol LNPreViewBottonViewDelegate <NSObject>
- (void)preViewBottonViewImageSelectWithModel:(LNPhotoModel *)model;
- (void)preViewBottonViewBack;
@end
