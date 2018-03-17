//
//  registViewController.m
//  myanycam
//
//  Created by myanycam on 13-1-9.
//  Copyright (c) 2013年 myanycam. All rights reserved.
//

#import "registViewController.h"
#import "AppDelegate.h"
#import "dealWithCommend.h"
#import "MyMD5.h"
#import "navButton.h"
#import "navTitleLabel.h"
#import "MYDataManager.h"
#import "UINavigationItem+UINavigationItemTitle.h"




@interface registViewController ()

@end

@implementation registViewController
@synthesize accountStr ;
@synthesize passwardStr ;
@synthesize delegate;

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
    [[self appDelegate] mygcdSocketEngine].dealObject.registDelegate=self;
    _accountTextField.delegate=self;
    _passwordTextField.delegate=self;
    _confirmPassword.delegate=self;
    
    if ([ToolClass systemVersionFloat] >= 7.0) {
        
        CGRect fr = _registNavBar.frame;
        fr.size.height = 64;
        _registNavBar.frame = fr;
    }

    [_registNavBar setBackgroundImage:[[UIImage imageNamed:@"topBar.png"] resizableImage] forBarMetrics:UIBarMetricsDefault];
    
//    navTitleLabel *titleLabel=[[navTitleLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44) title:NSLocalizedString(@"Register", nil)];
//    _registNavItem.titleView=titleLabel;
//    [titleLabel release];
    
    NSString * imageNormalStr = @"icon_Return.png";
    NSString * imageSelectStr = @"icon_Return_hover.png";
    UIBarButtonItem * finishButton = [ViewToolClass customBarButtonItem:imageNormalStr
                                                      buttonSelectImage:imageSelectStr
                                                                  title:NSLocalizedString(@"", nil)
                                                                   size:CGSizeMake(32, 32)
                                                                 target:self
                                                                 action:@selector(goToBack)];
    _registNavItem.leftBarButtonItem = finishButton;
    
//    self.registNavItem.title = NSLocalizedString(@"Register", nil);
    [self.registNavItem setCustomTitle:NSLocalizedString(@"Register", nil)];
    [self.registerButton setTitleWithStr:NSLocalizedString(@"Submit_", nil) fontSize:FONT_SIZE];
    

    
    [self.accountTextField setValue:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordTextField setValue:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [self.confirmPassword setValue:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.accountTextField.placeholder = NSLocalizedString(@"Email",nil);
    self.passwordTextField.placeholder = NSLocalizedString(@"Input Password",nil);
    self.confirmPassword.placeholder = NSLocalizedString(@"Confirm",nil);
    
    MYGestureRecognizer * gesture = [[MYGestureRecognizer alloc] initWithTarget:self action:@selector(clearInputTextField)];
    [self.topBackImageView addGestureRecognizer:gesture];
    [gesture release];
    
    [self.accountTextField becomeFirstResponder];
}

- (void)clearInputTextField{
    
    [self.accountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.confirmPassword resignFirstResponder];
    self.topBackImageView.userInteractionEnabled = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_accountTextField release];
    [_passwordTextField release];
    [_confirmPassword release];
    [_registNavBar release];
    [_registNavItem release];
    [_inputBigImageView release];
    [_inputBigView release];
    [_registerButton release];
    self.passwardStr = nil;
    self.accountStr = nil;
    [_topBackImageView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setAccountTextField:nil];
    [self setPasswordTextField:nil];
    [self setConfirmPassword:nil];
    [self setRegistNavBar:nil];
    [self setRegistNavItem:nil];
    [self setInputBigImageView:nil];
    [self setInputBigView:nil];
    [self setRegisterButton:nil];
    [self setTopBackImageView:nil];
    [super viewDidUnload];
}

//-(void)backAction
//{
//    [self customDismissModalViewControllerAnimated:YES];
//}

- (IBAction)registAction:(id)sender {
    
    NSString * errorStr = nil;
    
    if (self.accountTextField.text&&[self.accountTextField.text length] > 0 &&  ([ToolClass checkEmail:self.accountTextField.text]) ) {
        

    
        if ([_passwordTextField.text length] >= ACCOUNT_PASSWORD_MinLENGTH )
        {
            
            if ([_passwordTextField.text length] > 0 &&[_passwordTextField.text isEqualToString:_confirmPassword.text]) {
                
                self.accountStr = self.accountTextField.text;
                self.passwardStr = self.passwordTextField.text;
                
                
                [[[self appDelegate] mygcdSocketEngine] writeDataOnMainThread:[BuildSocketData buildRegisterString:self.accountStr password:self.passwardStr] tag:0 waitView:YES];
                
                
                [self.accountTextField resignFirstResponder];
                [self.passwordTextField resignFirstResponder];
                [self.confirmPassword resignFirstResponder];
                
                return;
            }
            else{
                
                errorStr = NSLocalizedString(@"Password Not match", nil);//@"您输入的两次密码不一致!";
            }
        }
        else{
            
            errorStr = NSLocalizedString(@"Password is at least 8 characters", nil);//@"Password is blank!";

        }

    }
    else{
        errorStr = NSLocalizedString(@"Email error", nil);//@"邮箱输入错误!";
    }
    
    
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil
                                                          message:errorStr
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    
}

- (IBAction)resetAction:(id)sender {
    
    _accountTextField.text=@"";
    _passwordTextField.text=@"";
    [_accountTextField becomeFirstResponder];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(registSuccess)]) {
            
            [MYDataManager shareManager].userInfoData.accountIdStr = self.accountStr;
            [MYDataManager shareManager].userInfoData.passwordStr = self.passwardStr;
            
            [[NSUserDefaults standardUserDefaults] setObject:self.accountStr forKey:@"account"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
            [[MYDataManager shareManager] saveAccountAndPassword:self.accountStr password:self.passwardStr];
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isRember"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.delegate registSuccess];
        }
        
        [self customDismissModalViewControllerAnimated:YES];
    }
}

-(void)registSuccess
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil
                                                          message:NSLocalizedString(@"Register Success", nil)
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    });

}
-(void)registFailed
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil
                                                          message:NSLocalizedString(@"Email already exists", nil)
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    });
}

#pragma mark textfielddelegetes
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.topBackImageView.userInteractionEnabled = YES;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.passwordTextField) {
        
        if ([textField.text length] == ACCOUNT_PASSWORD_MaxLENGTH && [string length] > 0) {
            
            return NO;
        }
    }
    
    return YES;
}

@end
