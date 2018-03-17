//
//  VideoDownLoadAlertView.h
//  Myanycam
//
//  Created by myanycam on 13/10/14.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "BaseAlertView.h"
#import "EventAlertTableViewCellData.h"

@interface VideoDownLoadAlertView : BaseAlertView<ASIHTTPRequestDelegate>
@property (retain, nonatomic) NSString * downloadFilePath;
@property (retain, nonatomic) ASIHTTPRequest * fileRequest;
@property (retain, nonatomic) CameraInfoData * cameraInfo;

@property (retain, nonatomic) IBOutlet UIButton *progressButton;
@property (retain, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;
@property (retain, nonatomic) IBOutlet UIProgressView *downFileProgress;
@property (retain, nonatomic) IBOutlet UILabel *progressLabel;
- (IBAction)cancelButtonAction:(id)sender;

- (IBAction)progressButtonAction:(id)sender;
- (void)downloadVideo:(NSString *)videoUrl cellData:(EventAlertTableViewCellData *)cellData cameraInfo:(CameraInfoData *)camerainfo;

@end
