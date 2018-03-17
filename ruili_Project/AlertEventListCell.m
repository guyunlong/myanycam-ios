//
//  AlertEventListCell.m
//  Myanycam
//
//  Created by myanycam on 13-5-2.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "AlertEventListCell.h"

@implementation AlertEventListCell
@synthesize cameraInfo = _cameraInfo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCameraInfo:(CameraInfoData *)cameraInfo{
    
    if (_cameraInfo != cameraInfo) {
        
        [_cameraInfo release];
        _cameraInfo = [cameraInfo retain];
    }
    
    if (cameraInfo) {
        
        self.cameraName.text = self.cameraInfo.cameraName;
    }
}

- (void)dealloc {
    self.cameraInfo = nil;
    [_cameraImageView release];
    [_cameraName release];
    [super dealloc];
}
@end
