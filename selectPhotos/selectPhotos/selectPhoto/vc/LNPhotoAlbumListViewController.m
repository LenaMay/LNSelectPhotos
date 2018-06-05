//
//  PhotoAlbumListViewController.m
//  selectPhotos
//
//  Created by Lina on 2018/5/29.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import "LNPhotoAlbumListViewController.h"
#import "LNAlbumModel.h"
#import "LNAlbumInfoManager.h"
#import "LNPhotoListViewController.h"




@interface LNPhotoAlbumListViewController ()
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) NSArray  *modelArray;

@end

@implementation LNPhotoAlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavInfo];
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setUpview];
                    
                });
            }else{
                NSLog(@"关闭了权限，需要授权");
                
            }
        }];
    }else if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized) {
        //授权路径
        //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }else{
        [self setUpview];
    }
}



-(void)setNavInfo{
    self.title = @"选择照片";
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0,0,44,44);
    [button setExclusiveTouch :YES];
    UILabel *backLabelr=[[UILabel alloc]initWithFrame:CGRectMake(15,0, 44, 44)];
    backLabelr.text=@"取消";
    backLabelr.font=[UIFont systemFontOfSize:16];
    backLabelr.textColor = [UIColor blackColor];
    [button addSubview:backLabelr];
    button.tag=101;
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem=rItem;
}

- (void)setUpview{
    [self.view addSubview:self.scrollView];
    weakifyself
    [[LNAlbumInfoManager sharedManager] loadAlbumInfoWithCompletionBlock:^(NSArray *albumsModelArray) {
        strongifyself
        self.modelArray = albumsModelArray;
        [self uploadView];
        [self gotoPhotolist];
    }];
    
    
}

- (void)gotoPhotolist{
    LNAlbumModel *model = self.modelArray[0];
    LNPhotoListViewController *vc  = [[LNPhotoListViewController alloc]init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:NO];
}


- (void)uploadView{
    
    for (int i = 0; i<self.modelArray.count; i++) {
        LNAlbumModel *model = self.modelArray[i];
        UIView *listView = [self creatViewWithModel:model index:i];
        [self.scrollView addSubview:listView];
    }
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.modelArray.count*60);
}



- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64,self.view.frame.size.width, self.view.frame.size.height-64)];
    }
    return _scrollView;
}



- (UIView *)creatViewWithModel:(LNAlbumModel*)model index:(NSInteger )index {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 60*index, self.view.frame.size.width, 60)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    

    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [backView addSubview:imageView];
    
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:lineLabel];

    UILabel *title = [[UILabel alloc] init];
    title.font = [UIFont fontWithName:@".PingFang-SC-Medium" size:15];
    title.textColor = [UIColor colorWithRed:61/255.0 green:61/255.0 blue:62/255.0 alpha:1/1.0];
    [backView addSubview:title];

    UILabel *count = [[UILabel alloc] init];
    count.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    count.textColor = [UIColor colorWithRed:109/255.0 green:109/255.0 blue:110/255.0 alpha:1/1.0];
    [backView addSubview:count];
    
    UIImageView *arrowImageView = [[UIImageView alloc]init];
    [backView addSubview:arrowImageView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 1000+ index;
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn addTarget:self action:@selector(photo:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(backView);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(58);
        make.height.mas_equalTo(55);
    }];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).offset(10);
        make.centerY.offset(0);
    }];
    
    [count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(title.mas_right).offset(10);
        make.centerY.offset(0);
    }];
    
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.offset(0);
    }];
    
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [arrowImageView setImage:[UIImage imageNamed:@"ic_next"]];
    [self loadLastIamgeViewWith:model.assetsResult imageView:imageView];
    [title setText:model.name];
    [count setText:[NSString stringWithFormat:@"%ld",model.count]];
    return backView;
}



- (void)loadLastIamgeViewWith:(PHFetchResult *)result imageView:(UIImageView *)imageView{
    PHAsset *asset = nil;
    if (result.count != 0) {
        asset = result[result.count-1];
    }else{
        return;
    }
    PHImageManager *imageManager = [[PHImageManager alloc] init];
    [imageManager requestImageForAsset:asset targetSize:CGSizeMake(60, 60) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            imageView.image = result;
            NSLog(@"%@", result);
        }else{
            imageView.image = [UIImage imageNamed:@"noimage"];
        }
    }];
}

- (void)photo:(UIButton *)button{
    NSInteger index = button.tag - 1000;
    LNAlbumModel *model = self.modelArray[index];
    LNPhotoListViewController *vc  = [[LNPhotoListViewController alloc]init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)btnClick{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
