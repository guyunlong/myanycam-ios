//
//  AlertImageAlertView.m
//  Myanycam
//
//  Created by myanycam on 13/10/19.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "AlertImageAlertView.h"
#import "MYDataManager.h"

@implementation AlertImageAlertView
@synthesize cameraInfo;
@synthesize alertData;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)closeButtonAlertAction:(id)sender {
    
    [MYDataManager shareManager].imageUrlEngine.delegate = nil;
    [self hide];
}

- (void)prepareData:(CameraInfoData *)aCameraInfo alertPictureName:(NSString *)alertPictureName{
    
    self.cameraInfo = aCameraInfo;
    DebugLog(@"alertPictureName %@",alertPictureName);
    EventAlertTableViewCellData * data = [[EventAlertTableViewCellData alloc] initWithString:alertPictureName];
    self.alertData = data;
    [[MYDataManager shareManager].imageUrlEngine sendAlertPictureRequest:aCameraInfo fileName:alertPictureName delegate:self];

    [data release];
    
    NSString * cameraNameStr = [NSString stringWithFormat:@"%@ : %@",aCameraInfo.cameraName,self.alertData.formatEventTime];
    self.cameraNameLabel.text = cameraNameStr;

    
}

- (void)alertImageOrRecordUrl:(NSString *)url type:(NSInteger)type{
    
    self.alertImageView.imageURL = url;
}

- (void)dealloc {
    
    self.cameraInfo = nil;
    self.alertData = nil;
    [_alertImageView release];
    [_closeButton release];
    [_cameraNameLabel release];
    [super dealloc];
    
}
@end
