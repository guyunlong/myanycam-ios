//
//  AlertAQGridViewCell.h
//  Myanycam
//
//  Created by myanycam on 13-5-20.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "AQGridViewCell.h"
#import "MKNumberBadgeView.h"

@interface AlertAQGridViewCell : AQGridViewCell{
    
    CameraInfoData *    _cameraData;
}

@property (retain, nonatomic) CameraInfoData * cameraData;
@property (retain, nonatomic) MKNumberBadgeView * eventNumberView;
@property (retain, nonatomic) UIImageView * imageView;
@property (retain, nonatomic) UIImageView * deleteImageView;
@property (retain, nonatomic) UIImageView * upgradeImageView;
@property (retain, nonatomic) UIImageView * hadwatched;
@property (retain, nonatomic) UIImageView * cameraStateImageView;
@property (retain, nonatomic) NSString * name;
@property (retain, nonatomic) UILabel * nameLabel;
@property (retain, nonatomic) UILabel * cameraStateLabel;


- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) reuseIdentifier;


@end
