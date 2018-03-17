//
//  CustomAQGridViewCell.h
//  Myanycam
//
//  Created by myanycam on 13-4-26.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "AQGridViewCell.h"
#import "AsyncImageView.h"



@interface CustomAQGridViewCell : AQGridViewCell{
    
    AsyncImageView * _imageView;
}


@property (retain, nonatomic) AsyncImageView * imageView;
@property (retain, nonatomic) NSString * name;
@property (assign, nonatomic) NSInteger  currentIndex;
@property (retain, nonatomic) UILabel * nameLabel;

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) reuseIdentifier;
- (void)updateImage:(NSURL *)imageUrl;



@end
