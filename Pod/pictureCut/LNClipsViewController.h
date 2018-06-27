//
//  LNClipsViewController.h
//  selectPhotos
//
//  Created by Lina on 2018/6/26.
//  Copyright © 2018年 Lina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LNClipsViewController : UIViewController
@property (nonatomic, strong) UIImage *image;
@property(nonatomic,copy) void (^cutFinish)(UIImage *image);
@end
