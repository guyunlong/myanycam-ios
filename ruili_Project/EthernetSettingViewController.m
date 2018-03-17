//
//  EthernetSettingViewController.m
//  myanycam
//
//  Created by myanycam on 13-2-25.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "EthernetSettingViewController.h"
#import "dealWithCommend.h"
#import "AppDelegate.h"

@interface EthernetSettingViewController ()

@end

@implementation EthernetSettingViewController
@synthesize currentTextField = _currentTextField;
@synthesize ipAddressStr = _ipAddressStr;
@synthesize subNetMaskStr = _subNetMaskStr;
@synthesize defualtGateWayStr = _defualtGateWayStr;
@synthesize firstDNSStr = _firstDNSStr;
@synthesize secondDNSStr = _secondDNSStr;
@synthesize ethernetInfoData = _ethernetInfoData;
@synthesize cameraData = _cameraData;

- (void)dealloc {

    self.ethernetInfoData = nil;
    self.currentTextField = nil;
    self.ipAddressStr = nil;
    self.subNetMaskStr = nil;
    self.defualtGateWayStr = nil;
    self.firstDNSTextField = nil;
    self.secondDNSStr = nil;
    self.cameraData = nil;
    
    [_inputBigView release];
    [_autoGetIpSwitch release];
    [_inputBgScrollView release];
    [_ipAddressTextField release];
    [_subNetMaskTextField release];
    [_defualtGateWayTextField release];
    [_firstDNSTextField release];
    [_secondDNSTextField release];
    [_finishButton release];
    [_autoGetIpAddressLabel release];
    [_ipAddressLabel release];
    [_subnetMaskLabel release];
    [_routerLabel release];
    [_dns1Label release];
    [_dns2Label release];
    [_customSwitch release];
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
    
    self.inputBigView.layer.masksToBounds = YES;
    self.inputBigView.layer.cornerRadius = 6;
    [self.customSwitch setDidChangeHandler:^(BOOL isOn){
        
        [self doSwitchControl:nil];
    }];
    
//    [self.autoGetIpSwitch addTarget:self action:@selector(doSwitchControl:) forControlEvents:UIControlEventValueChanged];
    self.inputBgScrollView.contentSize = CGSizeMake(320, 470);
    
    [self appDelegate].mygcdSocketEngine.dealObject.ethernetSettingDelegate = self;
    [[self appDelegate].mygcdSocketEngine sendGetNetInfoRequest:self.cameraData.cameraId];
    
    NSString * imageNormalStr = @"icon_Return.png";
    NSString * imageSelectStr = @"icon_Return_hover.png";
    UIBarButtonItem *backButton = [ViewToolClass customBarButtonItem:imageNormalStr buttonSelectImage:imageSelectStr title:NSLocalizedString(@"", nil) size:CGSizeMake(32, 32) target:self action:@selector(doSaveEthernetSet)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.autoGetIpAddressLabel.text = NSLocalizedString(@"auto ip", nil);
    self.ipAddressTextField.placeholder = NSLocalizedString(@"IP Address", nil);
    self.subNetMaskTextField.placeholder = NSLocalizedString(@"Subnet Mask", nil);
    self.defualtGateWayTextField.placeholder = NSLocalizedString(@"Gateway", nil);
    self.firstDNSTextField.placeholder = NSLocalizedString(@"Preferred DNS", nil);
    self.secondDNSTextField.placeholder = NSLocalizedString(@"Reserved DNS", nil);
    
    self.ipAddressLabel.text = NSLocalizedString(@"IP Address", nil);
    self.subnetMaskLabel.text =NSLocalizedString(@"Subnet Mask", nil);
    self.routerLabel.text = NSLocalizedString(@"Gateway", nil);
    self.dns1Label.text = NSLocalizedString(@"Preferred DNS", nil);
    self.dns2Label.text = NSLocalizedString(@"Reserved DNS", nil);
    
    
    CGSize size = self.inputBgScrollView.contentSize;
    size.height = size.height + 160;
    self.inputBgScrollView.contentSize = size;
    
}

- (void)updateView{
 
    self.ipAddressTextField.text = self.ethernetInfoData.ipAddress;
    self.subNetMaskTextField.text = self.ethernetInfoData.maskAddress;
    self.defualtGateWayTextField.text = self.ethernetInfoData.netgateAddress;
    self.firstDNSTextField.text = self.ethernetInfoData.dns1Address;
    self.secondDNSTextField.text = self.ethernetInfoData.dns2Address;
    
//    [self.autoGetIpSwitch setOn:(self.ethernetInfoData.dhcp == 1?YES:NO)];
    [self.customSwitch setOn:(self.ethernetInfoData.dhcp == 1?YES:NO)];
    
    [self doSwitchControl:nil];
    
    [self updateEthernetData];
    
}

- (void)updateEthernetData{
    
    self.ipAddressStr = self.ipAddressTextField.text;
    self.subNetMaskStr = self.subNetMaskTextField.text;
    self.defualtGateWayStr = self.defualtGateWayTextField.text;
    self.firstDNSStr = self.firstDNSTextField.text ;
    self.secondDNSStr = self.secondDNSTextField.text;
}

- (void)doSaveEthernetSet{
    
    [self updateEthernetData];
    
    NSString * dhcp = @"0";
    if (self.customSwitch.isOn) {
        
        dhcp = @"1";
    }
    else{
        
        NSString * errorTip = [self checkIpAddressRight];
        if ( errorTip!= nil) {
            
            [self showAlertView:nil alertMsg:errorTip userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"Sure", nil) otherButtonTitles:nil];
            
            return;
        }
    }
    
    if ([[self appDelegate].mygcdSocketEngine isConnect]) {
        
        [[self appDelegate].mygcdSocketEngine sendSetEthernetRequest:dhcp ip:self.ipAddressStr mask:self.subNetMaskStr gateWay:self.defualtGateWayStr dns1:self.firstDNSStr dns2:self.secondDNSStr cameraid:self.cameraData.cameraId];
    }
    else{
        
        [self goBack];
    }

}

- (NSString *)checkIpAddressRight{
    
    NSString * regex = @"((25[0-5])|(2[0-4]\\d)|(1\\d\\d)|([1-9]\\d)|\\d)(\\.((25[0-5])|(2[0-4]\\d)|(1\\d\\d)|([1-9]\\d)|\\d)){3}";
    
//    NSString *regex = @"[\\d|a-z|A-Z|-|_|\\.]+\\.{0,1}[\\d|a-z|A-Z]+@[\\d|a-z|A-Z|-|_|\\.]+[a-z|A-Z]{2,3}";
    
    
    
    self.ipAddressLabel.text = NSLocalizedString(@"IP Address", nil);
    self.subnetMaskLabel.text =NSLocalizedString(@"Subnet Mask", nil);
    self.routerLabel.text = NSLocalizedString(@"Gateway", nil);
    self.dns1Label.text = NSLocalizedString(@"Preferred DNS", nil);
    self.dns2Label.text = NSLocalizedString(@"Reserved DNS", nil);
    
    NSPredicate *regextest = [NSPredicate
                              predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([regextest evaluateWithObject:self.ipAddressStr] == NO)
    {
        DebugLog(@"IP地址不正确 = %@", self.ipAddressStr);
        
        return NSLocalizedString(@"IP Address is Wrong", nil);
        
    }
    
    if ([regextest evaluateWithObject:self.subNetMaskStr] == NO)
    {
        DebugLog(@"子网掩码不正确 = %@", self.subNetMaskStr);
         return NSLocalizedString(@"Subnet Mask is Wrong", nil);
    }
    
    if ([regextest evaluateWithObject:self.defualtGateWayStr] == NO)
    {
        DebugLog(@"默认网关不正确 = %@", self.defualtGateWayStr);
        return NSLocalizedString(@"Gateway is Wrong", nil);
    }
    if ([regextest evaluateWithObject:self.firstDNSStr] == NO)
    {
        DebugLog(@"首选DNS不正确 = %@", self.firstDNSStr);
        return NSLocalizedString(@"Preferred DNS is Wrong", nil);
        
    }
    
    if ([regextest evaluateWithObject:self.secondDNSStr] == NO)
    {
        DebugLog(@"备用DNS不正确 = %@", self.secondDNSStr);
        if (![self.secondDNSStr isEqualToString:@""]) {
            
            return NSLocalizedString(@"Reserved DNS is Wrong", nil);
        }
        
    }
    
    return nil;
}
- (void)doSwitchControl:(id)sender{
    
//    if ([sender isKindOfClass:[KLSwitch class]])
    {
        
        BOOL isOn = self.customSwitch.isOn;//self.autoGetIpSwitch.isOn;
        
        if (isOn) {
            [self.inputBigView customHideWithAnimation:YES duration:0.3];
            [self.currentTextField resignFirstResponder];
        }
        else{
            [self.inputBigView customShowWithAnimation:YES duration:0.3];
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.currentTextField = textField;
    if (self.defualtGateWayTextField == textField ||
        self.firstDNSTextField == textField ||
        self.secondDNSTextField == textField)  {
        
      if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
          
          CGPoint point = CGPointMake(0, -170);
          [self.view customMoveYWithAnimation:point];
      }

    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    if (textField) {
        CGPoint point = CGPointMake(0, 0);
        [self.view customMoveYWithAnimation:point];
    }
    
    switch (textField.tag) {
        case 0:
        {
            self.ipAddressStr = textField.text;
        }
            break;
        case 1:
        {
            self.subNetMaskStr = textField.text;
        }
            break;
        case 2:
        {
            self.defualtGateWayStr = textField.text;
        }
            break;
        case 3:
        {
            self.firstDNSStr = textField.text;
        }
            break;
        case 4:
        {
            self.secondDNSStr = textField.text;
        }
            break;
        default:
            break;
    }
    
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setInputBigView:nil];
    [self setAutoGetIpSwitch:nil];
    [self setInputBgScrollView:nil];
    [self setIpAddressTextField:nil];
    [self setSubNetMaskTextField:nil];
    [self setDefualtGateWayTextField:nil];
    [self setFirstDNSTextField:nil];
    [self setSecondDNSTextField:nil];
    [self setFinishButton:nil];
    [self setAutoGetIpAddressLabel:nil];
    [self setIpAddressLabel:nil];
    [self setSubnetMaskLabel:nil];
    [self setRouterLabel:nil];
    [self setDns1Label:nil];
    [self setDns2Label:nil];
    [self setCustomSwitch:nil];
    [super viewDidUnload];
}

- (void)ethernetSettingSuccess:(NSDictionary *)dat{
    
    
    [[self appDelegate].window hideWaitAlertView];
    
    if ([[dat objectForKey:@"ret"] intValue] == 0) {
        
        [self goBack];
    }
    else{
        
       	NSString *title = NSLocalizedString(@"Error", nil);
        NSString *message = NSLocalizedString(@"Set Error", nil);
        [self showAskAlertView:title msg:message userInfo:nil];
    }

}


- (void)cancelButtonAction:(NSDictionary *)info{
    
     [self goBack];
}

- (void)alertView:(AHAlertView *)alertView otherButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        [self doSaveEthernetSet];
    }
}

- (void)getEthernetInfoSuccess:(NSDictionary *)dat{
    
    DebugLog(@"dat = %@",dat);
    
    [[MYDataManager shareManager] updateEthernetInfo:dat];
    
    self.ethernetInfoData = [MYDataManager shareManager].ethernetInfo;
    dispatch_async(dispatch_get_main_queue(), ^{
        
           [self updateView];
    });

    [[self appDelegate].window hideWaitAlertView];
    
}
- (void)updateEthernetTextFieldView{
    
    self.ipAddressTextField.text = self.ethernetInfoData.ipAddress;
    self.defualtGateWayTextField.text = self.ethernetInfoData.netgateAddress;
    self.subNetMaskTextField.text = self.ethernetInfoData.maskAddress;
    self.firstDNSTextField.text = self.ethernetInfoData.dns1Address;
    self.secondDNSTextField.text = self.ethernetInfoData.dns2Address;
    
}

- (IBAction)finishButtonAction:(id)sender {
    
    [self checkIpAddressRight];
    
}
@end
