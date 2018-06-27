//
//  ViewController.m
//  selectPhotos
//
//  Created by Lina on 2018/5/29.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import "ViewController.h"
#import "LNPhotoAlbumListViewController.h"
#import "LNPhotoManager.h"//选择照片
#import "BJNPictueBrowser.h"//照片预览

@interface ViewController ()<BJNPictureBrowserDelegate>
@property (nonatomic, strong) NSArray  *imageArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button  =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(200, 64, 100, 100)];
    [button setBackgroundColor:[UIColor redColor]];

    
    [button addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)btnAction{
    [LNPhotoManager  selectPhotsWithCount:10 type:LNPhotoManagerTypeCameraCanEdit photoArrBlock:^(NSArray *selectPhotoArray) {
        [self setupView:selectPhotoArray];
    }];

//    LNPhotoAlbumListViewController * vc = [[LNPhotoAlbumListViewController alloc]init];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
//    [self presentViewController:nav animated:NO completion:^{
//
//    }];
}

- (void)setupView:(NSArray *)imageArray{
    self.imageArray = imageArray;
    for (int i = 0; i<imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 40 * i + 50, 50, 50)];
        imageView.image = imageArray[i];
        [self.view addSubview:imageView];
        imageView.tag = 100 + i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imagetap:)];
        [imageView addGestureRecognizer:tap];
        [imageView setUserInteractionEnabled:YES];
    }
    
}


- (void)imagetap:(UITapGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag - 100;
    BJNPictueBrowser *browser = [[BJNPictueBrowser alloc] initWithDelegate:self];
    [browser setCurrentPhotoIndex:index];
    [browser presentInViewController:self completion:nil];
    
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(BJNPictueBrowser *)photoBrowser {
    return _imageArray.count;
}

- (id <BJNPicture>)photoBrowser:(BJNPictueBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _imageArray.count){
        UIImage *image = [_imageArray objectAtIndex:index];
        BJNPicture *pic = [[BJNPicture alloc] initWithImage:image];
        return pic;
    }
    return nil;
}

- (id <BJNPicture>)photoBrowser:(BJNPictueBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _imageArray.count){
        UIImage *image = [_imageArray objectAtIndex:index];
        BJNPicture *pic = [[BJNPicture alloc] initWithImage:image];
        return pic;
    }
    return nil;
}
- (UIView *)photoBrowser:(BJNPictueBrowser *)photoBrowser thumbImageViewAtIndex:(NSUInteger)index
{
    return  nil;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
