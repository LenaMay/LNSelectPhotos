//
//  LNClipsViewController.m
//  selectPhotos
//
//  Created by Lina on 2018/6/26.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import "LNClipsViewController.h"
#import "JPImageresizerView.h"

@interface LNClipsViewController ()
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIImageView  *imageView;
@property (nonatomic, assign) CGSize  imagedefaultSize;
@property (nonatomic, strong) UIButton  *cutButton;
@property (nonatomic, strong) UIButton  *recoveryBtn;//重置按钮
@property (nonatomic, strong) JPImageresizerConfigure *configure;
@property (nonatomic, weak) JPImageresizerView *imageresizerView;



@end

@implementation LNClipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(50, 0, (40  + 10), 0);
   self.configure = [JPImageresizerConfigure defaultConfigureWithResizeImage:self.image make:^(JPImageresizerConfigure *configure) {
        configure.jp_contentInsets(contentInsets);
    }];
    __weak typeof(self) wSelf = self;
    JPImageresizerView *imageresizerView = [JPImageresizerView imageresizerViewWithConfigure:self.configure imageresizerIsCanRecovery:^(BOOL isCanRecovery) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (!sSelf) return;
        // 当不需要重置设置按钮不可点
        sSelf.recoveryBtn.enabled = isCanRecovery;
    } imageresizerIsPrepareToScale:^(BOOL isPrepareToScale) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (!sSelf) return;
        // 当预备缩放设置按钮不可点，结束后可点击
    }];
    
    self.imageresizerView = imageresizerView;
    [self.view insertSubview:imageresizerView atIndex:0];
    self.configure = nil;
    [self setSubView];
}

- (void)setSubView{
    UIButton *leftBackBtn = [[UIButton alloc]initWithFrame:CGRectMake(15,10, 40, 40)];
    [leftBackBtn addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
    [leftBackBtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview: leftBackBtn];
    [self.view addSubview:self.recoveryBtn];
    [self.view addSubview:self.cutButton];
    [self.recoveryBtn setFrame:CGRectMake(15, self.view.frame.size.height - 50, 40, 40)];
    [self.cutButton setFrame:CGRectMake(self.view.frame.size.width - 50 - 15, self.view.frame.size.height - 50, 40, 40)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (UIButton *)cutButton{
    if(!_cutButton){
        _cutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cutButton setTitle:@"裁剪" forState:UIControlStateNormal];
        [_cutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cutButton addTarget:self action:@selector(cutAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cutButton;
}

- (UIButton *)recoveryBtn{
    if(!_recoveryBtn){
        _recoveryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recoveryBtn setTitle:@"重置" forState:UIControlStateNormal];
        [_recoveryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_recoveryBtn addTarget:self action:@selector(recoveryAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _recoveryBtn;
}

- (void)cutAction{
    self.recoveryBtn.enabled = NO;
    __weak typeof(self) weakSelf = self;
    [self.imageresizerView imageresizerWithComplete:^(UIImage *resizeImage) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        if (!resizeImage) {
            NSLog(@"没有裁剪图片");
            return;
        }
        if (self.cutFinish) {
            self.cutFinish(resizeImage);
            [self.navigationController  popViewControllerAnimated:YES];
        }
        strongSelf.recoveryBtn.enabled = YES;
    }];

}

- (void)recoveryAction{
    [self.imageresizerView recovery];
}

- (void)pressBack{
     [self.navigationController  popViewControllerAnimated:YES];
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
