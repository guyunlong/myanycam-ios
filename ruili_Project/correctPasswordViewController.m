//
//  correctPasswordViewController.m
//  myanycam
//
//  Created by myanycam on 13-1-9.
//  Copyright (c) 2013年 myanycam. All rights reserved.
//

#import "correctPasswordViewController.h"
#import "dealWithCommend.h"
#import "MyMD5.h"
#import "AppDelegate.h"
#import "navButton.h"
#import "navTitleLabel.h"
#import "MYDataManager.h"


@interface correctPasswordViewController ()

@end

@implementation correctPasswordViewController

-(AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
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
    
    [self showBackButton:nil action:nil buttonTitle:@""];
    
    
    [[self appDelegate] mygcdSocketEngine].dealObject.correctPasswordDelegate = self;
    
    _oldPasswordTextField.delegate=self;
    _PasswordTextField.delegate=self;
    _comfirmPassword.delegate=self;
    
    self.oldPasswordImageView.image  = [UIImage imageNamed:@"shurukuang.png"];
    [self.oldPasswordTextField becomeFirstResponder];
    
    [self.oldPasswordTextField setValue:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [self.PasswordTextField setValue:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [self.comfirmPassword setValue:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.oldPasswordTextField.placeholder = NSLocalizedString(@"Old Password", nil);
    self.PasswordTextField.placeholder = NSLocalizedString(@"New Password", nil);
    self.comfirmPassword.placeholder = NSLocalizedString(@"Confirm", nil);
    
//    self.inputBackImageView.layer.masksToBounds = YES;
//    self.inputBackImageView.layer.cornerRadius = 6;
//    self.inputBackImageView.backgroundColor = [UIColor colorWithRed:20/255.0 green:21/255.0 blue:23/255.0 alpha:1.0];
    MYGestureRecognizer * gesture = [[MYGestureRecognizer alloc] initWithTarget:self action:@selector(clearInputTextField)];
    [self.backImageView addGestureRecognizer:gesture];
    [gesture release];
}

- (void)clearInputTextField{
    
    [self.oldPasswordTextField resignFirstResponder];
    [self.PasswordTextField resignFirstResponder];
    [self.comfirmPassword resignFirstResponder];
    self.backImageView.userInteractionEnabled = NO;
}

- (void)changePasswordAction{
    
    [self correctAction:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [_oldPasswordTextField release];
    [_PasswordTextField release];
    [_comfirmPassword release];
    [_oldPasswordImageView release];
    [_passwordImageVIew release];
    [_oldpasswordLabel release];
    [_confirmPasswordLabel release];
    [_setNewPasswordLabel release];
    [_submitButton release];
    [_inputBackImageView release];
    [_backImageView release];
    [super dealloc];
}

- (void)viewDidUnload {
    
    [self setOldPasswordTextField:nil];
    [self setPasswordTextField:nil];
    [self setComfirmPassword:nil];
    [self setOldPasswordImageView:nil];
    [self setPasswordImageVIew:nil];
    [self setOldpasswordLabel:nil];
    [self setConfirmPasswordLabel:nil];
    [self setSetNewPasswordLabel:nil];
    [self setSubmitButton:nil];
    [self setInputBackImageView:nil];
    [self setBackImageView:nil];
    [super viewDidUnload];
    
}

- (void)correctAction:(id)sender {
    
    if ([_PasswordTextField.text length] < ACCOUNT_PASSWORD_MinLENGTH) {
        
        NSString * errorStr = NSLocalizedString(@"Password is at least 8 characters", nil);//@"Password is blank!";
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil
                                                          message:errorStr
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
        return;
    }
    
    if ([_oldPasswordTextField.text isEqualToString:@""]|[_PasswordTextField.text isEqualToString:@""]|[_comfirmPassword.text isEqualToString:@""])
    {
        
        [dealWithCommend noticeAlertView:NSLocalizedString(@"Information is incomplete", nil)];
    }
    else
    {
        
        if (![self.oldPasswordTextField.text isEqualToString:[MYDataManager shareManager].userInfoData.passwordStr]) {
            
            [dealWithCommend noticeAlertView:NSLocalizedString(@"Orginal password input error", nil)];
            return;
        }
        
        if ([_PasswordTextField.text isEqualToString:_comfirmPassword.text]) {
            
            [[AppDelegate getAppDelegate].mygcdSocketEngine sendModifyAccountPassword:self.oldPasswordTextField.text newPassword:self.PasswordTextField.text];
        }
        else
        {
            [dealWithCommend noticeAlertView:NSLocalizedString(@"Password Not match",nil)];
        }
    }
}

- (void)cancleAction:(id)sender {
    
    [self customDismissModalViewControllerAnimated:YES];
    
}

#pragma mark correctPasswordDelegate
-(void)correctPasswordSuccess
{
    [dealWithCommend noticeAlertView:NSLocalizedString(@"Change password success!", nil)];
    
    [MYDataManager shareManager].userInfoData.passwordStr = self.PasswordTextField.text;
    
    [[MYDataManager shareManager] saveAccountInfo];
    
    [self goBack];
}

-(void)correctPasswordFailed
{
    [dealWithCommend noticeAlertView:@"修改失败"];
}

#pragma mark textFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.backImageView.userInteractionEnabled = YES;
    return YES;
}

- (IBAction)submitButtonAction:(id)sender {
    
    [self changePasswordAction];
}
@end
