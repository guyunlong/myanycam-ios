//
//  ESGLView.h
//  kxmovie
//
//  Created by Kolyvan on 22.10.12.
//  Copyright (c) 2012 Konstantin Boukreev . All rights reserved.
//
//  https://github.com/kolyvan/kxmovie
//  this file is part of KxMovie
//  KxMovie is licenced under the LGPL v3, see lgpl-3.0.txt

#import <UIKit/UIKit.h>

@class KxVideoFrame;
//@class KxMovieDecoder;

@interface CustomMovieGLView : UIView

@property (assign,nonatomic) BOOL   flagOpenGlPicture;
@property (retain,nonatomic) UIImage    * currentImage;
@property (assign,nonatomic) CGSize     videoSize;

- (id) initWithFrame:(CGRect)frame videoW:(CGFloat)w videoH:(CGFloat)h;
- (void) render: (KxVideoFrame *) frame;
- (UIImage*)snapshot:(UIView*)eaglview;

@end