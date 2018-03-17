//
//  TimePeriodSelectViewController.h
//  Myanycam
//
//  Created by myanycam on 13-3-5.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "BaseViewController.h"
#import "TimePeriodSelectCell.h"


@interface TimePeriodSelectViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,TimePeroidSelectDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>{
    NSMutableArray      *_dataArray;
    NSMutableArray      *_hourDataArray;
    NSMutableArray      *_minDataArray;
    NSMutableArray      *_secondDataArray;
    TimePeriodSelectData    *_currentCellData;
    BOOL                _beginOrOverTime;//NO:start YES:stop
    NSInteger           _controllerType;
    AlertSettingData    *_alertSettingData;
    RecordVideoSettingData *_recordVideoSettingData;
    WeekData            *_weekRepeatData;
    CameraInfoData          *_cameraData;
    TimePeriodSelectCell    *_currentSelectCell;
    
}
@property (retain, nonatomic) CameraInfoData  * cameraData;
@property (retain, nonatomic) WeekData * weekRepeatData;
@property (retain, nonatomic) AlertSettingData * alertSettingData;
@property (retain, nonatomic) RecordVideoSettingData * recordVideoSettingData;
@property (assign, nonatomic) NSInteger controllerType;
@property (assign, nonatomic) BOOL  beginOrOverTime;
@property (retain, nonatomic) TimePeriodSelectData * currentCellData;
@property (retain, nonatomic) NSMutableArray    *hourDataArray;
@property (retain, nonatomic) NSMutableArray    *minDataArray;
@property (retain, nonatomic) NSMutableArray    *secondDataArray;

@property (retain, nonatomic) IBOutlet UIBarButtonItem *selectTimeFinishButton;
@property (retain, nonatomic) IBOutlet UIView *timeDetailSelectBgView;
@property (retain, nonatomic) IBOutlet UIPickerView *timeDetailSelectPickerView;
@property (retain, nonatomic) NSMutableArray    *dataArray;
@property (retain, nonatomic) IBOutlet UIButton *addTimeButton;
@property (retain, nonatomic) IBOutlet UITableView *addTimeTableView;
@property (retain, nonatomic) IBOutlet UILabel *mondayLabel;
@property (retain, nonatomic) IBOutlet UILabel *tuesdayLabel;
@property (retain, nonatomic) IBOutlet UILabel *wednesdayLabel;
@property (retain, nonatomic) IBOutlet UILabel *thursdayLabel;
@property (retain, nonatomic) IBOutlet UILabel *fridayLabel;
@property (retain, nonatomic) IBOutlet UILabel *saturdayLabel;
@property (retain, nonatomic) IBOutlet UILabel *sundayLabel;
@property (retain, nonatomic) IBOutlet UILabel *repeatSetLabel;

@property (retain, nonatomic) IBOutlet UIButton *mondayButton;
@property (retain, nonatomic) IBOutlet UIButton *tuesdayButton;
@property (retain, nonatomic) IBOutlet UIButton *wednesdayButton;
@property (retain, nonatomic) IBOutlet UIButton *thursdayButton;
@property (retain, nonatomic) IBOutlet UIButton *fridayButton;
@property (retain, nonatomic) IBOutlet UIButton *saturdayButton;
@property (retain, nonatomic) IBOutlet UIButton *sundayButton;

@property (retain, nonatomic) IBOutlet UIImageView *mondayImageView;
@property (retain, nonatomic) IBOutlet UIImageView *tuesdayImageView;
@property (retain, nonatomic) IBOutlet UIImageView *wednesdayImageView;
@property (retain, nonatomic) IBOutlet UIImageView *thursdayImageView;
@property (retain, nonatomic) IBOutlet UIImageView *fridayImageView;
@property (retain, nonatomic) IBOutlet UIImageView *saturdayImageView;
@property (retain, nonatomic) IBOutlet UIImageView *sundayImageView;
@property (retain, nonatomic) IBOutlet UINavigationItem *timeSelectBar;
@property (retain, nonatomic) IBOutlet UILabel *pickerViewLabel;

@property (retain, nonatomic) IBOutlet UILabel *indexLabel;
@property (retain, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *stopTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *onandoffLabel;



- (IBAction)mondayButtonAction:(id)sender;
- (IBAction)tuesdayButtonAction:(id)sender;
- (IBAction)wednesdayButtonAction:(id)sender;
- (IBAction)thursdayButtonAction:(id)sender;
- (IBAction)fridayButtonAction:(id)sender;
- (IBAction)saturdayButtonAction:(id)sender;
- (IBAction)sundayButtonAction:(id)sender;


- (IBAction)addTimeButtonAction:(id)sender;
- (IBAction)timePickerFinishButton:(id)sender;

@end
