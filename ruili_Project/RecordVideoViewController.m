//
//  RecordVideoViewController.m
//  Myanycam
//
//  Created by myanycam on 13-2-28.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "RecordVideoViewController.h"
#import "TimePeriodSelectViewController.h"
#import "AppDelegate.h"


@interface RecordVideoViewController ()

@end

@implementation RecordVideoViewController
@synthesize dataArray = _dataArray;
@synthesize recordVideoSwitchdataArray = _recordVideoSwitchdataArray;
@synthesize freeSpacedataArray = _freeSpacedataArray;
@synthesize currentIndexPath = _currentIndexPath;
@synthesize recordVideoSettingData = _recordVideoSettingData;
@synthesize cameraData = _cameraData;

- (void)dealloc {
    self.recordVideoSettingData = _recordVideoSettingData;
    self.dataArray = nil;
    self.currentIndexPath = nil;
    self.recordVideoSwitchdataArray = nil;
    self.freeSpacedataArray = nil;
    self.cameraData = nil;
    [_recordVideoTableView release];
    [_setRecordTimeButton release];
    [_setTimeTipLabel release];
    [_recordSettingControl release];
    [super dealloc];
}

-(AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)prepareData{
    
    self.recordVideoSettingData = [MYDataManager shareManager].recordVideoSettingData;
    
    
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
  
    //录像策略 0：循环录像 1：报警录像
    
    NSInteger index = self.recordVideoSettingData.recordPolicy;

    [self.dataArray addObject:[RecordVideoSetCellData recordVideoSetCellData:NSLocalizedString(@"Auto recording", nil)
                                                                    cellType:CellDataTypeRecordVideoCycleOpenSwitch
                                                                    isSwitch:YES
                                                                    isSelect:index==0?YES:NO]];
    
//    if ([AppDelegate getAppDelegate].apModelOrCloudModel)
    {
        
        [self.dataArray addObject:[RecordVideoSetCellData recordVideoSetCellData:NSLocalizedString(@"Manual recording", nil)
                                                                        cellType:CellDataTypeWarningPlanSet
                                                                        isSwitch:YES
                                                                        isSelect:index==1?YES:NO]];
    }
//    else
//    {
//        [self.dataArray addObject:[RecordVideoSetCellData recordVideoSetCellData:NSLocalizedString(@"Alarm Record", nil)
//                                                                        cellType:CellDataTypeWarningPlanSet
//                                                                        isSwitch:YES
//                                                                        isSelect:index==1?YES:NO]];
//    }
    

    
    [self.recordVideoTableView reloadData];

}

- (void)updateTableViewCell{
    
    
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    
    //录像策略 0：循环录像 1：报警录像
    
    NSInteger index = self.recordVideoSettingData.recordPolicy;
    
    [self.dataArray addObject:[RecordVideoSetCellData recordVideoSetCellData:NSLocalizedString(@"Auto recording", nil)
                                                                    cellType:CellDataTypeRecordVideoCycleOpenSwitch
                                                                    isSwitch:YES
                                                                    isSelect:index==0?YES:NO]];
    
//    if ([AppDelegate getAppDelegate].apModelOrCloudModel)
    {
        
        [self.dataArray addObject:[RecordVideoSetCellData recordVideoSetCellData:NSLocalizedString(@"Manual recording", nil)
                                                                        cellType:CellDataTypeWarningPlanSet
                                                                        isSwitch:YES
                                                                        isSelect:index==1?YES:NO]];
    }
//    else
//    {
//        [self.dataArray addObject:[RecordVideoSetCellData recordVideoSetCellData:NSLocalizedString(@"Alarm Record", nil)
//                                                                        cellType:CellDataTypeWarningPlanSet
//                                                                        isSwitch:YES
//                                                                        isSelect:index==1?YES:NO]];
//    }
    
    [self.recordVideoTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self showBackButton:nil action:nil buttonTitle:@""];
    
    self.recordVideoTableView.scrollEnabled = NO;
    
    [self appDelegate].mygcdSocketEngine.dealObject.recordSetDelegate = self;
    [[self appDelegate].mygcdSocketEngine sendGetRecordInfoRequest:self.cameraData];
    
}

- (void)saveRecordSet{
    
    [self recordSettingControlAction:nil];
    
}


- (void)sendRecordSetRequest:(NSInteger)policy cameraid:(NSInteger)cameraid password:(NSString *)password repeat:(NSInteger)repeat beginAndEndTimes:(NSArray *)times recordSwitch:recordSwitch{
    
     [[self appDelegate].mygcdSocketEngine sendSetRecordSettingRequest:policy cameraid:cameraid password:password repeat:repeat beginAndEndTimes:times recordSwitch:recordSwitch];
    
}


- (void)goToRecordVideoPlanDetailView:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0://
        {
            self.recordVideoSettingData.recordPolicy = 0;
            self.recordVideoSettingData.recordSwitch = 1;
            
        }
            break;
        case 1://循环录像
        {
            self.recordVideoSettingData.recordPolicy = 1;
            self.recordVideoSettingData.recordSwitch = 1;
            [self setRecordTimeButtonAction:nil];
        }
            break;
            
        default:
            break;
    }
    
    [self.recordVideoTableView reloadData];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    NSInteger index = indexPath.row;
    
    if (index == 0) {
        
        [self sendSetAutoRecordRequest];
    }
    
    if (index == 1) {
        [self sendSetAlarmRecordRequest];
    }
    
    self.recordVideoSettingData.recordPolicy = index;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellStyle = @"cellStyle";
    CameraSetSwitchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStyle];
    if (!cell) {
        NSArray * viewCells = [[NSBundle mainBundle] loadNibNamed:@"CameraSetSwitchTableViewCell" owner:nil options:nil];
        if ([viewCells count]) {
            cell = [viewCells lastObject];
        }
    }
    
    cell.cellData  = [self.dataArray objectAtIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}

//- (void)switchChanged:(id)sender{
//    
//    if ([sender isKindOfClass:[CustomSwitch class]]) {
//        CustomSwitch * mySwitch = (CustomSwitch *)sender;
//        NSDictionary * userInfo = mySwitch.userInfo;
//        CellDataType cellType = ((RecordVideoSetCellData *)[userInfo objectForKey:@"CustomSwitch"]).cellType;
//        switch (cellType) {
//            case CellDataTypeRecordVideoCycleOpenSwitch:
//            {
//                self.recordVideoSettingData.isLoopRecord = mySwitch.isOn;
//            }
//                break;
//            default:
//                break;
//        }
//    }
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArray count];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    
    [self setRecordVideoTableView:nil];
    [self setSetRecordTimeButton:nil];
    [self setSetTimeTipLabel:nil];
    [self setRecordSettingControl:nil];
    [super viewDidUnload];
    
}
- (IBAction)setRecordTimeButtonAction:(id)sender {
    
    TimePeriodSelectViewController * controller = [[TimePeriodSelectViewController alloc] init];
    controller.title = NSLocalizedString(@"Record schedule", nil);
    controller.controllerType = 1;
    controller.cameraData = self.cameraData;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (IBAction)recordSettingControlAction:(id)sender {
    
    
    NSInteger index = self.recordSettingControl.selectedSegmentIndex;
    
    if (index == 0) {
        
        [self sendSetAutoRecordRequest];
    }
    
    if (index == 1) {
        [self sendSetAlarmRecordRequest];
    }
}

- (void)getRecordInfoRespond:(NSDictionary *)info{
    
    [[MYDataManager shareManager] updateRecordSetInfo:info];
    [[self appDelegate].window hideWaitAlertView];
    
    [self prepareData];
    
    
//    [self.recordVideoTableView reloadData];
    
}

- (void)setRecordInfoRespond:(NSDictionary *)info{

    [[self appDelegate].window hideWaitAlertView];
    if ([[info objectForKey:@"ret"] intValue] == 0) {
        
        [self showAutoDismissAlertView:NSLocalizedString(@"Set Success!", nil)];
        [self updateTableViewCell];

    }
    else{
        
       	NSString *title = NSLocalizedString(@"Error", nil);
        NSString *message = NSLocalizedString(@"Set Error", nil);
        [self showAskAlertView:title msg:message userInfo:nil];
    }
    
}

- (void)alertView:(AHAlertView *)alertView otherButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        [self saveRecordSet];
    }
}

- (void)cancelButtonAction:(NSDictionary *)info{
    
    [self goBack];
}

- (void)sendSetAutoRecordRequest{
    
    RecordVideoSettingData * recordData = [MYDataManager shareManager].recordVideoSettingData;

    [self sendRecordSetRequest:0 cameraid:self.cameraData.cameraId password:self.cameraData.password repeat:self.recordVideoSettingData.repeatWeekData.repeatInt beginAndEndTimes:self.recordVideoSettingData.recordTimeSelectArray recordSwitch:self.recordVideoSettingData.recordSwitch];
    recordData.recordPolicy = 0;
}

- (void)sendSetAlarmRecordRequest{
    
    RecordVideoSettingData * recordData = [MYDataManager shareManager].recordVideoSettingData;

    [self sendRecordSetRequest:1 cameraid:self.cameraData.cameraId password:self.cameraData.password repeat:self.recordVideoSettingData.repeatWeekData.repeatInt beginAndEndTimes:self.recordVideoSettingData.recordTimeSelectArray recordSwitch:self.recordVideoSettingData.recordSwitch];
    recordData.recordPolicy = 1;}

- (void)cameraSetSwitchChange:(CameraSetSwitchTableViewCell *)cell{
    
    
    switch (cell.cellData.cellType) {
            
        case CellDataTypeRecordVideoCycleOpenSwitch:
        {
            if(cell.cellSwitch.isOn)
            {
                [self sendSetAutoRecordRequest];
            }
            else
            {
                [self sendSetAlarmRecordRequest];
            }
        }
            break;
        case CellDataTypeWarningPlanSet:
        {
            if(cell.cellSwitch.isOn)
            {
                [self sendSetAlarmRecordRequest];
            }
            else
            {
               [self sendSetAutoRecordRequest];
            }
        }
            break;
        default:
            break;
            
    }
}

- (void)recordVideoSwitchChange:(RecordVideoSetCell *)cell{
    
    RecordVideoSettingData * recordData = [MYDataManager shareManager].recordVideoSettingData;
    
    switch (cell.cellData.cellType) {
            
        case CellDataTypeRecordVideoSettingPlan:
        {
            if (recordData.recordPolicy == 1) {
                
                [self setRecordTimeButtonAction:nil];
            }
        }
            break;
        case CellDataTypeAllHoursRecordVideo:
        {
            
        }
            break;
        case CellDataTypeNotRecordVideo:
        {
            if (recordData.recordSwitch == 0) {
                
                _sectionCount = 1;
                
            }
            else{
                
                 _sectionCount = 2;
            }
        }
            break;
        default:
            break;
    }

    [self.recordVideoTableView reloadData];
}

@end
