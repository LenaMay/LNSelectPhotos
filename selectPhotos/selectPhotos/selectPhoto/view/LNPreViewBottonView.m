//
//  LNPreViewBottonView.m
//  selectPhotos
//
//  Created by Lina on 2018/6/4.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import "LNPreViewBottonView.h"
#import "LNPreViewBottomImageView.h"
@interface LNPreViewBottonView()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton  *sureButton;
@property (nonatomic, strong) NSMutableArray  *imageViewArray;


@end
@implementation LNPreViewBottonView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
        _photoIdentifier = @"";
        _imageViewArray = [NSMutableArray array];
    }
    return self;
}

- (void)setUpView{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 15,self.frame.size.width -110, 70)];
    [_scrollView setUserInteractionEnabled:YES];
    [self addSubview:_scrollView];
    [self addSubview:self.sureButton];
    [self updateInfo];
    
    
}

- (void)updateInfo{
    
    NSArray *array = [LNPhotoSelectManager sharedManager].selectPhotoArray;
    [_scrollView setContentSize:CGSizeMake(array.count *80, 70)];
    CGFloat offSizeX = _scrollView.contentOffset.x;
//    for (LNPreViewBottomImageView *view in _scrollView.subviews) {
//        if ([view isMemberOfClass:[LNPreViewBottomImageView class]]) {
//            [view removeFromSuperview];
//        }
//    }
    
    if (_imageViewArray.count >= array.count) {
        for (int i = 0; i<_imageViewArray.count; i++) {
            LNPreViewBottomImageView *view = _imageViewArray[i];
            [view setFrame:CGRectMake(80*i,0, 70, 70)];
            if (i < array.count) {
                LNPhotoModel *model = array[i];
                BOOL isSelect = NO;
                if([model.photoIdentifier isEqualToString:_photoIdentifier]){
                    isSelect = YES;
                }
                view.tag = 1000 + i;
                view.isSelect = isSelect;
                view.model = model;
            }else{
                [self.imageViewArray removeObject:view];
                [view removeFromSuperview];
            }
        }
    }else{
        for (int i = 0; i<array.count; i++) {
            if (i < _imageViewArray.count) {
                LNPreViewBottomImageView *view = _imageViewArray[i];
                [view setFrame:CGRectMake(80*i,0, 70, 70)];
                LNPhotoModel *model = array[i];
                BOOL isSelect = NO;
                if([model.photoIdentifier isEqualToString:_photoIdentifier]){
                    isSelect = YES;
                }
                view.tag = 1000 + i;
                view.isSelect = isSelect;
                view.model = model;
            }else{
                LNPreViewBottomImageView *view = [[LNPreViewBottomImageView alloc]initWithFrame:CGRectMake(80*i,0, 70, 70)];
                BOOL isSelect = NO;
                LNPhotoModel *model = array[i];
                if([model.photoIdentifier isEqualToString:_photoIdentifier]){
                    isSelect = YES;
                }
                view.tag = 1000 + i;
                view.isSelect = isSelect;
                view.model = array[i];
                [view setSelectBlock:^(LNPreViewBottomImageView *view) {
                    [self selectBlockAction:view];
                }];
                [self.scrollView addSubview:view];
                [self.imageViewArray addObject:view];
            }
        }
    }
//    for ( int i = 0; i<array.count; i++) {
//        LNPreViewBottomImageView *view = [[LNPreViewBottomImageView alloc]initWithFrame:CGRectMake(80*i,0, 70, 70)];
//        BOOL isSelect = NO;
//        LNPhotoModel *model = array[i];
//        if([model.photoIdentifier isEqualToString:_photoIdentifier]){
//                isSelect = YES;
//        }
//        view.tag = 1000 + i;
//        view.isSelect = isSelect;
//        view.model = array[i];
//        [view setSelectBlock:^(LNPreViewBottomImageView *view) {
//
//        }];
//        [self.scrollView addSubview:view];
//    }
    _scrollView.contentOffset =  CGPointMake(offSizeX,0);
    [_sureButton setTitle:[NSString stringWithFormat:@"确定 (%ld/%ld)",array.count,[[LNPhotoSelectManager sharedManager] maxCount]] forState:UIControlStateNormal];
    if(array.count>0){
        [_sureButton setEnabled:YES];
    }else{
        [_sureButton setEnabled:NO];
    }

}

-(void)selectBlockAction:(LNPreViewBottomImageView *)view{
    if (self.delegate && [self.delegate respondsToSelector:@selector(preViewBottonViewImageSelectWithModel:)]) {
        [self.delegate preViewBottonViewImageSelectWithModel:view.model];
    }
}


- (void)setPhotoIdentifier:(NSString *)photoIdentifier{
    _photoIdentifier = photoIdentifier;
    [self updateSelectInfo];
  
}

- (void)updateSelectInfo{
    LNPreViewBottomImageView *selectView = nil;
    for (LNPreViewBottomImageView *view in _scrollView.subviews) {
        if ([view isMemberOfClass:[LNPreViewBottomImageView class]]) {
            LNPreViewBottomImageView *imaView = (LNPreViewBottomImageView *)view;
            if ([imaView.model.photoIdentifier isEqualToString:self.photoIdentifier]) {
                [imaView setIsSelect:YES];
                selectView = imaView;
            }else{
                [imaView setIsSelect:NO];
            }
        }
    }
    
    if (selectView) {
        NSInteger index = selectView.tag - 1000;
        if(self.scrollView.contentOffset.x>index*80){
            [self.scrollView setContentOffset:CGPointMake(80*index, 0)];
        }
        if(self.scrollView.contentOffset.x + self.scrollView.frame.size.width - 70<index*80 )
            [self.scrollView setContentOffset:CGPointMake(80*index - (self.scrollView.frame.size.width - 70), 0)];
    }
}


- (UIButton *)sureButton{
    if(!_sureButton){
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:108/255.0 blue:0/255.0 alpha:1/1.0];
        [_sureButton.layer setMasksToBounds:YES];
        [_sureButton.layer setCornerRadius:2];
        [_sureButton setFrame:CGRectMake(self.frame.size.width- 95, 35, 80, 30)];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor colorWithRed:255/255.0 green:200/255.0 blue:0/255.0 alpha:1/1.0] forState:UIControlStateDisabled];
        [_sureButton setEnabled:NO];
        [_sureButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:13]];
        [_sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (void)sureAction{
    
    NSArray *array = [LNPhotoSelectManager sharedManager].selectPhotoArray;
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 0; i<array.count; i++) {
        LNPhotoModel *model = array[i];
        if (model.image) {
            [imageArray addObject:model.image];
        }
    }
    if ([LNPhotoSelectManager sharedManager].selectPhotosBlock) {
        [LNPhotoSelectManager sharedManager].selectPhotosBlock(imageArray);
    }
    if (self.delegate &&[self.delegate respondsToSelector:@selector(preViewBottonViewBack)]) {
        [self.delegate preViewBottonViewBack];
    }
}




@end
