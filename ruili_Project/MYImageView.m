//
//  MYImageView.m
//  Myanycam
//
//  Created by myanycam on 13-5-30.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "MYImageView.h"
#import "ASIDownloadCache.h"


@implementation MYImageView

@synthesize request             = _request;
@synthesize defaultImage        = _defaultImage;
@synthesize imageURL            = _imageURL;
@synthesize cancel              = _cancel;
@synthesize fadeAnimated        = _fadeAnimated;
@synthesize imageCache          = _imageCache;


- (void)dealloc {
    [self.request clearDelegatesAndCancel];
    self.request = nil;
    self.defaultImage = nil;
    self.imageURL = nil;
    self.imageCache = nil;
    [super dealloc];
}

- (id)initWithImageURL:(NSString *)URL {
    self = [super init];
    if (self) {
        self.imageURL = URL;
    }
    return self;
}

- (void)setImageURL:(NSString *)imageURL {
    if (_imageURL != imageURL) {
        [_imageURL release];
        _imageURL = [imageURL copy];
    }
    
    if (_imageURL) {
        
        self.defaultImage = [UIImage imageNamed:@"egopv_photo_placeholder.png"];
        [self loadImage];
    }
}

- (void)loadImage{
    if (self.cancel) {
        return;
    }
    if (self.request) {
        [self.request clearDelegatesAndCancel];
    }
    
	if (self.imageURL && [self.imageURL length]>0) {
        
        NSRange range = [self.imageURL rangeOfString:@"Documents"];
        if (range.length != 0) {
            self.image = [UIImage imageWithContentsOfFile:self.imageURL];
            return;
        }
        
        if (![self.imageURL hasPrefix:@"http"]) {
            self.image = [UIImage imageNamed:self.imageURL];
            return;
        }
        if (!self.imageCache) {
            self.imageCache = [MYImageCache imageCacheWithDirectoryName:@"image"];
        }
        
        self.image = [self.imageCache readCacheImageWithKey:[self imageKeyWithUrl:self.imageURL]];
        //        if (!self.image)
        {
            self.image = self.defaultImage;
            self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.imageURL]];
            self.request.delegate = self;
            [self.request setTimeOutSeconds:60];
            [self.request setDidFinishSelector:@selector(requestFinished:)];
            //        [self.request setSecondsToCache:IMAGELOAD_CACHESECONDS];
            //        [self.request setDownloadCache:[ASIDownloadCache sharedCache]];
            //        [self.request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            //        [self.request setCachePolicy:ASIUseDefaultCachePolicy];
            [self.request startAsynchronous];
        }
	}
}
- (NSString*)imageKeyWithUrl:(NSString *)url{
    
    if (url.length == 0) {
        return nil;
    }
    NSArray *splitArray = [url componentsSeparatedByString:@"/"];
    
    splitArray = [[splitArray lastObject] componentsSeparatedByString:@"."];
    if (splitArray.count ==0) {
        
        return url;
    }
    return [splitArray objectAtIndex:0];
    
}
- (void)loadImageIgnoreCache {
    if (self.cancel) {
        return;
    }
    
    if (self.request) {
        [self.request clearDelegatesAndCancel];
    }
    
	if (self.imageURL && [self.imageURL length]>0) {
        
        if (![self.imageURL hasPrefix:@"http"]) {
            self.image = [UIImage imageNamed:self.imageURL];
        }
        
		self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.imageURL]];
        self.request.delegate = self;
        [self.request setTimeOutSeconds:60];
        [self.request setSecondsToCache:IMAGELOAD_CACHESECONDS];
        [self.request setDownloadCache:[ASIDownloadCache sharedCache]];
        [self.request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [self.request setCachePolicy:ASIDoNotReadFromCacheCachePolicy];
        [self.request startAsynchronous];
	}
}

- (void)stopLoading {
    [self.request clearDelegatesAndCancel];
    self.request = nil;
}


#pragma mark - ASIHTTPRequestDelegate
- (void)requestStarted:(ASIHTTPRequest *)request {
    
}
- (void)requestDownImageFinsh:(ASIHTTPRequest *)request {
    
    [self requestFinished:request];
    [self saveCacheWithImageData:request.responseData];
}
- (void)requestFinished:(ASIHTTPRequest *)request {
    UIImage *image = [UIImage imageWithData:request.responseData];
    if (image) {
        self.image = image;
        [self saveCacheWithImageData:request.responseData];
    }
    else {
        self.image = self.defaultImage;
    }
    if (self.fadeAnimated) {
        self.alpha = 0;
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    self.image = self.defaultImage;
}
-(void)saveCacheWithImageData:(NSData*)data{
    [self.imageCache saveCacheImageWithKey:[self imageKeyWithUrl:self.imageURL] iamgeData:data];
}

@end
