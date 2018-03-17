//
//  CameraSettingViewController.h
//  Myanycam
//
//  Created by myanycam on 13-5-3.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "BaseViewController.h"
#import "CameraSettingViewControllerDelegate.h"
#import "ShareCameraAlertView.h"
#import "CameraSetTableViewCell.h"

@protocol CameraStartDecodeVideoDelegate;

@interface CameraSettingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,CameraSettingViewControllerDelegate>{
    
    NSMutableArray      *_functionSetDataArray;
    NSMutableArray      *_infomationSetDataArray;
    NSMutableArray      *_cameraInfoDataArray;
    int                  _indexof180;
}


@property (retain, nonatomic) CameraInfoData * cameraInfo;
@property (retain, nonatomic) ShareCameraAlertView * shareCameraAlertView;

@property (retain, nonatomic) IBOutlet UITableView *cameraSetTableView;

@property (retain, nonatomic) NSMutableArray * cameraInfoDataArray;
@property (retain, nonatomic) NSMutableArray * functionSetDataArray;
@property (retain, nonatomic) NSMutableArray * infomationSetDataArray;
@property (assign, nonatomic) id<CameraStartDecodeVideoDelegate> delegate;

@end


@protocol CameraStartDecodeVideoDelegate <NSObject>

- (void)decodeVideoDelegate;

@end




