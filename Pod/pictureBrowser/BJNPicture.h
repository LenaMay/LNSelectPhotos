//
//  MWPhoto.h
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 17/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BJNPictureProtocol.h"

// This class models a photo/image and it's caption
// If you want to handle photos, caching, decompression
// yourself then you can simply ensure your custom data model
// conforms to MWPhotoProtocol
@interface BJNPicture : NSObject <BJNPicture>

@property (nonatomic, strong) NSString *caption;
@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) NSURL *photoURL;

+ (BJNPicture *)photoWithImage:(UIImage *)image;
+ (BJNPicture *)photoWithURL:(NSURL *)url;

- (id)initWithImage:(UIImage *)image;
- (id)initWithURL:(NSURL *)url;
@end

