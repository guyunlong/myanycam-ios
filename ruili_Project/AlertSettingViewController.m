//
//  AlertSettingViewController.m
//  Myanycam
//
//  Created by myanycam on 13-3-11.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "AlertSettingViewController.h"
#import "AlertSettingViewCell.h"
#import "TimePeriodSelectViewController.h"
#import "AppDelegate.h"
#import "UINavigationItem+UINavigationItemTitle.h"


@interface AlertSettingViewController ()

@end

@implementation AlertSettingViewController
@synthesize dataArray = _dataArray;
@synthesize cameraData;
@synthesize firstSectionDataArray;
@synthesize alertTypeDataArray;


- (void)dealloc {
    self.dataArray = nil;
    self.firstSectionDataArray = nil;
    self.alertTypeDataArray = nil;
    self.cameraData = nil;
    [self appDelegate].mygcdSocketEngine.dealObject.alertSettingDelegate = nil;
    [_alertSettingTableView release];
    [_setAlertTimeButton release];
    [_setTimeTipLabel release];
    [_skipForAlertSetImageView release];
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
        [self prepareData];
    }
    return self;
}

- (void)prepareData{
    
    self.dataArray = [NSMutableArray arrayWithCapacity:3];
    
    if ([MYDataManager shareManager].alertSettingData.alertSwitch) {
        
        [self.dataArray addObject:[AlertSettingViewCellData alertSettingCellData:0 name:NSLocalizedString(@"Open Alarm", nil) cellType:CellDataTypeCloseAlert]];
        [self.dataArray addObject:[AlertSettingViewCellData alertSettingCellData:1 name:NSLocalizedString(@"Motion", nil) cellType:CellDataTypeIsMotionAlert]];
        [self.dataArray addObject:[AlertSettingViewCellData alertSettingCellData:2 name:NSLocalizedString(@"Noise", nil) cellType:CellDataTypeIsNoiseAlert]];
    }
    else
    {
        [self.dataArray addObject:[AlertSettingViewCellData alertSettingCellData:0 name:NSLocalizedString(@"Open Alarm", nil) cellType:CellDataTypeCloseAlert]];
    }
    
 
}

- (void)updateTableViewDataWithFlag:(BOOL)isOn{
    
    self.dataArray = [NSMutableArray arrayWithCapacity:3];
    
    if (!isOn) {
        
        [self.dataArray addObject:[AlertSettingViewCellData alertSettingCellData:0 name:NSLocalizedString(@"Open Alarm", nil) cellType:CellDataTypeCloseAlert]];
    }
    else
    {
        [self.dataArray addObject:[AlertSettingViewCellData alertSettingCellData:0 name:NSLocalizedString(@"Open Alarm", nil) cellType:CellDataTypeCloseAlert]];
        [self.dataArray addObject:[AlertSettingViewCellData alertSettingCellData:1 name:NSLocalizedString(@"Motion", nil) cellType:CellDataTypeIsMotionAlert]];
        [self.dataArray addObject:[AlertSettingViewCellData alertSettingCellData:2 name:NSLocalizedString(@"Noise", nil) cellType:CellDataTypeIsNoiseAlert]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
     [self showBackButton:self action:@selector(saveAlertSet) buttonTitle:@""];
    
//    self.skipForAlertSetImageView.layer.masksToBounds = YES;
//    self.skipForAlertSetImageView.layer.cornerRadius = 10.0;
//    if (self.cameraData.status == 1)
//    {
//        
//        [self appDelegate].mygcdSocketEngine.dealObject.alertSettingDelegate = self;
//        [[self appDelegate].mygcdSocketEngine sendGetAlertInfoRequest:self.cameraData];
//    }
//    else
//    {
//        self.alertSettingTableView.hidden = YES;
//    }
    
    [self appDelegate].mygcdSocketEngine.dealObject.alertSettingDelegate = self;
    [[self appDelegate].mygcdSocketEngine sendGetAlertInfoRequest:self.cameraData];
    self.alertSettingTableView.scrollEnabled = NO;

}

- (void)saveAlertSet{
    
    if ([[self appDelegate].mygcdSocketEngine isConnect] && (self.cameraData.status == 1|| [AppDelegate getAppDelegate].apModelOrCloudModel)) {
       
        [self sendSetAlertRequest];
    }
    else{
        
        [self goBack];
    }
    
}

- (void)sendSetAlertRequest{
    
    [self appDelegate].mygcdSocketEngine.dealObject.alertSettingDelegate = self;
    
    AlertSettingData * data = [MYDataManager shareManager].alertSettingData;
    [[self appDelegate].mygcdSocketEngine sendSetAlertInfoRequest:data cameradata:self.cameraData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setAlertSettingTableView:nil];
    [self setSetAlertTimeButton:nil];
    [self setSetTimeTipLabel:nil];
    [self setSkipForAlertSetImageView:nil];
    [super viewDidUnload];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    AlertSettingViewCell * cell = (AlertSettingViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.cellData.cellType == CellDataTypeIsPeriodAlert) {//报警时段设置
        
        [MYDataManager shareManager].alertSettingData.alertType = 1;
        [self setAlertTimeButtonAction:nil];
        
    }
    if (cell.cellData.cellType == CellDataTypeIsAllDayAlert) {
     
        [MYDataManager shareManager].alertSettingData.alertType = 0;
    }
    
    [self.alertSettingTableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 48.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

        return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellStyle = @"CellStyle";
    AlertSettingViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStyle];
    if (!cell) {
        NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"AlertSettingViewCell" owner:nil options:nil];
        if ([views count]) {
            cell = [views lastObject];
        }
    }

        AlertSettingViewCellData * cellData = [self.dataArray objectAtIndex:indexPath.row];
        cell.delegate = self;
        cell.cellData = cellData;
    
    return cell;
    
}

- (void)alertSettingViewCellDelegate:(AlertSettingViewCell *)cell{
    
    AlertSettingViewCellData * data = cell.cellData;
    if (data.cellType == CellDataTypeIsPeriodAlert) {//报警时段设置
        
        [self setAlertTimeButtonAction:nil];
        
    }
    
    if (data.cellType == CellDataTypeIsAllDayAlert) {
        
    }
    
    if (data.cellType == CellDataTypeCloseAlert) {
        
        [self updateTableViewDataWithFlag:cell.cellSwitch.isOn];
    }
    
    
    [self.alertSettingTableView reloadData];
}


- (IBAction)setAlertTimeButtonAction:(id)sender {
    
    TimePeriodSelectViewController * controller = [[TimePeriodSelectViewController alloc] init];
    controller.title = NSLocalizedString(@"Alarm time setting", nil);
    [controller.navigationItem setCustomTitle:NSLocalizedString(@"Alarm time setting", nil)];
    controller.controllerType = 2;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)getAlertSettingInfo:(NSDictionary *)info{
    
    [[self appDelegate].window hideWaitAlertView];
    [[MYDataManager shareManager] updateAlertSetInfo:info];
    
    [self prepareData];
    
    [self.alertSettingTableView reloadData];
    
}

- (void)setAlertRspInfo:(NSDictionary *)info{
    
    [[self appDelegate].window hideWaitAlertView];
    
    if ([[info objectForKey:@"ret"] intValue] == 0) {
        
        [self goBack];
    }
    else{
        
       	NSString *title = NSLocalizedString(@"Error", nil);
        NSString *message = NSLocalizedString(@"Set Error", nil);
        [self showAskAlertView:title msg:message userInfo:nil];
    }
}

- (void)alertView:(AHAlertView *)alertView otherButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        [self saveAlertSet];
    }
}

- (void)cancelButtonAction:(NSDictionary *)info{
    
    [self goBack];
}

@end
