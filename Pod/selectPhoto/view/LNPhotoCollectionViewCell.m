//
//  myPhotoCollectionViewCell.m
//  CH999
//
//  Created by Archer on 2017/2/9.
//  Copyright © 2017年 ch999.com. All rights reserved.
//

#import "LNPhotoCollectionViewCell.h"
#import "LNSelectPhoto.h"

#define allScreen [UIScreen mainScreen].bounds.size


@implementation LNPhotoCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCellUI];
    }
    return self;
}


-(void)createCellUI{
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (allScreen.width - 25) / 4, (allScreen.width - 25) / 4)];
    
    _selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(_imageView.frame.size.width - 25, 0, 25, 25)];
    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"LN_ic_unchecked"] forState:UIControlStateNormal];
    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"LN_ic_check"] forState:UIControlStateSelected];
    [_selectBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_imageView addSubview:_selectBtn];
    
    [self.contentView addSubview:_imageView];
}


-(void)getPhotoWithAsset:(PHAsset *)myAsset andWhichOne:(NSInteger)which{
    self.which = which;
    
    _selectBtn.tag = which;
    PHImageRequestOptions *reques = [[PHImageRequestOptions alloc]init];
    reques.synchronous = NO;
    reques.networkAccessAllowed = NO;
    reques.resizeMode = PHImageRequestOptionsResizeModeExact;
    reques.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    weakifyself
    [[PHImageManager defaultManager] requestImageForAsset:myAsset targetSize:CGSizeMake(allScreen.width/4, allScreen.height/4) contentMode:PHImageContentModeAspectFill options:reques resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        strongifyself
        if (result) {
            self.imageView.image = result;
        }else{
            self.imageView.image = [UIImage imageNamed:@"noimage"];
        }
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        self.imageView.userInteractionEnabled = YES;
        
    }];
}


-(void)pressBtn:(UIButton *)button{
    if ([_delegate respondsToSelector:@selector(selectBtn:)]) {
        [_delegate selectBtn:button];
    }
}

@end
