//
//  AlertImageAlertView.h
//  Myanycam
//
//  Created by myanycam on 13/10/19.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "BaseAlertView.h"
#import "EventAlertTableViewCellData.h"
#import "AlertImageUrlEngine.h"

@interface AlertImageAlertView : BaseAlertView<AlertImageUrlEngineDelegate>

@property (retain, nonatomic) IBOutlet MYImageView *alertImageView;
@property (retain, nonatomic) CameraInfoData    * cameraInfo;
@property (retain, nonatomic) EventAlertTableViewCellData   * alertData;
@property (retain, nonatomic) IBOutlet UIButton *closeButton;
@property (retain, nonatomic) IBOutlet UILabel *cameraNameLabel;



- (IBAction)closeButtonAlertAction:(id)sender;

- (void)prepareData:(CameraInfoData *)aCameraInfo alertPictureName:(NSString *)alertPictureName;

@end
