//
//  LNPreViewBottonView.h
//  selectPhotos
//
//  Created by Lina on 2018/6/4.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNPhotoModel.h"
@protocol LNPreViewBottonViewDelegate;
@interface LNPreViewBottonView : UIView
@property (nonatomic, strong) NSString *photoIdentifier;
@property (nonatomic, weak) id<LNPreViewBottonViewDelegate>delegate;
- (void)updateInfo;
@end
@protocol LNPreViewBottonViewDelegate <NSObject>

//选中其中一张照片
- (void)preViewBottonViewImageSelectWithModel:(LNPhotoModel *)model;

//选择完成点击确认
- (void)preViewBottonViewFinishSelect;

//编辑照片
- (void)preViewEditButtonActionWithModel:(LNPhotoModel *)model;
@end
