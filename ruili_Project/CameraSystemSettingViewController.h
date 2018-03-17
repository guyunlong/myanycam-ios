//
//  CameraSystemSettingViewController.h
//  Myanycam
//
//  Created by myanycam on 13-5-16.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "BaseViewController.h"
#import "CameraDeviceSetDelegate.h"
#import "CameraDeviceData.h"
#import "CameraInfoData.h"

@interface CameraDeviceCellData : NSObject

@property (retain, nonatomic) NSString * name;
@property (retain, nonatomic) NSString * value;
@property (assign, nonatomic) NSInteger  cellType;

- (id)initWithName:(NSString *)aName value:(NSString *)aValue cellType:(NSInteger) aCellType;
+ (CameraDeviceCellData *)cameraDeviceCellInfo:(NSString *)aName value:(NSString *)aValue cellType:(NSInteger) aCellType;

@end


@interface CameraSystemSettingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) NSMutableArray  * dataArray;
@property (retain, nonatomic) IBOutlet UITableView *systemSettingTableView;
@property (retain, nonatomic) NSTimeZone    * currentTimeZone;
@property (retain, nonatomic) CameraDeviceData  * cameraInfo;
@property (retain, nonatomic) CameraInfoData    * cameraInfoData;

@end

