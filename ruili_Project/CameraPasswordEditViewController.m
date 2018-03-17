//
//  CameraPasswordEditViewController.m
//  Myanycam
//
//  Created by myanycam on 13-5-16.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "CameraPasswordEditViewController.h"
#import "MYDataManager.h"

@interface CameraPasswordEditViewController ()

@end

@implementation CameraPasswordEditViewController
//@synthesize passwordStr;
@synthesize confirmPasswordStr;
@synthesize cameraInfo;

- (void)dealloc {
    
//    self.passwordStr = nil;
    self.confirmPasswordStr = nil;
    self.cameraInfo = nil;
    
//    [_passwordTextField release];
    [_confirmTextField release];
    [_currentPasswordLabel release];
    [_currentPwdLabel release];
    [_changePasswordLabel release];
    [_inputBackImageView release];
    [_doneButton release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.cameraInfo = [MYDataManager shareManager].cameraDeviceInfo;
    
//    self.currentPwdLabel.text= self.cameraInfo.password;
//    self.currentPasswordLabel.text = NSLocalizedString(@"Current Access Password", nil);
    
    self.changePasswordLabel.text = NSLocalizedString(@"New Access Password", nil);
    self.inputBackImageView.layer.masksToBounds = YES;
    self.inputBackImageView.layer.cornerRadius = 0.6;
    [self.confirmTextField becomeFirstResponder];
    [self.confirmTextField setSecureTextEntry:NO];
    [self.confirmTextField setValue:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [self showBackButton:nil action:nil buttonTitle:@""];
    
//    UIBarButtonItem * finishButton = [ViewToolClass customBarButtonItem:@"buttonNormal.png"
//                                                      buttonSelectImage:@"buttonSelect.png"
//                                                                  title:NSLocalizedString(@"Done", nil)
//                                                                   size:CGSizeMake(64, 32)
//                                                                 target:self
//                                                                 action:@selector(saveCameraPassword)];
//    self.navigationItem.rightBarButtonItem = finishButton;
    
    [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.cameraDeviceDelegate = self;
    
    
}

- (void)saveCameraPassword{
    
    if ([self checkPasswordRight]) {
        
        [self sendSetDeviceInfoRequest];
    }
}

- (void)goBack{

    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidUnload {
//    [self setPasswordTextField:nil];
    [self setConfirmTextField:nil];
    [self setCurrentPasswordLabel:nil];
    [self setCurrentPwdLabel:nil];
    [self setChangePasswordLabel:nil];
    [self setInputBackImageView:nil];
    [self setDoneButton:nil];
    [super viewDidUnload];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
   
//    if (textField == self.passwordTextField) {
//        self.passwordStr = textField.text;
//        [self.confirmTextField becomeFirstResponder];
//    }
    
    
    if (textField == self.confirmTextField) {
        
        self.confirmPasswordStr = self.confirmTextField.text;
        
        if ([self checkPasswordRight]) {
           
             [self.confirmTextField resignFirstResponder];
        }
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField.text length] == 32 && [string length] != 0) {
        
        return NO;
    }
    
    return YES;
}

- (BOOL)checkPasswordRight{
    
    self.confirmPasswordStr = self.confirmTextField.text;
    
    if ([self.confirmPasswordStr length] == 0) {
        
        [self showAlertView:NSLocalizedString(@"Error", nil) alertMsg:NSLocalizedString(@"Password cannot be blank", nil) userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        
        return NO;
    }
    
    if ([self.confirmPasswordStr length] < CAMERA_PASSWORD_MIN_LENGTH) {

        [self showAlertView:NSLocalizedString(@"Error", nil) alertMsg:NSLocalizedString(@"Password is at least 8 characters", nil)  userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];

        return NO;
    }
    
    if ([self.confirmPasswordStr length] > CAMERA_PASSWORD_LENGTH) {
        
        [self showAlertView:NSLocalizedString(@"Error", nil) alertMsg:NSLocalizedString(@"Password is up to 32 characters", nil)  userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        
        return NO;
    }
    
    
    self.cameraInfo.password = self.confirmPasswordStr;
    
    return YES;
}

- (void)sendSetDeviceInfoRequest{
    
    [[AppDelegate getAppDelegate].mygcdSocketEngine sendSetDeviceInfoRequest:self.cameraInfo.password timeZone:self.cameraInfo.timezone];
}

- (void)getDeviceInfoRsp:(NSDictionary *)info
{
    
}

- (void)setDeviceInfoRsp:(NSDictionary *)info{
    
    [[AppDelegate getAppDelegate].window hideWaitAlertView];
    
    if ([[info objectForKey:@"ret"] intValue] == 0) {
        
        [self goBack];
    }
    else{
        
       	NSString *title = NSLocalizedString(@"Error", nil);
        NSString *message = NSLocalizedString(@"Set Error", nil);
        [self showAskAlertView:title msg:message userInfo:nil];
    }
    
}

- (void)alertView:(AHAlertView *)alertView otherButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        [self saveCameraPassword];
    }
}

- (void)cancelButtonAction:(NSDictionary *)info{
    
    [self goBack];
}


- (IBAction)doneButtonAction:(id)sender {
    
    [self saveCameraPassword];
}
@end
