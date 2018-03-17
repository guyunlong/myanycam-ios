//
//  CameraSystemSettingViewController.m
//  Myanycam
//
//  Created by myanycam on 13-5-16.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "CameraSystemSettingViewController.h"
#import "AppDelegate.h"
#import "CameraPasswordEditViewController.h"
#import "TimeZoneViewController.h"


@implementation CameraDeviceCellData

@synthesize name;
@synthesize value;
@synthesize cellType;

- (id)initWithName:(NSString *)aName value:(NSString *)aValue cellType:(NSInteger) aCellType{
    
    self = [super init];
    if (self) {
        
        self.name = aName;
        self.value = aValue;
        self.cellType = aCellType;
    }

    return self;
}

+ (CameraDeviceCellData *)cameraDeviceCellInfo:(NSString *)aName value:(NSString *)aValue cellType:(NSInteger) aCellType{
    
    CameraDeviceCellData * cellData = [[[CameraDeviceCellData alloc] initWithName:aName value:aValue cellType:aCellType] autorelease];
    return cellData;
}

- (void)dealloc{
    
    self.name = nil;
    self.value = nil;
    [super dealloc];
}

@end


@interface CameraSystemSettingViewController ()

@end

@implementation CameraSystemSettingViewController
@synthesize dataArray ;
@synthesize cameraInfoData;


- (void)dealloc {
    [_systemSettingTableView release];
    self.currentTimeZone = nil;
    self.cameraInfoData = nil;
    self.dataArray = nil;
    self.cameraInfo = nil;
    [super dealloc];
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
    
    self.dataArray = [NSMutableArray arrayWithCapacity:5];
    
//    [self.dataArray addObject:[CameraDeviceCellData cameraDeviceCellInfo:NSLocalizedString(@"Change Camera Access Password", nil) value:self.cameraInfo.password cellType:0]];
    [self.dataArray addObject:[CameraDeviceCellData cameraDeviceCellInfo:NSLocalizedString(@"sn", nil) value:self.cameraInfoData.cameraSn cellType:0]];
    [self.dataArray addObject:[CameraDeviceCellData cameraDeviceCellInfo:NSLocalizedString(@"Mode", nil) value:self.cameraInfoData.mode cellType:1]];
    [self.dataArray addObject:[CameraDeviceCellData cameraDeviceCellInfo:NSLocalizedString(@"Timezone", nil) value:[NSString stringWithFormat:@"UTC %@",self.cameraInfoData.timezone]  cellType:2]];
//    [self.dataArray addObject:[CameraDeviceCellData cameraDeviceCellInfo:NSLocalizedString(@"Manufacturer", nil) value:self.cameraInfoData.producter cellType:4]];
    
    [self.systemSettingTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self showBackButton:self action:@selector(saveCameraDeviceSet) buttonTitle:@""];
    
//    self.title = NSLocalizedString(@"Camera Details", nil);
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    self.currentTimeZone = zone;
    
    self.systemSettingTableView.scrollEnabled = NO;
    
    [self prepareData];
}

- (void)saveCameraDeviceSet{
    
//    [self sendSetDeviceInfoRequest];
    [self goBack];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:
            {
//                CameraPasswordEditViewController * controller = [[CameraPasswordEditViewController alloc] init];
//                controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//                [self.navigationController pushViewController:controller animated:YES];
//                [controller release];
                
            }
                
                break;
            case 1:
            {
//                TimeZoneViewController * controller = [[TimeZoneViewController alloc] init];
//                controller.title = @"Timezone Edit";
//                controller.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:controller animated:YES];
//                [controller release];
            }
                
                break;
            default:
                break;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellStyle = @"cellType";
    
    CameraSetTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStyle];
    if (!cell){
        
        NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"CameraSetTableViewCell" owner:nil options:nil];
        if ([views count] >0 ) {
            
            cell= [views lastObject];
        }
        
    }
    
    CameraDeviceCellData * cellData = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.cellNameLabel.text = [NSString stringWithFormat:@"%@:%@",cellData.name,cellData.value];
    cell.checkImageView.hidden = YES;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 48;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArray count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (void)viewDidUnload {
    [self setSystemSettingTableView:nil];
    [super viewDidUnload];
}


- (void)getDeviceInfoRsp:(NSDictionary *)info{
    
    [[MYDataManager shareManager] updateCameraInfo:info];
    self.cameraInfo = [MYDataManager shareManager].cameraDeviceInfo;
    [self prepareData];
    [[AppDelegate getAppDelegate].window hideWaitAlertView];
}

- (void)setDeviceInfoRsp:(NSDictionary *)info{
    
    [[AppDelegate getAppDelegate].window hideWaitAlertView];
    
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
        
        [self saveCameraDeviceSet];
    }
}

- (void)cancelButtonAction:(NSDictionary *)info{
    
    [self goBack];
}


//- (void)sendSetDeviceInfoRequest{
//    
//    [[AppDelegate getAppDelegate].mygcdSocketEngine sendSetDeviceInfoRequest:self.cameraInfo.password timeZone:self.cameraInfo.timezone];
//}



@end

