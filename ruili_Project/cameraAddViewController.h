//
//  cameraAddViewController.h
//  myanycam
//
//  Created by 中程 on 13-1-15.
//  Copyright (c) 2013年 中程. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cameraAddDelegate.h"
#import "ZXingWidgetController.h"



@interface cameraAddViewController : BaseViewController<UIAlertViewDelegate,cameraAddDelegate,UITextFieldDelegate>

@property (retain, nonatomic) ZXingWidgetController * zxingController;
@property (retain, nonatomic) IBOutlet UITextField *cameraPassword;
@property (retain, nonatomic) IBOutlet UITextField *cameraSn;
@property (retain, nonatomic) IBOutlet UINavigationBar *cameraAddNavBar;
@property (retain, nonatomic) IBOutlet UINavigationItem *cameraAddNavItem;

@property (retain, nonatomic) IBOutlet UIView *addCameraBackView;
@property (retain, nonatomic) IBOutlet UITextField *nameTextField;
@property (retain, nonatomic) IBOutlet UIView *backView;
@property (retain, nonatomic) NSString  * cameraSnStr;
@property (retain, nonatomic) NSString  * cameraName;
@property (retain, nonatomic) NSString  * cameraPwd;
@property (retain, nonatomic) IBOutlet UIImageView *backImageView;

- (IBAction)backAction:(id)sender;
- (IBAction)cameraAddAction:(id)sender;
//- (IBAction)catchByZBarSDK:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *sureEnterButton;
@property (retain, nonatomic) IBOutlet UIButton *qrScanButton;

@end
