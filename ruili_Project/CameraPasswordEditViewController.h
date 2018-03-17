//
//  CameraPasswordEditViewController.h
//  Myanycam
//
//  Created by myanycam on 13-5-16.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "BaseViewController.h"
#import "CameraDeviceData.h"
#import "CameraDeviceSetDelegate.h"
@interface CameraPasswordEditViewController : BaseViewController<UITextFieldDelegate,CameraDeviceSetDelegate>

//@property (retain, nonatomic) IBOutlet UITextField *passwordTextField;
@property (retain, nonatomic) IBOutlet UITextField *confirmTextField;
//@property (retain, nonatomic) NSString * passwordStr;
@property (retain, nonatomic) NSString * confirmPasswordStr;
@property (retain, nonatomic) CameraDeviceData  * cameraInfo;
@property (retain, nonatomic) IBOutlet UILabel *currentPasswordLabel;
@property (retain, nonatomic) IBOutlet UILabel *currentPwdLabel;

@property (retain, nonatomic) IBOutlet UILabel *changePasswordLabel;
@property (retain, nonatomic) IBOutlet UIImageView *inputBackImageView;
@property (retain, nonatomic) IBOutlet UIButton *doneButton;
- (IBAction)doneButtonAction:(id)sender;

@end
