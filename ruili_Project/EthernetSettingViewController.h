//
//  EthernetSettingViewController.h
//  myanycam
//
//  Created by myanycam on 13-2-25.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dealWithData.h"
#import "EthernetSettingViewDelegate.h"
#import "EthernetInfoData.h"
#import "KLSwitch.h"


@interface EthernetSettingViewController : BaseViewController<UITextFieldDelegate,EthernetSettingViewDelegate>{
    
    UITextField         *_currentTextField;
    NSString            *_ipAddressStr;
    NSString            *_subNetMaskStr;
    NSString            *_defualtGateWayStr;
    NSString            *_firstDNSStr;
    NSString            *_secondDNSStr;
    EthernetInfoData            *_ethernetInfoData;
    CameraInfoData          *_cameraData;
    
}

@property (retain, nonatomic) EthernetInfoData     * ethernetInfoData;
@property (retain, nonatomic) CameraInfoData           * cameraData;
@property (retain, nonatomic) NSString     * ipAddressStr;
@property (retain, nonatomic) NSString     * subNetMaskStr;
@property (retain, nonatomic) NSString     * defualtGateWayStr;
@property (retain, nonatomic) NSString     * firstDNSStr;
@property (retain, nonatomic) NSString     * secondDNSStr;

@property (retain, nonatomic) IBOutlet KLSwitch *customSwitch;
@property (retain, nonatomic) IBOutlet UILabel *autoGetIpAddressLabel;
@property (retain, nonatomic) UITextField  * currentTextField;
@property (retain, nonatomic) IBOutlet UIView *inputBigView;
@property (retain, nonatomic) IBOutlet UISwitch *autoGetIpSwitch;
@property (retain, nonatomic) IBOutlet UIScrollView *inputBgScrollView;
@property (retain, nonatomic) IBOutlet UITextField *ipAddressTextField;
@property (retain, nonatomic) IBOutlet UITextField *subNetMaskTextField;
@property (retain, nonatomic) IBOutlet UITextField *defualtGateWayTextField;
@property (retain, nonatomic) IBOutlet UITextField *firstDNSTextField;
@property (retain, nonatomic) IBOutlet UITextField *secondDNSTextField;
@property (retain, nonatomic) IBOutlet UIButton *finishButton;


@property (retain, nonatomic) IBOutlet UILabel *ipAddressLabel;
@property (retain, nonatomic) IBOutlet UILabel *subnetMaskLabel;
@property (retain, nonatomic) IBOutlet UILabel *routerLabel;
@property (retain, nonatomic) IBOutlet UILabel *dns1Label;
@property (retain, nonatomic) IBOutlet UILabel *dns2Label;


- (IBAction)finishButtonAction:(id)sender;

@end
