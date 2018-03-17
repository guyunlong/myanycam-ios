//
//  WifiSettingViewController.m
//  myanycam
//
//  Created by myanycam on 13-2-25.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "WifiSettingViewController.h"
#import "AppDelegate.h"

@interface WifiSettingViewController ()

@end

@implementation WifiSettingViewController
@synthesize wifiNameStr = _wifiNameStr;
@synthesize passwordStr = _passwordStr;
@synthesize wifiInfoData = _wifiInfoData;
@synthesize wifiSafetyArray = _wifiSafetyArray;
@synthesize cameraInfo;

- (void)dealloc {
    
    self.wifiDataArray = nil;
    self.cameraInfo = nil;
    self.wifiNameStr = nil;
    self.passwordStr = nil;
    self.wifiInfoData = nil;
    self.wifiSafetyArray = nil;
    [_wifiNameTextField release];
    [_wifiPasswordTextField release];
    [_safeStylebgImageView release];
    [_toolBarImageView release];
    [_wifiSafeStateLabel release];
    [_wifiInputBackImageView release];
    [_passwordInputBackImageView release];
    [_showPasswordSwitch release];
    [_showPasswordLabel release];
    [_safetyLabel release];
    [_passwordLabel release];
    [_showPwdSwitch release];
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

-(AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self prepareData];
    
    self.wifiSafeStateLabel.text = [self.wifiSafetyArray objectAtIndex:self.wifiInfoData.safety];
    self.wifiPasswordTextField.secureTextEntry = YES;
    
    [self showBackButton:self action:nil buttonTitle:@""];
    
    NSString * imageNormalStr = @"buttonNormal.png";
    NSString * imageSelectStr = @"buttonSelect.png";
    UIBarButtonItem *backButton = [ViewToolClass customBarButtonItem:imageNormalStr buttonSelectImage:imageSelectStr title:NSLocalizedString(@"Done", nil) size:CGSizeMake(74, 30) target:self  action:@selector(saveWifiSetting)];
    self.navigationItem.rightBarButtonItem = backButton;
    
    
//    UIImage * imageInputTextField = [[UIImage imageNamed:@"chat_bottom_textfield@2x.png"] resizableImage];
//    self.passwordInputBackImageView.image = imageInputTextField;
//    self.safeStylebgImageView.image = imageInputTextField;
//    self.wifiInputBackImageView.image = imageInputTextField;
    self.wifiNameTextField.placeholder = NSLocalizedString(@"WIFI name", nil);
    self.wifiPasswordTextField.placeholder = NSLocalizedString(@"Password", nil);
    
    [self.wifiNameTextField setValue:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [self.wifiPasswordTextField setValue:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];

    
    if (self.wifiInfoData.isManualAdd) {
        
        [self.wifiNameTextField becomeFirstResponder];
        
    }
    else
    {
         [self.wifiPasswordTextField becomeFirstResponder];
    }
    
    self.showPasswordLabel.text = NSLocalizedString(@"Show Password", nil);
    self.safetyLabel.text = NSLocalizedString(@"Safety", nil);
    self.passwordLabel.text = NSLocalizedString(@"Password", nil);
    
    [self.showPwdSwitch setOn:NO];
    [self.showPwdSwitch setDidChangeHandler:^(BOOL isOn){
        
        [self showpasswordSwitchAction:nil];
    }];
    
}

- (void)saveWifiSetting{
    
    
    if ([[self appDelegate].mygcdSocketEngine.gcdAsyncsocket isConnected]) {
        
        self.passwordStr = self.wifiPasswordTextField.text?self.wifiPasswordTextField.text:@"";
        self.wifiNameStr = self.wifiNameTextField.text;
        
        
        if (self.wifiInfoData.safety != 0 ) {
            
            if ([self.wifiPasswordTextField.text length] == 0) {
                
                [self showAlertView:NSLocalizedString(@"Alert", nil) alertMsg:NSLocalizedString(@"Password Blank", nil) userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
                
                return;
            }
            
            if ([self.wifiPasswordTextField.text length] < ACCOUNT_PASSWORD_MinLENGTH ) {
                
                [self showAlertView:NSLocalizedString(@"Alert", nil) alertMsg:NSLocalizedString(@"Password is at least 8 characters", nil) userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
                return;
            }
        }
        
        if ([self.wifiNameStr length] == 0) {
            
            [self showAlertView:NSLocalizedString(@"Alert", nil) alertMsg:NSLocalizedString(@"WIFI name cannot be blank！", nil) userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            
            return;

        }
        
        
        [self appDelegate].mygcdSocketEngine.dealObject.wifiSettingDelegate = self;
        [[self appDelegate].mygcdSocketEngine sendSetWifiInfoRequest:@"1" ssid:self.wifiNameStr safety:[NSString stringWithFormat:@"%d",self.wifiInfoData.safety] password:self.passwordStr cameraid:self.cameraInfo.cameraId];
    }
    else{
        
        [self goBack];
    }
    
}

- (void)prepareData{
    
    self.wifiNameStr = self.wifiInfoData.ssid;
    self.passwordStr = self.wifiInfoData.password;
    self.wifiNameTextField.text = self.wifiNameStr;
    self.wifiPasswordTextField.text = self.passwordStr;
    self.wifiSafetyArray = [NSMutableArray arrayWithCapacity:3];
    [self.wifiSafetyArray addObject:NSLocalizedString(@"None", nil)];
    [self.wifiSafetyArray addObject:@"WPA"];
    [self.wifiSafetyArray addObject:@"WPA2"];
    [self.wifiSafetyArray addObject:@"WPA/WPA2"];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.wifiPasswordTextField) {
        self.passwordStr = self.wifiPasswordTextField.text;
    }
    if (textField == self.wifiNameTextField ) {
        self.wifiNameStr = self.wifiNameTextField.text;
    }
    
    [self saveWifiSetting];
        
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    return YES;
}


- (void)wifiSettingSuccess:(NSMutableDictionary *)dat{
    
    [[self appDelegate].window hideWaitAlertView];
    
    if ([[dat objectForKey:@"ret"] intValue] == 0) {
        
        if (self.wifiInfoData.isManualAdd) {
            
            self.wifiInfoData.ssid = self.wifiNameStr;
            self.wifiInfoData.password = self.passwordStr;
            
            BOOL flag = NO;
            
            for (WifiInfoData * data in self.wifiDataArray) {
                if ([data.ssid isEqualToString:self.wifiInfoData.ssid]) {
                    
                    flag = YES;
                    break;
                }
            }
            
            if (!flag) {
                
                [self.wifiDataArray insertObject:self.wifiInfoData atIndex:0];
            }
        }
        
        [MYDataManager shareManager].currnetWifiData.password = nil;
        self.wifiInfoData.password = self.passwordStr;
        [MYDataManager shareManager].currnetWifiData = self.wifiInfoData;
        
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
        
        [self saveWifiSetting];
    }
}

- (void)cancelButtonAction:(NSDictionary *)info{
    
    [self goBack];
}

- (void)viewDidUnload {
    
    [self setWifiNameTextField:nil];
    [self setWifiPasswordTextField:nil];
    [self setSafeStylebgImageView:nil];
    [self setToolBarImageView:nil];
    [self setWifiSafeStateLabel:nil];
    [self setWifiInputBackImageView:nil];
    [self setPasswordInputBackImageView:nil];
    [self setShowPasswordSwitch:nil];
    [self setShowPasswordLabel:nil];
    [self setSafetyLabel:nil];
    [self setPasswordLabel:nil];
    [self setShowPwdSwitch:nil];
    [super viewDidUnload];
    
}
- (IBAction)showpasswordSwitchAction:(id)sender {
    
    self.passwordStr = self.wifiPasswordTextField.text;
 
    [self.wifiPasswordTextField resignFirstResponder];
    self.wifiPasswordTextField.secureTextEntry = !self.showPwdSwitch.isOn;
    [self.wifiPasswordTextField becomeFirstResponder];
    self.wifiPasswordTextField.text = self.passwordStr;
    
}
@end
