//
//  SettingRootViewController.h
//  myanycam
//
//  Created by myanycam on 13-2-25.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApsystemsetgetVideoSizeDelegate.h"
#import "CameraDeviceSetDelegate.h"
#import "CameraDeviceData.h"


@interface SettingRootViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,CameraDeviceSetDelegate>{
    
    NSMutableArray      *_sectionTitleArray;
    NSMutableArray      *_dataArray;
    
}


@property (retain, nonatomic) IBOutlet UITableView *settingRootTableView;
@property (retain, nonatomic) NSMutableArray       *sectionTitleArray;
@property (retain, nonatomic) NSMutableArray       *videoDataArray;
@property (retain, nonatomic) NSMutableArray       *netDataArray;
@property (retain, nonatomic) NSMutableArray       *functionDataArray;
//@property (retain, nonatomic) NSMutableArray       *systemDataArray;

@property (retain, nonatomic) CameraDeviceData  * cameraInfo;






@end
