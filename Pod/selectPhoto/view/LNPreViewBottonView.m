//
//  LNPreViewBottonView.m
//  selectPhotos
//
//  Created by Lina on 2018/6/4.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import "LNPreViewBottonView.h"
#import "LNPreViewBottomImageView.h"
#import "LNSelectPhoto.h"
#import "LNClipsViewController.h"


@interface LNPreViewBottonView()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton  *sureButton;
@property (nonatomic, strong) UIButton  *editButton;
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
    
    BOOL isCanEdit = [[LNPhotoSelectManager sharedManager] isCanEdit];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 15,self.frame.size.width -110 - (isCanEdit?90:0), 70)];
    [_scrollView setUserInteractionEnabled:YES];
    [self addSubview:_scrollView];
    [self addSubview: self.editButton];
    [self.editButton setHidden:!isCanEdit];
    [self addSubview:self.sureButton];
    [self updateInfo];
    
    
}

- (void)updateInfo{
    
    NSArray *array = [LNPhotoSelectManager sharedManager].selectPhotoArray;
    [_scrollView setContentSize:CGSizeMake(array.count *80, 70)];
    CGFloat offSizeX = _scrollView.contentOffset.x;
    
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
    _scrollView.contentOffset =  CGPointMake(offSizeX,0);
    [_sureButton setTitle:[NSString stringWithFormat:@"确定 (%lu/%lu)",(unsigned long)array.count,[[LNPhotoSelectManager sharedManager] maxCount]] forState:UIControlStateNormal];
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
    BOOL  isHaveSelectImage = NO;
    for (LNPreViewBottomImageView *view in _scrollView.subviews) {
        if ([view isMemberOfClass:[LNPreViewBottomImageView class]]) {
            LNPreViewBottomImageView *imaView = (LNPreViewBottomImageView *)view;
            if ([imaView.model.photoIdentifier isEqualToString:self.photoIdentifier]) {
                [imaView setIsSelect:YES];
                isHaveSelectImage = YES;
                selectView = imaView;
            }else{
                [imaView setIsSelect:NO];
            }
        }
    }
    [_editButton setEnabled:isHaveSelectImage];
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

- (UIButton *)editButton{
    if(!_editButton){
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:108/255.0 blue:0/255.0 alpha:1/1.0];
        [_editButton.layer setMasksToBounds:YES];
        [_editButton.layer setCornerRadius:2];
        [_editButton setFrame:CGRectMake(self.frame.size.width - 95 - 95, 35, 80, 30)];
        [_editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_editButton setTitleColor:[UIColor colorWithRed:255/255.0 green:200/255.0 blue:0/255.0 alpha:1/1.0] forState:UIControlStateDisabled];
        [_editButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:13]];
        [_editButton addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
    }
    return _editButton;
}

- (void)sureAction{
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(preViewBottonViewFinishSelect)]) {
        [self.delegate preViewBottonViewFinishSelect];
    }
}

- (void)editAction{
    LNPhotoModel *pmodel = [[LNPhotoSelectManager sharedManager] modelWithPhotoIdentifier:self.photoIdentifier];
    if (self.delegate && [self.delegate respondsToSelector:@selector(preViewEditButtonActionWithModel:)]) {
        [self.delegate preViewEditButtonActionWithModel:pmodel];
    }
}




@end
