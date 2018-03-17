//
//  cameraListViewController.h
//  myanycam
//
//  Created by 中程 on 13-1-13.
//  Copyright (c) 2013年 中程. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cameraListDelegate.h"
#import "CheckCameraPasswordDelegate.h"
#import "BaseAlertViewDelegate.h"
#import "ZXingWidgetController.h"
#import "AQGridView.h"



@interface cameraListViewController : BaseViewController<ZXingDelegate,AQGridViewDataSource,AQGridViewDelegate,cameraListDelegate,UIAlertViewDelegate,BaseAlertViewDelegate,CheckCameraPasswordDelegate>
{
    BOOL  m_bTransform;
    BOOL  _flagCalling;
}


@property (retain, nonatomic) IBOutlet UINavigationBar *cameraListNavBar;
@property (retain, nonatomic) IBOutlet UINavigationItem *cameraListNacItem;
@property (retain, nonatomic) IBOutlet UITableView *cameraListTable;
@property (retain, nonatomic) NSMutableArray *cameraListArray;
@property (assign, nonatomic) CameraInfoData * currentCameraInfo;
@property (retain, nonatomic) CameraInfoData * fakeCameraData;
@property (retain, nonatomic) IBOutlet AQGridView *cameraGridview;
@property (retain, nonatomic) IBOutlet UILabel *addCameraTipLabel;

- (IBAction)addCameraAction:(id)sender;
- (void)settingAction:(id)sender;

@end

