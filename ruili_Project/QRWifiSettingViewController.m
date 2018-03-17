//
//  QRWifiSettingViewController.m
//  Myanycam
//
//  Created by myanycam on 13/11/21.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "QRWifiSettingViewController.h"
#import "QRCodeGenerator.h"
#import "MYDataManager.h"




@interface QRWifiSettingViewController ()

@end

@implementation QRWifiSettingViewController
@synthesize qrshowImageView;

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
    
    // sample
    //QRWifiSettingViewController
    //wifi:S:TP-myanycam;P:myanycam168;
    
    NSDictionary *  wifi = [ToolClass fetchSSIDInfo];
    if (wifi) {
        
        NSString * currentWifi =  [wifi objectForKey:@"SSID"];
        [MYDataManager shareManager].currentWifi = currentWifi;
        if (currentWifi) {
            
            self.wifiNameTextfiled.text = currentWifi;
        }
    }
    
    [self showBackButton:nil action:nil buttonTitle:nil];
    
    self.wifiNameTextfiled.delegate = self;
    self.passwordTextField.delegate = self;
    self.inputView.layer.masksToBounds = YES;
    self.inputView.layer.cornerRadius = 6;

    UIColor * BlueColor = [UIColor colorWithRed:91/255.0 green:169/255.0 blue:252/255.0 alpha:1.0];
    [self.inputView addBorderToView:BlueColor borderWidth:2.0 cornerRadius:6.0];
    UIImage * buttonNorImage = [[UIImage imageNamed:@"smile_bottom_transmit_nor@2x.png"] resizableImage];
    UIImage * buttonPressImage = [[UIImage imageNamed:@"smile_bottom_transmit_press@2x.png"] resizableImage];
    [self.generateQRbutton setButtonBgImage:buttonNorImage highlight:buttonPressImage];
    
    self.showPasswordLabel.text =  NSLocalizedString(@"Show Password", nil);
    
    self.qrscanLabel.text = NSLocalizedString(@"Put QR code in front of the Camera", nil);
    self.qrscanLabel.hidden = YES;
    
}


- (void)showQRcodeImageView{
    
    
    if ([self.wifiNameTextfiled.text length] == 0) {
        
        [self showAlertView:@"Alert" alertMsg:NSLocalizedString(@"Please input WIFI name.", nil) userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        
        return;
    }
    
    
    if ([self.passwordTextField.text length] < 6) {
        
        if ([self.passwordTextField.text length] == 0) {
            
            [self showAlertView:@"Alert" alertMsg:NSLocalizedString(@"Password Blank", nil) userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            
            return;
        }
        
        if ([self.passwordTextField.text length] < ACCOUNT_PASSWORD_MinLENGTH ) {
            
            [self showAlertView:@"Alert" alertMsg:NSLocalizedString(@"Password is at least 8 characters", nil) userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            return;
        }
    }
    
    
    [self.qrshowImageView removeFromSuperview];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, self.inputView.frame.origin.y + self.inputView.frame.size.height + 30, 260, 260)];
    imageView.image = [QRCodeGenerator qrImageForString:[NSString stringWithFormat:KQRWIFIFormatStr,self.wifiNameTextfiled.text,self.passwordTextField.text] imageSize:imageView.bounds.size.width];
    [self.backview addSubview:imageView];
    self.qrshowImageView = imageView;
    [imageView release];
    self.qrscanLabel.hidden = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == self.passwordTextField) {
        
        [self showQRcodeImageView];
        [textField resignFirstResponder];
    }
    
    if (textField == self.wifiNameTextfiled) {
        
        [self.passwordTextField becomeFirstResponder];
    }

    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {

    self.qrshowImageView = nil;
    
    [_generateQRbutton release];
    [_wifiNameTextfiled release];
    [_passwordTextField release];
    [_inputView release];
    [_backview release];
    [_showPasswordLabel release];
    [_showPassword release];
    [_qrscanLabel release];
    [super dealloc];
}

- (void)viewDidUnload {

    [self setGenerateQRbutton:nil];
    [self setWifiNameTextfiled:nil];
    [self setPasswordTextField:nil];
    [self setInputView:nil];
    [self setBackview:nil];
    [self setShowPasswordLabel:nil];
    [self setShowPassword:nil];
    [self setQrscanLabel:nil];
    [super viewDidUnload];
}
- (IBAction)generateQRbuttonAction:(id)sender {
    
    [self showQRcodeImageView];
}


- (IBAction)showPasswordAction:(id)sender {
    
    NSString * password = self.passwordTextField.text;
    [self.passwordTextField resignFirstResponder];
    self.passwordTextField.secureTextEntry = !self.showPassword.isOn;
    [self.passwordTextField becomeFirstResponder];
    self.passwordTextField.text = password;
}
@end
