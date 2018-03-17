//
//  MYResImageView.m
//  Myanycam
//
//  Created by myanycam on 13-5-30.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "MYResImageView.h"
#import "ToolClass.h"


@implementation MYResImageView

@synthesize imageName = _imageName;
@synthesize imageResizable = _imageResizable;
@synthesize defaultImageName = _defaultImageName;
@synthesize loadFailImageName = _loadFailImageName;
@synthesize imageGray = _imageGray;
@synthesize downloadCompletionBlock = _downloadCompletionBlock;
@synthesize smallIcon = _smallIcon;
@synthesize originImage = _originImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.defaultImageName = @"load.png";
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self.defaultImageName = @"load.png";
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (UIImage *)defaultImage {
    return self.imageGray?[[UIImage imageNamed:self.defaultImageName] convertToGrayscale]:[UIImage imageNamed:self.defaultImageName];
}



- (NSString *)filePathForImageInDocumentsNamed:(NSString *)imageName {
    NSString *docPath = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] path];
    NSString *imageFolder = [docPath stringByAppendingPathComponent:@"images"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:imageFolder]) {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:imageFolder withIntermediateDirectories:YES attributes:nil error:&error];
    }
    NSString *filePath = [imageFolder stringByAppendingPathComponent:imageName];
    return filePath;
}


- (NSString *)smallImagePathWithNamed:(NSString *)imageName {
    NSString *smallIcon = [NSString stringWithFormat:@"small_%@", imageName];
    NSString *smallIconPath = [ToolClass documentDirectoryPath];
    smallIconPath = [smallIconPath stringByAppendingPathComponent:@"images"];
    smallIconPath = [smallIconPath stringByAppendingPathComponent:smallIcon];
    return smallIconPath;
}

- (UIImage *)convertSmallImageWithNamed:(NSString *)imageName {
    UIImage *bigImage = [UIImage imageNamed:imageName];
    if (!bigImage) {
        NSString *filePath = [self filePathForImageInDocumentsNamed:imageName];
        bigImage = [UIImage imageWithContentsOfFile:filePath];
    }
    
    UIImage *smallImage = [bigImage resizeImageToFit:CGSizeMake(74, 88)];
    NSString *smallImagePath = [self smallImagePathWithNamed:imageName];
    
    if (smallImage) {
        NSData *data = nil;
        if ([imageName hasSuffix:@".png"]) {
            data = UIImagePNGRepresentation(smallImage);
        }
        else if ([imageName hasSuffix:@".jpg"]) {
            data = UIImageJPEGRepresentation(smallImage, 1.0);
        }
        
        if (data) {
            [data writeToFile:smallImagePath atomically:YES];
        }
        
        return smallImage;
    }
    
    return nil;
}

- (void)setImageGray:(BOOL)imageGray {
    _imageGray = imageGray;
    
    if (_imageGray) {
        if (self.image) {
            self.originImage = self.image;
            self.image = [self.image convertToGrayscale];
        }
    }
    else {
        if (self.originImage) {
            self.image = self.originImage;
            self.originImage = nil;
        }
    }
}

- (void)setImageName:(NSString *)imageName {
    if (_imageName != imageName) {
        [_imageName release];
        [self.request clearDelegatesAndCancel];
        _imageName = [imageName retain];
    }
    if (!imageName) {
        return ;
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    if (request.contentLength != [request.responseData length]) {
        return;
    }
    
    UIImage *image = [UIImage imageWithData:request.responseData];
    if (image) {
        [request.responseData writeToFile:[self filePathForImageInDocumentsNamed:self.imageName] atomically:YES];
    }
    if (image) {
        if (self.smallIcon) {
            if (image.size.width >= 100) {
                image = [self convertSmallImageWithNamed:self.imageName];
            }
        }
        if (self.imageGray) {
            image = [image convertToGrayscale];
        }
        self.image = image;
    }
    else {
        if (self.defaultImage) {
            self.defaultImage = [self.defaultImage convertToGrayscale];
            self.image = self.defaultImage;
        } else {
            self.image = [UIImage imageNamed:@"load.png"];
        }
    }
    if (self.imageResizable) {
        self.image = [self.image resizableImage];
    }
    
    if (self.downloadCompletionBlock) {
        self.downloadCompletionBlock();
    }
    self.downloadCompletionBlock = nil;
}

- (void)setImageResizable:(BOOL)imageResizable {
    _imageResizable = imageResizable;
    if (self.image) {
        self.image = [self.image resizableImage];
    }
}

- (void)assignImageByName:(NSString *)imageName onDownLoadCompletion:(void (^)())completion {
    self.downloadCompletionBlock = completion;
    self.imageName = imageName;
}

- (void)dealloc
{
    self.imageName = nil;
    self.defaultImageName = nil;
    self.loadFailImageName = nil;
    self.originImage = nil;
    self.downloadCompletionBlock = nil;
    
    [super dealloc];
}

@end
