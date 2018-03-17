//
//  CustomAQGridViewCell.m
//  Myanycam
//
//  Created by myanycam on 13-4-26.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "CustomAQGridViewCell.h"

@implementation CustomAQGridViewCell

@synthesize imageView = _imageView;
@synthesize currentIndex;
@synthesize name;
@synthesize nameLabel;

- (void)dealloc{
    
//    self.imageView = nil;
    [_imageView release];
    _imageView = nil;
    self.name = nil;
    self.nameLabel = nil;
    [super dealloc];
}


- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) reuseIdentifier{
    
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        AsyncImageView * imageV = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imageV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:imageV];
        [imageV setContentMode:UIViewContentModeScaleAspectFit];
        self.imageView = imageV;
        [imageV release];
        
//        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-20, frame.size.width, 20)];
//        [self.contentView addSubview:label];
//        label.backgroundColor = [UIColor clearColor];
//        [label setFont:[UIFont systemFontOfSize:12]];
//        self.nameLabel = label;
//        [label release];
        
        self.selectionGlowColor = [UIColor orangeColor];
    }
    
    return self;
}

- (void)updateImage:(NSURL *)imageUrl{
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    NSURL *url = imageUrl;
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
        
        UIImage *image=[UIImage imageWithCGImage:asset.aspectRatioThumbnail];
        self.imageView.image =image;
        
    }failureBlock:^(NSError *error) {
        NSLog(@"error=%@",error);
    }
     
     ];
    
    [assetLibrary release];
    [pool release];
    
    
//    // Load from asset library async
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        @autoreleasepool {
//            @try {
//                ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
//                [assetslibrary assetForURL:imageUrl
//                               resultBlock:^(ALAsset *asset){
//                                   ALAssetRepresentation *rep = [asset defaultRepresentation];
//                                   CGImageRef iref = [rep fullScreenImage];
//                                   if (iref) {
//                                       self.imageView.image = [UIImage imageWithCGImage:iref];
//                                   }
//                                   [self performSelectorOnMainThread:@selector(decompressImageAndFinishLoading) withObject:nil waitUntilDone:NO];
//                               }
//                              failureBlock:^(NSError *error) {
//                                  self.imageView.image = nil;
//                                  NSLog(@"Photo from asset library error: %@",error);
//                                  [self performSelectorOnMainThread:@selector(decompressImageAndFinishLoading) withObject:nil waitUntilDone:NO];
//                              }];
//            } @catch (NSException *e) {
//                
//                NSLog(@"Photo from asset library error: %@", e);
//                [self performSelectorOnMainThread:@selector(decompressImageAndFinishLoading) withObject:nil waitUntilDone:NO];
//            }
//        }
//    });
    
}


//- (void)decompressImageAndFinishLoading {
//    
//    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
//    if (self.imageView.image) {
//        // Decode image async to avoid lagging when UIKit lazy loads
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            
//            self.imageView.image = [UIImage decodedImageWithImage:self.imageView.image];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // Finish on main thread
////                [self imageLoadingComplete];
//            });
//        });
//    } else {
//        // Failed
////        [self imageLoadingComplete];
//    }
//}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

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

@end
