//
//  FindPasswordViewController.m
//  KCam
//
//  Created by myanycam on 2014/6/3.
//  Copyright (c) 2014年 Myanycam. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "AppDelegate.h"
#import "UINavigationItem+UINavigationItemTitle.h"
#import "navTitleLabel.h"


@interface FindPasswordViewController ()

@end

@implementation FindPasswordViewController

@synthesize emailTextFieldStr;


- (void)dealloc {
    
    [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.finedPwdDelegate = nil;
    self.emailTextFieldStr = nil;
    [_emailTextField release];
    [_sumitButton release];
    [_findPasswordnavigationBar release];
    [_findPasswordnavigationItem release];
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
    
    if ([ToolClass systemVersionFloat] >= 7.0) {
        
        CGRect fr = self.findPasswordnavigationBar.frame;
        fr.size.height = 64;
        self.findPasswordnavigationBar.frame = fr;
    }
    
    self.emailTextField.text = self.emailTextFieldStr;
    
    [self.findPasswordnavigationBar setBackgroundImage:[[UIImage imageNamed:@"topBar.png"] resizableImage] forBarMetrics:UIBarMetricsDefault];

    [self.findPasswordnavigationItem setCustomTitle:NSLocalizedString(@"Find Password", nil)];
    [self.sumitButton setTitle:NSLocalizedString(@"Find Password", nil) forState:UIControlStateNormal];
    

    NSString * imageNormalStr = @"icon_Return.png";
    NSString * imageSelectStr = @"icon_Return_hover.png";
    UIBarButtonItem * finishButton = [ViewToolClass customBarButtonItem:imageNormalStr
                                                      buttonSelectImage:imageSelectStr
                                                                  title:NSLocalizedString(@"", nil)
                                                                   size:CGSizeMake(32, 32)
                                                                 target:self
                                                                 action:@selector(goToBack)];
    self.findPasswordnavigationItem.leftBarButtonItem = finishButton;
    
    [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.finedPwdDelegate = self;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    
    [self setEmailTextField:nil];
    [self setSumitButton:nil];
    [self setFindPasswordnavigationBar:nil];
    [self setFindPasswordnavigationItem:nil];
    [super viewDidUnload];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    self.emailTextFieldStr = textField.text;
    
    if (![ToolClass checkEmail:self.emailTextField.text]) {
        
        [self showAutoDismissAlertView:NSLocalizedString(@"Email Format is Error", nil)];
        return NO;
    };
    
    [self sumbitButtonAction:nil];
    
    return YES;
}
- (IBAction)sumbitButtonAction:(id)sender {
    
    self.emailTextFieldStr = self.emailTextField.text;
    
    if (![ToolClass checkEmail:self.emailTextField.text]) {
        
        [self showAutoDismissAlertView:NSLocalizedString(@"Email Format is Error", nil)];
        return;
    };
    
   
    [self.emailTextField resignFirstResponder];
    
    [[AppDelegate getAppDelegate].mygcdSocketEngine sendGetPwdRequest:self.emailTextFieldStr];
}

- (void)getPasswordRespone:(NSDictionary *)data{
    
    NSInteger ret = [[data objectForKey:@"ret"] intValue];
    
    if (ret == 0)
    {
        NSString * tipMsg = NSLocalizedString(@"Get password success!", nil);
        NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"Find_PWD",KALERTTYPE,[NSNumber numberWithInt:0],@"ret", nil];
        MYAlertView *alertView=[[MYAlertView alloc] initWithTitle:NSLocalizedString(@"Congratulation", nil)
                                                          message:tipMsg
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                otherButtonTitles:nil];
        alertView.userInfo = userInfo;
        [alertView show];
        [alertView release];
    }
    else
    {
        NSString * tipMsg = NSLocalizedString(@"Email does not exist", nil);
        NSDictionary * userInfo =  [NSDictionary dictionaryWithObjectsAndKeys:@"Find_PWD",KALERTTYPE,[NSNumber numberWithInt:1],@"ret", nil];
        MYAlertView *alertView=[[MYAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil)
                                                          message:tipMsg
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                otherButtonTitles:nil];
        alertView.userInfo = userInfo;
        [alertView show];
        [alertView release];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ([alertView isKindOfClass:[MYAlertView class]]) {
        
        MYAlertView * alert = (MYAlertView *)alertView;
        if ([[alert.userInfo objectForKey:@"ret"] intValue] == 0) {
            
            if (buttonIndex == 0) {
                
                [[AppDelegate getAppDelegate].window exitApplication];
                
            }
        }
        if ([[alert.userInfo objectForKey:@"ret"] intValue] == 1) {
            
            if (buttonIndex == 0) {
                
                [self.emailTextField becomeFirstResponder];
            }
        }
    }
}



@end
