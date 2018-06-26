//
//  MWPhoto.m
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 17/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import "BJNPicture.h"
#import "BJNPictueBrowser.h"
//#import "SDWebImageDecoder.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "SDWebImageOperation.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface BJNPicture () {
    id <SDWebImageOperation> _webImageOperation;
}

- (void)imageLoadingComplete:(BJNImageLoadCompletedBlock)completedBlock error:(NSError *)error finished:(BOOL)finished;

@end

@implementation BJNPicture

@synthesize underlyingImage = _underlyingImage; // synth property from protocol

#pragma mark - Class Methods

- (void)dealloc {
    
}

+ (BJNPicture *)photoWithImage:(UIImage *)image {
	return [[BJNPicture alloc] initWithImage:image];
}

+ (BJNPicture *)photoWithURL:(NSURL *)url {
	return [[BJNPicture alloc] initWithURL:url];
}

#pragma mark - Init

- (id)initWithImage:(UIImage *)image {
	if ((self = [super init])) {
		_image = image;
	}
	return self;
}

- (id)initWithURL:(NSURL *)url {
	if ((self = [super init])) {
		_photoURL = [url copy];
	}
	return self;
}

#pragma mark - MWPhoto Protocol Methods

- (UIImage *)underlyingImage {
    return _underlyingImage;
}

- (void)loadUnderlyingImageProgress:(BJNImageLoadProgressBlock)progressBlock
                           completed:(BJNImageLoadCompletedBlock)completedBlock {
    [self loadUnderlyingImageOnlyLocal:NO progress:progressBlock completed:completedBlock];
}

- (void)loadUnderlyingImageOnlyLocal:(BOOL)flag
                            progress:(BJNImageLoadProgressBlock)progressBlock
                           completed:(BJNImageLoadCompletedBlock)completedBlock {
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    @try {
        if (self.underlyingImage) {
            [self imageLoadingComplete:completedBlock error:nil finished:YES];
        } else {
            [self performLoadUnderlyingImageOnlyLocal:flag progress:progressBlock completed:completedBlock];
        }
    }
    @catch (NSException *exception) {
        self.underlyingImage = nil;
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileNoSuchFileError userInfo:@{NSLocalizedFailureReasonErrorKey:exception.reason}];
        [self imageLoadingComplete:completedBlock error:error finished:NO];

    }
    @finally {
    }
}

// Set the underlyingImage
- (void)performLoadUnderlyingImageOnlyLocal:(BOOL)flag progress:(BJNImageLoadProgressBlock)progressBlock
                                 completed:(BJNImageLoadCompletedBlock)completedBlock {
    
    // Get underlying image
    if (_image) {
        
        // We have UIImage!
        self.underlyingImage = _image;
        [self imageLoadingComplete:completedBlock error:nil finished:YES];
        
    } else if (_photoURL) {
        
        // Check what type of url it is
        if ([[[_photoURL scheme] lowercaseString] isEqualToString:@"assets-library"]) {
            
            // Load from asset library async
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @autoreleasepool {
                    @try {
                        ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
                        [assetslibrary assetForURL:_photoURL
                                       resultBlock:^(ALAsset *asset){
                                           ALAssetRepresentation *rep = [asset defaultRepresentation];
                                           CGImageRef iref = [rep fullScreenImage];
                                           if (iref) {
                                               self.underlyingImage = [UIImage imageWithCGImage:iref];
                                           }
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [self imageLoadingComplete:completedBlock error:nil finished:YES];
                                           });
                                       }
                                      failureBlock:^(NSError *error) {
                                          self.underlyingImage = nil;
                                          BJNLog(@"Photo from asset library error: %@",error);
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [self imageLoadingComplete:completedBlock error:error finished:NO];
                                          });
                                      }];
                    } @catch (NSException *e) {
                        BJNLog(@"Photo from asset library error: %@", e);
                        
                        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileNoSuchFileError userInfo:@{NSLocalizedFailureReasonErrorKey:e.reason}];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self imageLoadingComplete:completedBlock error:error finished:NO];
                        });                    }
                }
            });
            
        } else if ([_photoURL isFileReferenceURL]) {
            
            // Load from local file async
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @autoreleasepool {
                    @try {
                        self.underlyingImage = [UIImage imageWithContentsOfFile:_photoURL.path];
                        if (!_underlyingImage) {
                            BJNLog(@"Error loading photo from path: %@", _photoURL.path);
                        }
                    } @finally {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self imageLoadingComplete:completedBlock error:nil finished:YES];
                        });
                    }
                }
            });
            
        } else {
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            
            if (flag) {
                [[SDImageCache sharedImageCache] queryCacheOperationForKey:[manager cacheKeyForURL:_photoURL] done:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
                    if (cacheType == SDImageCacheTypeNone) {
                        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:nil];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self imageLoadingComplete:completedBlock error:error finished:NO];
                        });
                    } else {
                        self.underlyingImage = image;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self imageLoadingComplete:completedBlock error:nil finished:YES];
                            
                        });
                    }
                }];
            } else {
                // Load async from web (using SDWebImage)
                @try {
                    
                    _webImageOperation = [manager loadImageWithURL:_photoURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                        if (expectedSize > 0) {
                            float progress = receivedSize / (float)expectedSize;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (progressBlock) {
                                    progressBlock(progress);
                                }
                            });
                        }
                    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                        if (error) {
                            BJNLog(@"SDWebImage failed to download image: %@", error);
                        }
                        _webImageOperation = nil;
                        self.underlyingImage = image;
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self imageLoadingComplete:completedBlock error:error finished:finished];
                        });
                    }];
                } @catch (NSException *e) {
                    BJNLog(@"Photo from web: %@", e);
                    _webImageOperation = nil;
                    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadURL userInfo:@{NSLocalizedFailureReasonErrorKey:e.reason}];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self imageLoadingComplete:completedBlock error:error finished:NO];
                    });
                }
            }
        }
        
    } else {
        
        // Failed - no source
        @throw [NSException exceptionWithName:nil reason:nil userInfo:nil];
        
    }
}

- (BOOL)imageExist {
    BOOL isExist = NO;
    // Get underlying image
    if (_image) {
        isExist = YES;
    } else if (_photoURL) {
        // Check what type of url it is
        if ([[[_photoURL scheme] lowercaseString] isEqualToString:@"assets-library"]) {
            isExist = YES;
        } else if ([_photoURL isFileReferenceURL]) {
            isExist = YES;
        } else {
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            isExist = [[SDImageCache sharedImageCache] diskImageDataExistsWithKey:[manager cacheKeyForURL:_photoURL]];
        }
        
    } else {
        isExist = NO;
    }
    return isExist;
}

// Release if we can get it again from path or url
- (void)unloadUnderlyingImage {
	self.underlyingImage = nil;
}

- (void)imageLoadingComplete:(BJNImageLoadCompletedBlock)completedBlock error:(NSError *)error finished:(BOOL)finished {
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    // Notify on next run loop
    dispatch_async(dispatch_get_main_queue(), ^{
        if (completedBlock) {
            completedBlock(self.underlyingImage, error, finished);
        }
    });
}

- (void)cancelAnyLoading {
    if (_webImageOperation) {
        [_webImageOperation cancel];
    }
}

- (void)loadLocalImageAndNotify {
    
}

@end
