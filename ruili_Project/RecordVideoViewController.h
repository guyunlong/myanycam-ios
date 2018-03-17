//
//  RecordVideoViewController.h
//  Myanycam
//
//  Created by myanycam on 13-2-28.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "BaseViewController.h"
#import "RecordVideoSetCell.h"
#import "RecordVideoSettingData.h"
#import "CameraSetSwitchTableViewCell.h"


@interface RecordVideoViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate,RecordSetDelegate,AHAlertViewDelegate,CameraSetSwitchTableDelegate>{
    NSMutableArray      *_dataArray;
    NSMutableArray      *_recordVideoSwitchdataArray;
    NSMutableArray      *_freeSpacedataArray;
    NSIndexPath         *_currentIndexPath;
    RecordVideoSettingData  *_recordVideoSettingData;
    CameraInfoData          *_cameraData;
    NSInteger                _sectionCount;
}
@property (retain, nonatomic) IBOutlet UISegmentedControl *recordSettingControl;

@property (retain, nonatomic) CameraInfoData * cameraData;
@property (retain, nonatomic) RecordVideoSettingData * recordVideoSettingData;
@property (retain, nonatomic) IBOutlet UIButton *setRecordTimeButton;
@property (retain, nonatomic) NSIndexPath       *currentIndexPath;
@property (retain, nonatomic) NSMutableArray    *dataArray;
@property (retain, nonatomic) NSMutableArray    *recordVideoSwitchdataArray;
@property (retain, nonatomic) NSMutableArray    *freeSpacedataArray;
@property (retain, nonatomic) IBOutlet UILabel *setTimeTipLabel;

@property (retain, nonatomic) IBOutlet UITableView *recordVideoTableView;

- (IBAction)setRecordTimeButtonAction:(id)sender;
- (IBAction)recordSettingControlAction:(id)sender;

@end
