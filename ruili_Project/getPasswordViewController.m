//
//  getPasswordViewController.m
//  myanycam
//
//  Created by 中程 on 13-1-9.
//  Copyright (c) 2013年 中程. All rights reserved.
//

#import "getPasswordViewController.h"
#import "dealWithCommend.h"
#import "AppDelegate.h"
#import "navButton.h"
#import "navTitleLabel.h"

@interface getPasswordViewController ()

@end

@implementation getPasswordViewController

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
//    [[self appDelegate] mygcdSocketEngine].dealObject._getPasswordDelegate=self;
    
    UIImage * bg = [[UIImage imageNamed:@"topBar.png"] resizableImage];
    [_getPasswordNavBar setBackgroundImage:bg forBarMetrics:UIBarMetricsDefault];
    
    navTitleLabel *titleLabel=[[navTitleLabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44) title:@"Get Password"];
    _getPassowrdNavItem.titleView=titleLabel;
    [titleLabel release];
    
    navButton *leftBtnView=[[navButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30) bgImage:@"ui_back.png" title:@"" target:self select:@selector(backAction)];
    UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc] initWithCustomView:leftBtnView];
    _getPassowrdNavItem.leftBarButtonItem=leftBtn;
    [leftBtnView release];[leftBtn release];
    // Do any additional setup after loading the view from its nib.
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
    [_getPasswordNavBar release];
    [_getPassowrdNavItem release];
    [_getPasswordWebView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setAccountTextField:nil];
    [self setGetPasswordNavBar:nil];
    [self setGetPassowrdNavItem:nil];
    [self setGetPasswordWebView:nil];
    [super viewDidUnload];
}
-(void)backAction
{
    [self customDismissModalViewControllerAnimated:YES];
}
- (IBAction)getPasswordAction:(id)sender {
    if (![_accountTextField.text isEqualToString:@""]) {
        NSString *cmd=@"";
        cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
        cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"GET_PWD"];
        cmd=[dealWithCommend addElement:cmd eName:@"account" eData:_accountTextField.text];
        
        [[[self appDelegate] mygcdSocketEngine] writeDataOnMainThread:cmd tag:0  waitView:YES];
        
        [dealWithCommend noticeAlertView:@"请求已发送，请等待"];
    }
    else
    {
        [dealWithCommend noticeAlertView:@"请填入您的帐户！"];
    }
}

#pragma mark getPasswordDelegate

-(void)getPasswordSuccess
{
    [dealWithCommend noticeAlertView:@"申请成功，请查收您邮箱的邮件～"];
    [self customDismissModalViewControllerAnimated:YES];
}
-(void)getPasswordFailed
{
    [dealWithCommend noticeAlertView:@""];
}
#pragma mark textFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
