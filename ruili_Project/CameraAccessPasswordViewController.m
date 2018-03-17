//
//  CameraAccessPasswordViewController.m
//  Myanycam
//
//  Created by myanycam on 13/6/27.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "CameraAccessPasswordViewController.h"
#import "AppDelegate.h"

@interface CameraAccessPasswordViewController ()

@end

@implementation CameraAccessPasswordViewController
@synthesize cameraInfo;


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
    [self showBackButton:self action:@selector(goBack) buttonTitle:nil];
    
    UIBarButtonItem * finishButton = [ViewToolClass customBarButtonItem:@"buttonNormal.png"
                                                      buttonSelectImage:@"buttonSelect.png"
                                                                  title:NSLocalizedString(@"Done", nil)
                                                                   size:CGSizeMake(64, 32)
                                                                 target:self
                                                                 action:@selector(changePassword)];
    self.navigationItem.rightBarButtonItem = finishButton;
    
    self.currentPassword.text = self.cameraInfo.password;
    self.changePasswrdTextField.text = self.cameraInfo.password;
    
    self.currentPasswordTipLabel.text = NSLocalizedString(@"Current Access Password", nil);
    self.changepasswordLabel.text = NSLocalizedString(@"New Access Password", nil);
    
    self.currentPasswordBackImageView.image = [[UIImage imageNamed:@"buttonNormal.png"] resizableImage];
    [self.changePasswrdTextField setSecureTextEntry:NO];
    [self.changePasswrdTextField becomeFirstResponder];
}

- (void)changePassword{
    
    if ([self.changePasswrdTextField.text length] == 0) {
        
        [self showAlertView:NSLocalizedString(@"Error", nil) alertMsg:NSLocalizedString(@"Password cannot be blank", nil) userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [self.changePasswrdTextField becomeFirstResponder];
        return;
    }
    
    if ([self.changePasswrdTextField.text length] > CAMERA_PASSWORD_LENGTH ) {
        
        [self showAlertView:NSLocalizedString(@"Error", nil) alertMsg:NSLocalizedString(@"Password is up to 32 characters", nil) userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [self.changePasswrdTextField becomeFirstResponder];
        return;
    }
    
    if ([self.changePasswrdTextField.text length] < 8 ) {
        
        [self showAlertView:NSLocalizedString(@"Error", nil) alertMsg:NSLocalizedString(@"Password is at least 8 characters", nil) userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [self.changePasswrdTextField becomeFirstResponder];
        return;
    }
    
    if ([[AppDelegate getAppDelegate].mygcdSocketEngine isConnect] && ![self.cameraInfo.password isEqualToString:self.changePasswrdTextField.text] && self.cameraInfo.status != 0) {
        
        [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.cameraDelegate = self;
        [[AppDelegate getAppDelegate].mygcdSocketEngine sendInfoModifyCamera:self.cameraInfo cameraName:self.cameraInfo.cameraName cameraMemo:self.cameraInfo.memo password:self.changePasswrdTextField.text];
    }
    else{
        
        [self goBack];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.cameraInfo = nil;
    [_currentPassword release];
    [_changePasswrdTextField release];
    [_currentPasswordBackImageView release];
    [_currentPasswordTipLabel release];
    [_changepasswordLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setCurrentPassword:nil];
    [self setChangePasswrdTextField:nil];
    [self setCurrentPasswordBackImageView:nil];
    [self setCurrentPasswordTipLabel:nil];
    [self setChangepasswordLabel:nil];
    [super viewDidUnload];
}

- (void)modifySuccess{
    
    self.cameraInfo.password = self.changePasswrdTextField.text;
    [self goBack];
}

- (void)modifyFailed{
    
     [self goBack];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField.text length] == CAMERA_PASSWORD_LENGTH && [string length] > 0) {
        
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self changePassword];
    [textField resignFirstResponder];
    return YES;
}



@end
