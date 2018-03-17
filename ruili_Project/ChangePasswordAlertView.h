//
//  ChangePasswordAlertView.h
//  Myanycam
//
//  Created by myanycam on 13/8/22.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "BaseAlertView.h"

#import "cameraDelegate.h"
#import "CheckCameraPasswordDelegate.h"

@interface ChangePasswordAlertView : BaseAlertView<UITextFieldDelegate,cameraDelegate,CheckCameraPasswordDelegate>
{
    CameraInfoData * _cameraInfo;
}

@property (retain, nonatomic) CameraInfoData * cameraInfo;
@property (retain, nonatomic) IBOutlet UILabel *tipDesLabel;
@property (retain, nonatomic) IBOutlet UILabel *oldPwdTipLabel;

@property (retain, nonatomic) IBOutlet UILabel *oldPasswordLabel;
@property (retain, nonatomic) IBOutlet UILabel *upDatePasswordTipLabel;
@property (retain, nonatomic) IBOutlet UITextField *updatePwdTextFiled;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;

@property (retain, nonatomic) IBOutlet UIButton *sureButton;

@property (retain, nonatomic) IBOutlet UIView *backgroundView;

- (IBAction)cancelButtonAction:(id)sender;
- (IBAction)sureButtonAction:(id)sender;

@end
