//
//  CallingAlertView.h
//  Myanycam
//
//  Created by myanycam on 13/10/8.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "BaseAlertView.h"

@interface CallingAlertView : BaseAlertView

@property (retain, nonatomic) CameraInfoData * cameraInfo;
@property (retain, nonatomic) IBOutlet UILabel *callingNameLabel;
@property (retain, nonatomic) IBOutlet UIButton *acceptButton;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;


- (void)prepareData:(CameraInfoData *)acameraInfo;

- (IBAction)cancelButtonAction:(id)sender;
- (IBAction)acceptButtonAction:(id)sender;

@end
