//
//  UIImage+MYUImageTool.h
//  Myanycam
//
//  Created by myanycam on 13-2-27.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MYUImageTool)

- (UIImage *)resizableImage;
- (UIImage *)convertToGrayscale;
- (UIImage *)resizeImageToFit:(CGSize)newSize;
+ (UIImage *)decodedImageWithImage:(UIImage *)image;
@end
