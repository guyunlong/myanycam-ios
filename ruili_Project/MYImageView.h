//
//  MYImageView.h
//  Myanycam
//
//  Created by myanycam on 13-5-30.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MYImageViewAnimation.h"
#import "MYImageCache.h"

@interface MYImageView :  MYImageViewAnimation <ASIHTTPRequestDelegate>{
    ASIHTTPRequest          *_request;
    
    UIImage                 *_defaultImage;
    NSString                *_imageURL;
    BOOL                    _cancel;
    BOOL                    _fadeAnimated;
    MYImageCache            *_imageCache;
}
@property (nonatomic, retain) MYImageCache              *imageCache;
@property (nonatomic, retain) ASIHTTPRequest            *request;
@property (nonatomic, retain) UIImage                   *defaultImage;
@property (nonatomic, copy) NSString                    *imageURL;

@property (nonatomic, assign) BOOL                      cancel;
@property (nonatomic, assign) BOOL                    fadeAnimated;

- (void)loadImage;
- (void)loadImageIgnoreCache;

@end
