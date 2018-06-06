//
//  LNPreViewBottomImageView.m
//  selectPhotos
//
//  Created by Lina on 2018/6/4.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import "LNPreViewBottomImageView.h"
@interface LNPreViewBottomImageView()
@property (nonatomic, strong) UIImageView  *imageView;
@end
@implementation LNPreViewBottomImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView{
  
    [self.layer setMasksToBounds:YES];
    [self.layer setBorderColor:[UIColor clearColor].CGColor];
    [self.layer setBorderWidth:2];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    _imageView.userInteractionEnabled = YES;
    [self addSubview:_imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
    
}
- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    if (_isSelect) {
        [self.layer setBorderColor:[UIColor colorWithRed:255 green:108 blue:0 alpha:1].CGColor];
    }else{
        [self.layer setBorderColor:[UIColor clearColor].CGColor];
    }
}

- (void)setModel:(LNPhotoModel *)model{
      _model = model;
        [[LNAlbumInfoManager sharedManager] getOriginImageWithAsset:model.assetsResult completionBlock:^(UIImage *result) {
            if(result){
                self.imageView.image = result;
            }
        }];
}

- (void)tapAction{
    if (_isSelect) {
        return;
    }else{
        if(self.selectBlock){
           self.selectBlock(self);
        }
    }
}


@end
