//
//  TimePeriodSelectViewController.m
//  Myanycam
//
//  Created by myanycam on 13-3-5.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "TimePeriodSelectViewController.h"
#import "MYDataManager.h"

@interface TimePeriodSelectViewController ()

@end

@implementation TimePeriodSelectViewController
@synthesize dataArray = _dataArray;
@synthesize hourDataArray = _hourDataArray;
@synthesize minDataArray = _minDataArray;
@synthesize secondDataArray = _secondDataArray;
@synthesize currentCellData = _currentCellData;
@synthesize beginOrOverTime;
@synthesize controllerType = _controllerType;
@synthesize alertSettingData = _alertSettingData;
@synthesize recordVideoSettingData = _recordVideoSettingData;
@synthesize weekRepeatData = _weekRepeatData;
@synthesize cameraData = _cameraData;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self prepareData];
    }
    return self;
}

- (void)prepareData{
    
    self.alertSettingData = [MYDataManager shareManager].alertSettingData;
    self.recordVideoSettingData = [MYDataManager shareManager].recordVideoSettingData;
    
    self.dataArray = [NSMutableArray arrayWithCapacity:4];
    self.hourDataArray = [NSMutableArray arrayWithCapacity:24];
    for (int i = 0; i < 24; i++) {
        [self.hourDataArray addObject:[NSNumber numberWithInt:i]];
    }
    self.minDataArray = [NSMutableArray arrayWithCapacity:60];
    for (int i = 0; i < 60; i++) {
        [self.minDataArray addObject:[NSNumber numberWithInt:i]];
    }
    self.secondDataArray = [NSMutableArray arrayWithCapacity:60];
    for (int i = 0; i < 60; i++) {
        [self.secondDataArray addObject:[NSNumber numberWithInt:i]];
    }


}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    if (self.controllerType == 1) {
        self.dataArray = self.recordVideoSettingData.recordTimeSelectArray;
        self.weekRepeatData = self.recordVideoSettingData.repeatWeekData;
    }
    else{
        self.dataArray = self.alertSettingData.timePeriodArray;
        self.weekRepeatData = self.alertSettingData.repeatWeekData;
    }
    
    [self showBackButton:self action:@selector(goBack) buttonTitle:nil];
    
    self.repeatSetLabel.text = NSLocalizedString(@"Repeat", nil);
    
    [self.mondayButton setShowsTouchWhenHighlighted:YES];
    [self.tuesdayButton setShowsTouchWhenHighlighted:YES];
    [self.wednesdayButton setShowsTouchWhenHighlighted:YES];
    [self.thursdayButton setShowsTouchWhenHighlighted:YES];
    [self.fridayButton setShowsTouchWhenHighlighted:YES];
    [self.saturdayButton setShowsTouchWhenHighlighted:YES];
    [self.sundayButton setShowsTouchWhenHighlighted:YES];
    
    
    self.mondayImageView.hidden = self.weekRepeatData.monday == 0?YES:NO;
    self.tuesdayImageView.hidden = self.weekRepeatData.tuesday == 0?YES:NO;
    self.wednesdayImageView.hidden = self.weekRepeatData.wednesday == 0?YES:NO;
    self.thursdayImageView.hidden = self.weekRepeatData.thursday == 0?YES:NO;
    self.fridayImageView.hidden = self.weekRepeatData.friday == 0?YES:NO;
    self.saturdayImageView.hidden = self.weekRepeatData.saturday == 0?YES:NO;
    self.sundayImageView.hidden = self.weekRepeatData.sunday == 0?YES:NO;
    
    self.mondayLabel.text = NSLocalizedString(@"Monday", nil);
    self.tuesdayLabel.text = NSLocalizedString(@"Tuesday", nil);
    self.wednesdayLabel.text = NSLocalizedString(@"Wednesday", nil);
    self.thursdayLabel.text = NSLocalizedString(@"Thursday", nil);
    self.fridayLabel.text = NSLocalizedString(@"Friday", nil);
    self.saturdayLabel.text = NSLocalizedString(@"Saturday", nil);
    self.sundayLabel.text = NSLocalizedString(@"Sunday", nil);
    
    
    self.startTimeLabel.text = NSLocalizedString(@"Start Time", nil);
    self.stopTimeLabel.text = NSLocalizedString(@"Stop Time", nil);
    self.addTimeTableView.scrollEnabled = NO;
    
    
    [self dealRepeatSelect];
}

- (void)dealRepeatSelect{
    
    MYTapGestureRecognizer * gesture = [[MYTapGestureRecognizer alloc] initWithTarget:self action:@selector(mondayButtonAction:)];
    [self.mondayLabel addGestureRecognizer:gesture];
    [gesture release];
    
    gesture = [[MYTapGestureRecognizer alloc] initWithTarget:self action:@selector(tuesdayButtonAction:)];
    [self.tuesdayLabel addGestureRecognizer:gesture];
    [gesture release];
    
     gesture = [[MYTapGestureRecognizer alloc] initWithTarget:self action:@selector(wednesdayButtonAction:)];
    [self.wednesdayLabel addGestureRecognizer:gesture];
    [gesture release];
    
     gesture = [[MYTapGestureRecognizer alloc] initWithTarget:self action:@selector(thursdayButtonAction:)];
    [self.thursdayLabel addGestureRecognizer:gesture];
    [gesture release];
    
    gesture = [[MYTapGestureRecognizer alloc] initWithTarget:self action:@selector(fridayButtonAction:)];
    [self.fridayLabel addGestureRecognizer:gesture];
    [gesture release];
    
     gesture = [[MYTapGestureRecognizer alloc] initWithTarget:self action:@selector(saturdayButtonAction:)];
    [self.saturdayLabel addGestureRecognizer:gesture];
    [gesture release];
    
     gesture = [[MYTapGestureRecognizer alloc] initWithTarget:self action:@selector(sundayButtonAction:)];
    [self.sundayLabel addGestureRecognizer:gesture];
    [gesture release];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    self.dataArray = nil;
    self.hourDataArray = nil;
    self.minDataArray = nil;
    self.secondDataArray = nil;
    self.currentCellData = nil;
    self.recordVideoSettingData = nil;
    self.alertSettingData = nil;
    self.weekRepeatData = nil;
    self.cameraData = nil;
    [_addTimeButton release];
    [_addTimeTableView release];
    [_timeDetailSelectPickerView release];
    [_timeDetailSelectBgView release];
    [_mondayLabel release];
    [_tuesdayLabel release];
    [_wednesdayLabel release];
    [_thursdayLabel release];
    [_fridayLabel release];
    [_saturdayLabel release];
    [_sundayLabel release];
    [_mondayButton release];
    [_tuesdayButton release];
    [_wednesdayButton release];
    [_thursdayButton release];
    [_fridayButton release];
    [_saturdayButton release];
    [_sundayButton release];
    [_mondayImageView release];
    [_tuesdayImageView release];
    [_wednesdayImageView release];
    [_thursdayImageView release];
    [_fridayImageView release];
    [_saturdayImageView release];
    [_sundayImageView release];
    [_timeSelectBar release];
    [_pickerViewLabel release];
    [_selectTimeFinishButton release];
    [_repeatSetLabel release];
    [_indexLabel release];
    [_startTimeLabel release];
    [_stopTimeLabel release];
    [_onandoffLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setAddTimeButton:nil];
    [self setAddTimeTableView:nil];
    [self setTimeDetailSelectPickerView:nil];
    [self setTimeDetailSelectBgView:nil];
    [self setMondayLabel:nil];
    [self setTuesdayLabel:nil];
    [self setWednesdayLabel:nil];
    [self setThursdayLabel:nil];
    [self setFridayLabel:nil];
    [self setSaturdayLabel:nil];
    [self setSundayLabel:nil];
    [self setMondayButton:nil];
    [self setTuesdayButton:nil];
    [self setWednesdayButton:nil];
    [self setThursdayButton:nil];
    [self setFridayButton:nil];
    [self setSaturdayButton:nil];
    [self setSundayButton:nil];
    [self setMondayImageView:nil];
    [self setTuesdayImageView:nil];
    [self setWednesdayImageView:nil];
    [self setThursdayImageView:nil];
    [self setFridayImageView:nil];
    [self setSaturdayImageView:nil];
    [self setSundayImageView:nil];
    [self setTimeSelectBar:nil];
    [self setPickerViewLabel:nil];
    [self setSelectTimeFinishButton:nil];
    [self setRepeatSetLabel:nil];
    [self setIndexLabel:nil];
    [self setStartTimeLabel:nil];
    [self setStopTimeLabel:nil];
    [self setOnandoffLabel:nil];
    [super viewDidUnload];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            TimePeriodSelectData * currentCellData = [self.dataArray objectAtIndex:indexPath.row];
            
            if (currentCellData.isOn) {
                
                TimePeriodSelectCell * cell = (TimePeriodSelectCell *)[tableView cellForRowAtIndexPath:indexPath];
                
                if (_currentSelectCell && cell != _currentSelectCell && [self checkCurrentTimeSettingStatus]) {
                    
                    return ;
                }
                
                _currentSelectCell =  (TimePeriodSelectCell *)[tableView cellForRowAtIndexPath:indexPath];
                
                self.beginOrOverTime = NO;
                self.currentCellData = [self.dataArray objectAtIndex:indexPath.row];
                [self showTimeSelectPickerView:(TimePeriodSelectCell *)[tableView cellForRowAtIndexPath:indexPath] cellData:[self.dataArray objectAtIndex:indexPath.row]];
            }
            else{
                
            }
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellTimePeriod = @"cellTimePeriod";
    TimePeriodSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:cellTimePeriod];
    if (!cell) {
        NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"TimePeriodSelectCell" owner:nil options:nil];
        cell = [views lastObject];
        cell.delegate = self;
    }
    cell.cellData = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)timePeroidSelectDelegate:(TimePeriodSelectData *)cellData cell:(TimePeriodSelectCell *)cell{
    
    [self.dataArray removeObject:cellData];
    [self.addTimeTableView reloadData];
}

- (IBAction)mondayButtonAction:(id)sender {
    
    self.mondayImageView.hidden = !(self.mondayImageView.hidden);
    self.weekRepeatData.monday = self.mondayImageView.hidden?0:1;

}

- (IBAction)tuesdayButtonAction:(id)sender {
    self.tuesdayImageView.hidden = !(self.tuesdayImageView.hidden);
    self.weekRepeatData.tuesday = self.tuesdayImageView.hidden?0:1;
}

- (IBAction)wednesdayButtonAction:(id)sender {
    self.wednesdayImageView.hidden = !(self.wednesdayImageView.hidden);
    self.weekRepeatData.wednesday = self.wednesdayImageView.hidden?0:1;
}

- (IBAction)thursdayButtonAction:(id)sender {
    self.thursdayImageView.hidden = !(self.thursdayImageView.hidden);
    self.weekRepeatData.thursday = self.thursdayImageView.hidden?0:1;
}

- (IBAction)fridayButtonAction:(id)sender {
    self.fridayImageView.hidden = !(self.fridayImageView.hidden);
    self.weekRepeatData.friday = self.fridayImageView.hidden?0:1;
}

- (IBAction)saturdayButtonAction:(id)sender {
    self.saturdayImageView.hidden = !(self.saturdayImageView.hidden);
    self.weekRepeatData.saturday = self.saturdayImageView.hidden?0:1;
}

- (IBAction)sundayButtonAction:(id)sender {
    self.sundayImageView.hidden = !(self.sundayImageView.hidden);
    self.weekRepeatData.sunday = self.sundayImageView.hidden?0:1;
}


- (IBAction)addTimeButtonAction:(id)sender {
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    switch (component) {
        case 0:
        {
            if (!self.beginOrOverTime) {
                self.currentCellData.beginHour = [[self.hourDataArray objectAtIndex:row] intValue];
            }
            else{
                self.currentCellData.overHour = [[self.hourDataArray objectAtIndex:row] intValue];
            }
            
        }
            break;
        case 1:
        {
            
            if (!self.beginOrOverTime) {
                
                self.currentCellData.beginmin = [[self.minDataArray objectAtIndex:row] intValue];
            }
            else{
                self.currentCellData.overmin = [[self.minDataArray objectAtIndex:row] intValue];
            }
            
        }
            break;
        case 2:
        {
            if (!self.beginOrOverTime) {
                
                self.currentCellData.beginsec = [[self.secondDataArray objectAtIndex:row] intValue];
            }
            else{
                self.currentCellData.oversec = [[self.secondDataArray objectAtIndex:row] intValue];
            }
        }
            break;
        default:
            break;
    }
    
    NSString * timeStr = nil;
    NSString * timeName = nil;//@"开始时间";
    if (!self.beginOrOverTime) {
        timeStr = [NSString stringWithFormat:@"%@:%@:%@",[self timeStringWithInt:self.currentCellData.beginHour],[self timeStringWithInt:self.currentCellData.beginmin],[self timeStringWithInt:self.currentCellData.beginsec]];
        timeName = NSLocalizedString(@"Start Time", nil);
    }
    else{
        
        timeStr = [NSString stringWithFormat:@"%@:%@:%@",[self timeStringWithInt:self.currentCellData.overHour],[self timeStringWithInt:self.currentCellData.overmin],[self timeStringWithInt:self.currentCellData.oversec]];
        timeName = NSLocalizedString(@"Stop Time", nil);
    }
    self.pickerViewLabel.text = [NSString stringWithFormat:@"%d.%@:%@",self.currentCellData.index,timeName,timeStr];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    switch (component) {
        case 0:
        {
            return [self timeStringWithInt:[[self.hourDataArray objectAtIndex:row] intValue]];
        }
            break;
        case 1:
        {
            return [self timeStringWithInt:[[self.minDataArray objectAtIndex:row] intValue]];
        }
            break;
        case 2:
        {
            return [self timeStringWithInt:[[self.secondDataArray objectAtIndex:row] intValue]];
        }
            break;
            
        default:
            break;
    }
    
    return nil;
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    switch (component) {
        case 0:
        {
            return [self.hourDataArray count];
        }
            break;
        case 1:
        {
            return [self.minDataArray count];
        }
            break;
        case 2:
        {
            return [self.secondDataArray count];
        }
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40.0;
}

- (IBAction)timePickerFinishButton:(id)sender {
    
    if (!self.beginOrOverTime) {
                
        self.beginOrOverTime = YES;
        NSInteger indexHour = [self.timeDetailSelectPickerView selectedRowInComponent:0];
        NSInteger indexMin = [self.timeDetailSelectPickerView selectedRowInComponent:1];
        NSInteger indexSec = [self.timeDetailSelectPickerView selectedRowInComponent:2];
        self.currentCellData.beginHour = [[self.hourDataArray objectAtIndex:indexHour] intValue];//indexHour;
        self.currentCellData.beginmin = [[self.minDataArray objectAtIndex:indexMin] intValue];
        self.currentCellData.beginsec = [[self.secondDataArray objectAtIndex:indexSec] intValue];
        [self showTimeSelectPickerView:_currentSelectCell cellData:self.currentCellData];
    }
    else{
        
        if (![self checkTimeSelectRightOrNot:self.currentCellData]) {
            [self showAlertView:nil alertMsg:NSLocalizedString(@"Time Set Error", nil) userInfo:nil  delegate:self canclButtonStr:NSLocalizedString(@"Sure", nil)  otherButtonTitles:NSLocalizedString(@"Cancel", nil),nil];

        }
        
        
        [self.timeDetailSelectBgView customHideWithAnimation:YES duration:0.3];
        
        [_currentSelectCell setOverTimeButtonHighlightedState:NO];
        [_currentSelectCell setBeginTimeButtonHighlightedState:NO];

    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        self.beginOrOverTime = NO;
        [self showTimeSelectPickerView:_currentSelectCell cellData:self.currentCellData];
    }
}

- (BOOL)checkTimeSelectRightOrNot:(TimePeriodSelectData *)cellData{
    
    BOOL flag = NO;
    if (cellData.beginHour < cellData.overHour) {
        return YES;
    }
    
    if (cellData.beginHour == cellData.overHour) {
        if (cellData.beginmin < cellData.overmin) {
            return YES;
        }
        
        if (cellData.beginmin == cellData.overmin) {
            if (cellData.beginsec < cellData.oversec) {
                return YES;
            }
        }
    }

    return flag;
}
- (void)timePeroidSelectDelegate:(TimePeriodSelectCell *)cell cellData:(TimePeriodSelectData *)cellData{
    
    
}

- (NSString *)timeStringWithInt:(NSInteger)time{
    
    NSString * timeStr = nil;
    if (time >= 10) {
        timeStr = [NSString stringWithFormat:@"%d",time];
    }
    else{
        timeStr = [NSString stringWithFormat:@"0%d",time];
    }
    return timeStr;
}

- (void)showTimeSelectPickerView:(TimePeriodSelectCell *)cell cellData:(TimePeriodSelectData *)cellData{
    
    [self.timeDetailSelectBgView customShowWithAnimation:YES duration:0.3];
    
    if (!self.beginOrOverTime) {
        
         self.selectTimeFinishButton.title = NSLocalizedString(@"Next", nil);
        
        [cell setBeginTimeButtonHighlightedState:YES];
        [cell setOverTimeButtonHighlightedState:NO];

        NSString * timeStr = [NSString stringWithFormat:@"%@:%@:%@",[self timeStringWithInt:cellData.beginHour],[self timeStringWithInt:cellData.beginmin],[self timeStringWithInt:cellData.beginsec]];
        self.pickerViewLabel.text = [NSString stringWithFormat:@"%d.%@:%@",cellData.index,NSLocalizedString(@"Start Time", nil),timeStr];
        
        [self.timeDetailSelectPickerView selectRow:cellData.beginHour inComponent:0 animated:NO];
        [self.timeDetailSelectPickerView selectRow:cellData.beginmin inComponent:1 animated:NO];
        [self.timeDetailSelectPickerView selectRow:cellData.beginsec inComponent:2 animated:NO];
    }
    else{
        
        self.selectTimeFinishButton.title = NSLocalizedString(@"Done", nil);
        [cell setBeginTimeButtonHighlightedState:NO];
        [cell setOverTimeButtonHighlightedState:YES];
        
        [self.timeDetailSelectPickerView selectRow:cellData.overHour inComponent:0 animated:NO];
        NSString * timeStr = [NSString stringWithFormat:@"%@:%@:%@",[self timeStringWithInt:cellData.overHour],[self timeStringWithInt:cellData.overmin],[self timeStringWithInt:cellData.oversec]];
        self.pickerViewLabel.text = [NSString stringWithFormat:@"%d.%@:%@",cellData.index,NSLocalizedString(@"Stop Time", nil),timeStr];
        [self.timeDetailSelectPickerView selectRow:cellData.overmin inComponent:1 animated:NO];
        [self.timeDetailSelectPickerView selectRow:cellData.oversec inComponent:2 animated:NO];
    }

}
- (void)cellBeginButtonDelegate:(TimePeriodSelectCell *)cell cellData:(TimePeriodSelectData *)cellData{
    
    if (cell.isOnSwitch.isOn) {
        
        if ( _currentSelectCell && cell != _currentSelectCell && [self checkCurrentTimeSettingStatus]) {
            
            return ;
        }
        
        [_currentSelectCell setOverTimeButtonHighlightedState:NO];
        [_currentSelectCell setBeginTimeButtonHighlightedState:NO];
        
        self.currentCellData = cellData;
        self.beginOrOverTime = NO;
        _currentSelectCell = cell;
        [self showTimeSelectPickerView:cell cellData:cellData];
    }

}

- (void)cellOverButtonDelegate:(TimePeriodSelectCell *)cell cellData:(TimePeriodSelectData *)cellData{
    
    if (cell.isOnSwitch.isOn) {
        
        
        if (_currentSelectCell && cell != _currentSelectCell && [self checkCurrentTimeSettingStatus]) {
            
            return ;
        }
        
        [_currentSelectCell setOverTimeButtonHighlightedState:NO];
        [_currentSelectCell setBeginTimeButtonHighlightedState:NO];
        
        self.currentCellData = cellData;
        self.beginOrOverTime = YES;
        _currentSelectCell = cell;
        [self showTimeSelectPickerView:cell cellData:cellData];
    }
}
- (void)cellSwitchStateChange:(TimePeriodSelectCell *)cell cellData:(TimePeriodSelectData *)cellData{
    
    if (!cell.isOnSwitch.isOn) {
        
        if (cell == _currentSelectCell) {
            
            if (![self checkTimeSelectRightOrNot:cellData]) {
                
                [cellData initDataZero];
            };
            
            [self.timeDetailSelectBgView customHideWithAnimation:YES duration:0.3];
            [_currentSelectCell setOverTimeButtonHighlightedState:NO];
            [_currentSelectCell setBeginTimeButtonHighlightedState:NO];
        }
    }
}

- (BOOL)checkCurrentTimeSettingStatus{
    
    BOOL flag = NO;
    
    if (self.timeDetailSelectBgView.hidden == NO) {
        
        return YES;
    }
    
    return flag;
}

@end
