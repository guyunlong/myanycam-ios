//
//  MYResImageView.h
//  Myanycam
//
//  Created by myanycam on 13-5-30.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "MYImageView.h"

@interface MYResImageView : MYImageView
{
    NSString    *_imageName;
    BOOL        _imageResizable;
    NSString    *_defaultImageName;
    NSString    *_loadFailImageName;
    BOOL        _imageGray;
    BOOL        _smallIcon;
    DownLoadCompletionBlock _downloadCompletionBlock;
    UIImage     *_originImage;
}
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, assign) BOOL        imageResizable;
@property (nonatomic, retain) NSString *defaultImageName;
@property (nonatomic, retain) NSString *loadFailImageName;
@property (nonatomic, assign) BOOL        imageGray;
@property (nonatomic, assign) BOOL        smallIcon;
@property (nonatomic, copy) DownLoadCompletionBlock downloadCompletionBlock;
@property (nonatomic, retain) UIImage *originImage;
- (void)assignImageByName:(NSString *)imageName onDownLoadCompletion:(void (^)())completion;

@end
