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



@interface LNPhotoListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,LNPhotoCollectionViewCellDelegate>
@property (nonatomic, strong)UICollectionView *myCollect;
@property (nonatomic, strong)UIButton  *sureButton;
@end

@implementation LNPhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.name;
    [self.view addSubview:self.myCollect];
    [self.view addSubview:[self bottomView]];
    [self.view setBackgroundColor: [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1/1.0]];
    [self setNav];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.myCollect reloadData];
    NSArray *photoArr = [[LNPhotoSelectManager sharedManager] selectPhotoArray];
     [_sureButton setTitle:[NSString stringWithFormat:@"确定 (%ld/%ld)",photoArr.count,[[LNPhotoSelectManager sharedManager] maxCount]] forState:UIControlStateNormal];
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

- (void)pressBack{
    [LNPhotoSelectManager sharedManager].selectPhotoArray = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnClick{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
        [_sureButton setEnabled:NO];
        [_sureButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:13]];
        [_sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [_sureButton setTitle:[NSString stringWithFormat:@"确定 (0/%ld)",[[LNPhotoSelectManager sharedManager] maxCount]] forState:UIControlStateNormal];
    }
    return _sureButton;
}

- (UIView*)bottomView{
    UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 45, self.view.frame.size.width, 45)];
    bottom.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:244/255.0 alpha:1/1.0];
    [bottom addSubview:self.sureButton];
    return bottom;
}

#pragma mark - Action

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
    if (photoArr.count > 0) {
        for (int i = 0 ; i < photoArr.count; i++) {
            if ([[photoArr[i] photoIdentifier]isEqualToString:assetCollection.localIdentifier]) {
                cell.selectBtn.selected = YES;
                break;
            }else{
                cell.selectBtn.selected = NO;
            }
        }
    }
    NSLog(@"%ld",indexPath.item);
    [cell.selectBtn setHidden: [[LNPhotoSelectManager sharedManager] isOnly]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[LNPhotoSelectManager sharedManager] isOnly]) {
        
    }
    else{
        if ([[LNPhotoSelectManager sharedManager] isCanPreView]) {
            LNSelectPhotosPreviewViewController *scView = [[LNSelectPhotosPreviewViewController alloc]init];
            scView.model = self.model;
            scView.currentItem = indexPath.item;
            [self.navigationController pushViewController:scView animated:YES];
        }
    }

    
}

#pragma mark - LNPhotoCollectionViewCellDelegate

-(void)selectBtn:(UIButton *)sender{
    
    NSLog(@"%ld",sender.tag);
   NSArray *array = [[LNPhotoSelectManager sharedManager] selectPhotoArray];
   NSInteger max  = [[LNPhotoSelectManager sharedManager] maxCount];
    
    NSMutableArray *photoArr = [NSMutableArray arrayWithArray:array];
    PHAssetCollection *assetCollection =  (PHAssetCollection *)self.model.assetsResult[sender.tag - 10000];
    UIButton *button = (id)[self.view viewWithTag:sender.tag];
    if (button.selected == YES) {
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
            model.assetsResult = self.model.assetsResult[sender.tag - 10000];
            [photoArr addObject:model];
            sender.selected = YES;
            [[LNPhotoSelectManager sharedManager] setSelectPhotoArray:photoArr];
        }else{
            NSLog(@"不能选了");
        }
    }
    
    [_sureButton setTitle:[NSString stringWithFormat:@"确定 (%ld/%ld)",photoArr.count,[[LNPhotoSelectManager sharedManager] maxCount]] forState:UIControlStateNormal];
    [_sureButton setEnabled:photoArr.count>0?YES:NO];

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
