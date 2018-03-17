//
//  ChangePasswordAlertView.m
//  Myanycam
//
//  Created by myanycam on 13/8/22.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "ChangePasswordAlertView.h"
#import "MYDataManager.h"
#import "AppDelegate.h"


@implementation ChangePasswordAlertView

@synthesize cameraInfo = _cameraInfo;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        
    }
    
    return self;
}

- (void)dealloc {
    
    [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.cameraDelegate = nil;
    [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.checkCameraPwdAlertViewDelegate = nil;
    
    [_tipDesLabel release];
    [_oldPasswordLabel release];
    [_oldPwdTipLabel release];
    [_upDatePasswordTipLabel release];
    [_updatePwdTextFiled release];
    [_cancelButton release];
    [_sureButton release];
    [_backgroundView release];
    self.cameraInfo = nil;
    [super dealloc];
}

- (void)setCameraInfo:(CameraInfoData *)cameraInfo{
    
    if (cameraInfo != _cameraInfo) {
        
        [_cameraInfo release];
        _cameraInfo = [cameraInfo retain];
    }
    
    if (cameraInfo) {
        
        self.backgroundView.layer.masksToBounds = YES;
        self.backgroundView.layer.cornerRadius = 6.0;
        self.oldPasswordLabel.text = cameraInfo.password;
        self.oldPwdTipLabel.text = NSLocalizedString(@"Current Access Token", nil);
        self.upDatePasswordTipLabel.text = NSLocalizedString(@"New Access Token", nil);
        self.tipDesLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Camera Access Token Error", nil),self.cameraInfo.cameraName];
        [self.cancelButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        [self.sureButton setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    }
}

- (IBAction)cancelButtonAction:(id)sender {
    
    if(self.baseDelegate && [self.baseDelegate respondsToSelector:@selector(alertView:clickButtonAtIndex:)]){
        
        [self.baseDelegate alertView:self clickButtonAtIndex:0];
    }

    [self hide];
    
}

- (IBAction)sureButtonAction:(id)sender {
    
    [self changePassword];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([MYDataManager shareManager].deviceTpye < DeviceTypeIpad1 ) {
        
        [self.backgroundView customaddOffsetYWithAnimation:80];

    }
    
    [self changePassword];
    
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    if ([textField.text length] == CAMERA_PASSWORD_LENGTH && [string length] > 0) {
        
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if ([MYDataManager shareManager].deviceTpye < DeviceTypeIpad1 ) {
        
        [self.backgroundView customaddOffsetYWithAnimation:-80];

    }
    
    return YES;
}


- (void)changePassword{
    
    if ([self.updatePwdTextFiled.text length] == 0) {
        
        [self showAutoDismissAlertView:NSLocalizedString(@"Token can not be blank", nil)];
        [self.updatePwdTextFiled becomeFirstResponder];
        return;
    }
    
    if ([self.updatePwdTextFiled.text length] > CAMERA_PASSWORD_LENGTH ) {
        
        [self showAutoDismissAlertView:NSLocalizedString(@"Token is up to 32 characters", nil)];
        [self.updatePwdTextFiled becomeFirstResponder];
        return;
    }
    
    if ([self.updatePwdTextFiled.text length] < 8 ) {
        
        [self showAutoDismissAlertView:NSLocalizedString(@"Token is at least 8 characters", nil)];
        [self.updatePwdTextFiled becomeFirstResponder];
        return;
    }
    
    if ([[AppDelegate getAppDelegate].mygcdSocketEngine isConnect] && ![self.cameraInfo.password isEqualToString:self.updatePwdTextFiled.text] && self.cameraInfo.status != 0) {
        
        [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.checkCameraPwdAlertViewDelegate = self;
         [[AppDelegate getAppDelegate].mygcdSocketEngine sendCheckCameraPasswordRequestWithPassword:self.cameraInfo password:self.updatePwdTextFiled.text];

    }
    else{
        
        [self hide];
    }
}


- (void)modifyFailed{
    
    
}

- (void)modifySuccess{
    
    self.cameraInfo.password = self.updatePwdTextFiled.text;
    self.cameraInfo.flagLock = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationDownCameraGridImage object:[NSNumber numberWithInt:self.cameraInfo.cameraId]];
    
    [[AppDelegate getAppDelegate].window jumpToRootViewControllerWithOutAnimation];
    [self hide];
}
         
- (void)checkCameraPasswordRespond:(NSDictionary *)data{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([[data objectForKey:@"ret"] intValue] != 0) {
            
            [self showAutoDismissAlertView:NSLocalizedString(@"Token is error, please try again!", nil)];
            [self.updatePwdTextFiled becomeFirstResponder];
        }
        else{
            
        [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.cameraDelegate = self;
        [[AppDelegate getAppDelegate].mygcdSocketEngine sendInfoModifyCamera:self.cameraInfo cameraName:self.cameraInfo.cameraName cameraMemo:self.cameraInfo.memo password:self.updatePwdTextFiled.text];
        }
        
    });
 
}

@end
