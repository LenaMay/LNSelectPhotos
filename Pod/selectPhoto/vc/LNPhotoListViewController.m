//
//  LPNhotoListViViewController.m
//  selectPhotos
//
//  Created by Lina on 2018/5/31.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import "LNPhotoListViewController.h"
#import "LNPhotoCollectionViewCell.h"
#import "LNPreViewPhotosCollectionViewCell.h"
#import "LNSelectPhotosPreviewViewController.h"
#import "LNSelectPhoto.h"
#import "MBProgressHUD.h"



@interface LNPhotoListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,LNPhotoCollectionViewCellDelegate>
@property (nonatomic, strong)UICollectionView *myCollect;
@property (nonatomic, strong)UIButton  *sureButton;
@property (nonatomic, strong)UIView  *bottomView;

@property (nonatomic, assign) BOOL isOnly;
@end

@implementation LNPhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isOnly = [[LNPhotoSelectManager sharedManager] isOnly];
    self.title = self.model.name;
    [self.view addSubview:self.myCollect];
    [self.view addSubview:self.bottomView];
    [self.bottomView setHidden:_isOnly];
    [self.view setBackgroundColor: [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1/1.0]];
    [self setNav];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.myCollect reloadData];
    NSArray *photoArr = [[LNPhotoSelectManager sharedManager] selectPhotoArray];
     [_sureButton setTitle:[NSString stringWithFormat:@"确定 (%lu/%lu)",photoArr.count,[[LNPhotoSelectManager sharedManager] maxCount]] forState:UIControlStateNormal];
     [_sureButton setEnabled:photoArr.count>0?YES:NO];
}



- (void)setNav{
    UIButton *leftBackBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftBackBtn addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, (44 - 18) / 2, 18, 18)];
    backImg.image = [UIImage imageNamed:@"LN_news_back"];
    [leftBackBtn addSubview:backImg];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBackBtn];
    self.navigationItem.leftBarButtonItem=leftItem;

    UIButton *rbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    rbutton.frame=CGRectMake(0,0,44,44);
    [rbutton setExclusiveTouch :YES];
    UILabel *backLabelr=[[UILabel alloc]initWithFrame:CGRectMake(15,0, 44, 44)];
    backLabelr.text=@"取消";
    backLabelr.font=[UIFont systemFontOfSize:16];
    backLabelr.textColor = [UIColor blackColor];
    [rbutton addSubview:backLabelr];
    rbutton.tag=101;
    [rbutton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rItem=[[UIBarButtonItem alloc]initWithCustomView:rbutton];
    self.navigationItem.rightBarButtonItem=rItem;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionView *)myCollect{
    if (!_myCollect) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat length = [[LNPhotoSelectManager sharedManager] isOnly] ?0:46;
        _myCollect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - length) collectionViewLayout:layout];
        layout.itemSize = CGSizeMake((self.view.frame.size.width - 25) / 4, (self.view.frame.size.width - 25) / 4);
        [_myCollect registerClass:[LNPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"LNPhotoCollectionViewCell"];
        _myCollect.delegate = self;
        _myCollect.dataSource = self;
        _myCollect.backgroundColor = [UIColor whiteColor];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 0;
        _myCollect.showsVerticalScrollIndicator = YES;
        _myCollect.showsHorizontalScrollIndicator = NO;
        
    }
    return _myCollect;
}

- (UIButton *)sureButton{
    if(!_sureButton){
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:108/255.0 blue:0/255.0 alpha:1/1.0];
        [_sureButton.layer setMasksToBounds:YES];
        [_sureButton.layer setCornerRadius:2];
        [_sureButton setFrame:CGRectMake(self.view.frame.size.width- 100, 7, 90, 30)];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor colorWithRed:255/255.0 green:200/255.0 blue:0/255.0 alpha:1/1.0] forState:UIControlStateDisabled];
        [_sureButton setEnabled:YES];
        [_sureButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:13]];
        [_sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [_sureButton setTitle:[NSString stringWithFormat:@"确定 (0/%lu)",[[LNPhotoSelectManager sharedManager] maxCount]] forState:UIControlStateNormal];
    }
    return _sureButton;
}

- (UIView*)bottomView{
    if(!_bottomView){
        UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 45, self.view.frame.size.width, 45)];
        bottom.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:244/255.0 alpha:1/1.0];
        [bottom addSubview:self.sureButton];
        _bottomView = bottom;
    }
  
    return _bottomView;
}

#pragma mark - Action

//返回
- (void)pressBack{
    [LNPhotoSelectManager sharedManager].selectPhotoArray = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

//取消
- (void)btnClick{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


//照片选择完成确定
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
    [self btnClick];
}

//选中照片
-(void)selectBtn:(UIButton *)sender{
    
    NSLog(@"%ld",sender.tag);
    NSArray *array = [[LNPhotoSelectManager sharedManager] selectPhotoArray];
    NSInteger max  = [[LNPhotoSelectManager sharedManager] maxCount];
    NSMutableArray *photoArr = [NSMutableArray arrayWithArray:array];
    PHAssetCollection *assetCollection =  (PHAssetCollection *)self.model.assetsResult[sender.tag - 10000];
    UIButton *button = (id)[self.view viewWithTag:sender.tag];
    if (button.selected == YES) {
        LNPhotoModel *model = [[LNPhotoSelectManager sharedManager] modelWithPhotoIdentifier:assetCollection.localIdentifier];
        if (model) {
            [photoArr removeObject:model];
            sender.selected = NO;
        }
        [[LNPhotoSelectManager sharedManager] setSelectPhotoArray:photoArr];
    }else{
        if (photoArr.count < max) {
            LNPhotoModel *model = [[LNPhotoModel alloc]init];
            model.photoIdentifier = assetCollection.localIdentifier;
            model.albumIdentifier = self.model.albumIdentifier;
            model.assetsResult = self.model.assetsResult[sender.tag - 10000];
            [photoArr addObject:model];
            sender.selected = YES;
            [[LNPhotoSelectManager sharedManager] setSelectPhotoArray:photoArr];
        }else{
            UIAlertController * alter = [UIAlertController alertControllerWithTitle:@"温馨提示"  message:@"照片选够了吆，不能再选了^_^" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alter addAction:action1];
            [self presentViewController:alter animated:YES completion:NULL];
        }
    }
    
    [_sureButton setTitle:[NSString stringWithFormat:@"确定 (%ld/%ld)",photoArr.count,[[LNPhotoSelectManager sharedManager] maxCount]] forState:UIControlStateNormal];
    [_sureButton setEnabled:photoArr.count>0?YES:NO];
    
}


#pragma mark - collectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.assetsResult.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LNPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LNPhotoCollectionViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    
    [cell getPhotoWithAsset:self.model.assetsResult[indexPath.item] andWhichOne:indexPath.item + 10000];
    PHAssetCollection *assetCollection =  (PHAssetCollection *)self.model.assetsResult[indexPath.item];
    NSArray *photoArr = [[LNPhotoSelectManager sharedManager] selectPhotoArray];
    LNPhotoModel *model = [[LNPhotoSelectManager sharedManager] modelWithPhotoIdentifier:assetCollection.localIdentifier];
    if (model) {
        cell.selectBtn.selected = YES;
    }else{
        cell.selectBtn.selected = NO;
    }
    [cell.selectBtn setHidden: [[LNPhotoSelectManager sharedManager] isOnly]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[LNPhotoSelectManager sharedManager] isCanPreView]){
        LNSelectPhotosPreviewViewController *scView = [[LNSelectPhotosPreviewViewController alloc]init];
        scView.model = self.model;
        scView.currentItem = indexPath.item;
        [self.navigationController pushViewController:scView animated:YES];
    }else{
        if (self.isOnly) {
            PHAssetCollection *assetCollection =  (PHAssetCollection *)self.model.assetsResult[indexPath.item];
            LNPhotoModel *model = [[LNPhotoModel alloc]init];
            model.photoIdentifier = assetCollection.localIdentifier;
            model.albumIdentifier = self.model.albumIdentifier;
            model.assetsResult = self.model.assetsResult[indexPath.item];
            [[LNPhotoSelectManager sharedManager] setSelectPhotoArray:@[model]];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self sureAction];
            });
        }else{
            
        }
    }
}

#pragma mark - LNPhotoCollectionViewCellDelegate



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
