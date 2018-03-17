//
//  WifiSettingViewController.h
//  myanycam
//
//  Created by myanycam on 13-2-25.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"
#import "WifiInfoData.h"
#import "KLSwitch.h"

@interface WifiSettingViewController :BaseViewController <WifiSettingDelegate,UITextFieldDelegate>{
    NSString         *_wifiNameStr;
    NSString         *_passwordStr;
    WifiInfoData     *_wifiInfoData;
    NSMutableArray   *_wifiSafetyArray;
}

@property (retain, nonatomic) CameraInfoData * cameraInfo;
@property (retain, nonatomic) IBOutlet UILabel *wifiSafeStateLabel;
@property (retain, nonatomic) WifiInfoData   * wifiInfoData;
@property (retain, nonatomic) NSMutableArray * wifiSafetyArray;
@property (retain, nonatomic) IBOutlet UIImageView *toolBarImageView;
@property (retain, nonatomic) NSString *wifiNameStr;
@property (retain, nonatomic) NSString *passwordStr;
@property (retain, nonatomic) IBOutlet UITextField *wifiNameTextField;
@property (retain, nonatomic) IBOutlet UITextField *wifiPasswordTextField;
@property (retain, nonatomic) IBOutlet UIImageView *safeStylebgImageView;
@property (retain, nonatomic) IBOutlet UIImageView *wifiInputBackImageView;
@property (retain, nonatomic) IBOutlet UIImageView *passwordInputBackImageView;
@property (retain, nonatomic) IBOutlet UISwitch *showPasswordSwitch;
@property (retain, nonatomic) IBOutlet UILabel *showPasswordLabel;
@property (retain, nonatomic) IBOutlet UILabel *safetyLabel;
@property (retain, nonatomic) IBOutlet UILabel *passwordLabel;
@property (retain, nonatomic) NSMutableArray * wifiDataArray;
@property (retain, nonatomic) IBOutlet KLSwitch *showPwdSwitch;


- (IBAction)showpasswordSwitchAction:(id)sender;

@end
