//
//  LNSelectPhotosPreviewViewController.m
//  selectPhotos
//
//  Created by Lina on 2018/5/31.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import "LNSelectPhotosPreviewViewController.h"
#import "LNBackBlackView.h"
#import "LNPreViewPhotosCollectionViewCell.h"
#import "LNPreViewBottonView.h"
#define viewAll self.view.frame.size

@interface LNSelectPhotosPreviewViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LNPreViewBottonViewDelegate>
@property (nonatomic, strong)UICollectionView *bigImageCollect;
@property (nonatomic, strong)LNBackBlackView  *blackBackView;

@property (nonatomic, strong)UIView  *headerView;
@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, strong)LNPreViewBottonView  *bottomView;
@property (nonatomic, assign) CGFloat currentX;



@end

@implementation LNSelectPhotosPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = YES;
    _currentItem=_currentItem>0?_currentItem:0;
    
    [self.view addSubview:self.bigImageCollect];
    [self.bigImageCollect addSubview:self.blackBackView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.bottomView];
    [self updateSelectStatus];


}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

}

- (UICollectionView *)bigImageCollect{
    
    if(!_bigImageCollect){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _bigImageCollect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
        layout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        [_bigImageCollect registerClass:[LNPreViewPhotosCollectionViewCell class] forCellWithReuseIdentifier:@"myCell"];
        _bigImageCollect.delegate = self;
        _bigImageCollect.dataSource = self;
        _bigImageCollect.backgroundColor = [UIColor blackColor];
        _bigImageCollect.pagingEnabled = YES;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _bigImageCollect.contentInsetAdjustmentBehavior = NO;
        _bigImageCollect.showsVerticalScrollIndicator = NO;
        _bigImageCollect.showsHorizontalScrollIndicator = NO;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressBlackBtn)];
        [_bigImageCollect addGestureRecognizer:tap];
        if(_currentItem>=0){
            [_bigImageCollect setContentOffset:CGPointMake(self.view.frame.size.width *_currentItem, 0)];
        }
        
    }
    return _bigImageCollect;
}

//用于缩放的View
- (LNBackBlackView *)blackBackView{
    if(!_blackBackView){
        _blackBackView = [[LNBackBlackView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * _currentItem, 0, self.view.frame.size.width, self.view.frame.size.height)];
        //透明按钮
        UIButton *backClearBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [backClearBtn addTarget:self action:@selector(pressBlackBtn) forControlEvents:UIControlEventTouchUpInside];
        backClearBtn.backgroundColor = [UIColor clearColor];
        [_blackBackView.currentScroll addSubview:backClearBtn];
        _blackBackView.currentScroll.delegate = self;

    }
    return _blackBackView;
}

- (UIView *)headerView{
    if(!_headerView){
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        _headerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
        [backBtn addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setImage:[UIImage imageNamed:@"LN_photoBack"] forState:UIControlStateNormal];
        [_headerView addSubview:backBtn];

        _selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 64, 0, 64, 64)];
        [_selectBtn addTarget:self action:@selector(pressSelect:) forControlEvents:UIControlEventTouchUpInside];
        [_selectBtn setImage:[UIImage imageNamed:@"LN_ic_unchecked"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"LN_ic_check"] forState:UIControlStateSelected];
        [_headerView addSubview:_selectBtn];
        [_headerView setHidden:YES];
    }
    return _headerView;
}



- (UIView *)bottomView{
    if(!_bottomView){
        _bottomView = [[LNPreViewBottonView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height -100 , self.view.frame.size.width, 100)];
        _bottomView.delegate = self;
        _bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [_bottomView setHidden:YES];

    }
    return _bottomView;
}

#pragma mark - helper

- (void)updateSelectStatus{
    
    BOOL isSelect = NO;
    NSArray *array = [[LNPhotoSelectManager sharedManager] selectPhotoArray];
    PHAssetCollection *assetCollection =  (PHAssetCollection *)self.model.assetsResult[_currentItem];
    for (int i = 0; i < [array count]; i++) {
        if ([[array[i] photoIdentifier] isEqualToString:assetCollection.localIdentifier]) {
            isSelect = YES;
        }
    }
    [self.selectBtn setSelected:isSelect];
    [self.bottomView setPhotoIdentifier:assetCollection.localIdentifier];
    
}

- (void)pressBlackBtn{
    if (_headerView.hidden == YES) {
        _headerView.hidden = NO;
        if ([[[LNPhotoSelectManager sharedManager] selectPhotoArray] count]>0) {
            _bottomView.hidden = NO;
        }
    }else{
        _headerView.hidden = YES;
        _bottomView.hidden = YES;
    }
}

- (void)pressBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)pressSelect:(UIButton *)sender{
    
    int curr = self.blackBackView.frame.origin.x / viewAll.width;
    NSArray *array = [[LNPhotoSelectManager sharedManager] selectPhotoArray];
    NSInteger max  = [[LNPhotoSelectManager sharedManager] maxCount];
    
    NSMutableArray *photoArr = [NSMutableArray arrayWithArray:array];
    PHAssetCollection *assetCollection =  (PHAssetCollection *)self.model.assetsResult[curr];
    if (sender.selected == YES) {
        for (int i = 0; i < [photoArr count]; i++) {
            if ([[photoArr[i] photoIdentifier] isEqualToString:assetCollection.localIdentifier]) {
                [photoArr removeObjectAtIndex:i];
                sender.selected = NO;
            }
        }
        [[LNPhotoSelectManager sharedManager] setSelectPhotoArray:photoArr];
    }else{
        if (photoArr.count < max) {
            LNPhotoModel *model = [[LNPhotoModel alloc]init];
            model.photoIdentifier = assetCollection.localIdentifier;
            model.albumIdentifier = self.model.albumIdentifier;
            model.assetsResult = self.model.assetsResult[curr];
            [photoArr addObject:model];
            sender.selected = YES;
            [[LNPhotoSelectManager sharedManager] setSelectPhotoArray:photoArr];
        }else{
            NSLog(@"不能选了");
        }
    }
    if (photoArr.count>=1 && self.headerView.hidden == NO){
        [self.bottomView setHidden:NO];
        [self.bottomView updateInfo];
        [self.bottomView setPhotoIdentifier:assetCollection.localIdentifier];
    };
    if (photoArr.count<1) {
        [self.bottomView setHidden:YES];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:_bigImageCollect]) {
        _currentX = scrollView.contentOffset.x;
        _currentItem = scrollView.contentOffset.x / viewAll.width;
        self.blackBackView.frame = CGRectMake(scrollView.contentOffset.x,scrollView.frame.origin.y,scrollView.frame.size.width,scrollView.frame.size.height);
        self.blackBackView.currentScroll.zoomScale = 1.0;
        weakifyself
        [[LNAlbumInfoManager  sharedManager] getOriginImageWithAsset:[self.model.assetsResult objectAtIndex:scrollView.contentOffset.x / viewAll.width] completionBlock:^(UIImage *result) {
            strongifyself
            if (result) {
                [self.blackBackView.currentImage setImage:result];
            }else{
                [self.blackBackView.currentImage setImage:[UIImage imageNamed:@"noimage"]];
            }
            [self.bigImageCollect bringSubviewToFront:self.blackBackView];
            self.blackBackView.hidden = NO;
            self.blackBackView.currentImage.clipsToBounds = YES;
        }];
        [self updateSelectStatus];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual:_bigImageCollect]) {
        
        float aaa = ABS(scrollView.contentOffset.x - _currentX);
        
        if (aaa > viewAll.width / 2) {
            self.blackBackView.currentImage.image = nil;
            self.blackBackView.hidden = YES;
        }
    }
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.blackBackView.currentImage;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    //scrollView放大代理
    if (scrollView != _bigImageCollect) {
        CGPoint uiii;
        if (scrollView.contentSize.width>scrollView.frame.size.width) {
            uiii.x = scrollView.contentSize.width/2.0;
        }else{
            uiii.x = scrollView.frame.size.width/2.0;
        }
        if (scrollView.contentSize.height>scrollView.frame.size.height) {
            uiii.y = scrollView.contentSize.height/2.0;
        }else{
            uiii.y = scrollView.frame.size.height/2.0;
        }
        self.blackBackView.currentImage.center= uiii;
    }
}




#pragma mark - collectinoDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.assetsResult.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LNPreViewPhotosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    [cell getImageWithAsset:self.model.assetsResult[indexPath.item]];
    return cell;
}

#pragma mark LNPreViewBottonViewDelegate

-(void)preViewBottonViewImageSelectWithModel:(LNPhotoModel *)model{
    NSInteger index = 0;
    for (int i = 0; i<self.model.assetsResult.count; i++) {
        PHAssetCollection *assetCollection =  (PHAssetCollection *)self.model.assetsResult[i];
        if([model.photoIdentifier isEqualToString:assetCollection.localIdentifier]){
            index = i;
        }
    }
    _currentItem = index;
    if(_currentItem>=0){
        [_bigImageCollect setContentOffset:CGPointMake(self.view.frame.size.width *_currentItem, 0)];
        self.blackBackView.frame = CGRectMake(_bigImageCollect.contentOffset.x,_bigImageCollect.frame.origin.y,_bigImageCollect.frame.size.width,_bigImageCollect.frame.size.height);
        PHAssetCollection *assetCollection =  (PHAssetCollection *)self.model.assetsResult[_currentItem];
        self.bottomView.photoIdentifier = assetCollection.localIdentifier;
    }
    [self updateSelectStatus];
}

- (void)preViewBottonViewBack{
    [self pressBack];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
