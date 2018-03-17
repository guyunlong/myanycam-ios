//
//  RootViewController.h
//  Myanycam
//
//  Created by myanycam on 13-3-14.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//


#import "CustomBottomBarView.h"
#import "PhotosGridViewController.h"
#import "AlertEventListViewController.h"
#import "SystemSetViewController.h"
#import "CameraInfoData.h"
#import "EventAlertViewController.h"
#import "cameraViewViewController.h"
#import "ChangePasswordAlertView.h"
#import "CameraSettingNavigationController.h"
#import "BaseAlertViewDelegate.h"
#import "CheckCameraPasswordDelegate.h"
#import "CameraDeviceSetDelegate.h"
#import "CameraDeviceData.h"

@class RTSPPlayViewController;

@interface RootViewController : BaseViewController <UIAlertViewDelegate,RootViewControllerDismissDelegate,CameraDeviceSetDelegate>{

    cameraViewViewController * _cameraViewController;
    PhotosGridViewController   * _fileListVC;
    EventAlertViewController * _alertEventController;
    CameraSettingNavigationController  * _settingVC;
    UIViewController         * _currentController;
    CameraInfoData           * _cameraData;
    ChangePasswordAlertView  * _changePwdAlertView;
    
    
}
@property (assign, nonatomic) BOOL needDissmiss;
@property (retain, nonatomic) IBOutlet UINavigationBar * rootTopViewController;
@property (retain, nonatomic) UIViewController         * currentController;
@property (retain, nonatomic) CustomBottomBarView      * bottomBarView;
@property (assign, nonatomic) cameraViewViewController * cameraViewController;
@property (assign, nonatomic) PhotosGridViewController * fileListVC;
@property (assign, nonatomic) EventAlertViewController * alertEventController;
@property (assign, nonatomic) CameraSettingNavigationController  * settingVC;
@property (retain, nonatomic) ChangePasswordAlertView  * changePwdAlertView;
@property (retain, nonatomic) CameraInfoData           * cameraData;
@property (retain, nonatomic) CameraDeviceData         * cameraDeviceInfo;
@property (retain, nonatomic) IBOutlet UIImageView *backImageView;




- (id)initWithCameraData:(CameraInfoData *)cameraData;


- (void)dismisscurrentViewController;

- (void)showCameraViewController;
- (void)showFileViewController;
- (void)showUserViewController;
- (void)showSettingViewController;

@end

