//
//  WiFiSelectViewController.m
//  myanycam
//
//  Created by myanycam on 13-2-26.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "WiFiSelectViewController.h"
#import "WifiSettingViewController.h"
#import "WifiInfoData.h"
#import "WiFiSelectViewCell.h"
#import "AppDelegate.h"

@interface WiFiSelectViewController ()

@end

@implementation WiFiSelectViewController
@synthesize dataArray = _dataArray;
@synthesize sectionArray = _sectionArray;
@synthesize cameraInfo;

- (void)dealloc {

    self.cameraInfo = nil;
    self.dataArray = nil;
    self.sectionArray = nil;
    [_wifiSelectTableView release];
    [_wifiListLabel release];
    [_addwifiButton release];
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

-(AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)prepareData{
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.sectionArray = [NSMutableArray arrayWithCapacity:0];
    
    if ([[self appDelegate].mygcdSocketEngine isConnect]) {
        
        [self appDelegate].mygcdSocketEngine.dealObject.wifiSelectDelegate = self;
        [[self appDelegate].mygcdSocketEngine sendGetWifiInfoRequest:self.cameraInfo.cameraId];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.wifiSelectTableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self prepareData];
    
    
    NSString * imageNormalStr = @"icon_Return.png";
    NSString * imageSelectStr = @"icon_Return_hover.png";
    NSString * title = NSLocalizedString(@"", nil);
    UIBarButtonItem *backButton = [ViewToolClass customBarButtonItem:imageNormalStr buttonSelectImage:imageSelectStr title:title size:CGSizeMake(32, 32) target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.wifiListLabel.text = NSLocalizedString(@"Choose a Network", nil);
    [self.addwifiButton setTitle:NSLocalizedString(@"Add WIFI", nil) forState:UIControlStateNormal];
    
//    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
//        
//        [self.wifiSelectTableView setBackgroundView:nil];
//        [self.wifiSelectTableView setBackgroundView:[[[UIView alloc] init] autorelease]];
//        [self.wifiSelectTableView setBackgroundColor:UIColor.clearColor];
//    }
    
}

- (void)goBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSString* )tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellStyle = @"wifiCell";
    WiFiSelectViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStyle];
    if (!cell) {
        NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"WiFiSelectViewCell" owner:nil options:nil];
        if ([views count]) {
            cell = [views lastObject];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    WifiInfoData * data = [self.dataArray objectAtIndex:indexPath.row];
    cell.wifiData = data;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArray count];
    
}

- (void)goToSettingDetailView:(NSIndexPath *)indexPath{
    
    
    WifiSettingViewController * controller = [[WifiSettingViewController alloc] init];
    controller.cameraInfo = self.cameraInfo;
    controller.wifiInfoData = [self.dataArray objectAtIndex:indexPath.row];
    controller.title = @"WiFi";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"",nil) style:UIBarButtonSystemItemCancel target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [backButton release];
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            [self goToSettingDetailView:indexPath];
        }
            break;
            
        default:
            break;
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)wifiInfoListInfo:(NSDictionary *)info{
    
    [[self appDelegate].window hideWaitAlertView];
    
    if ([[info objectForKey:@"cmd"] isEqualToString:@"WIFI_INFO"]) {
        
        WifiInfoData * data = [[WifiInfoData alloc] init];
        data.ssid = [info objectForKey:@"ssid"];
        data.safety = [[info objectForKey:@"safety"] intValue];
        data.password = [info objectForKey:@"password"];
        
        [MYDataManager shareManager].currnetWifiData = data;
        [self.dataArray addObject:data];
        [data release];
        
        
    }
    if ([[info objectForKey:@"cmd"] isEqualToString:@"HOT_SPOT"]) {
        
        WifiInfoData * data = [[WifiInfoData alloc] init];
        data.ssid = [info objectForKey:@"ssid"];
        data.safety = [[info objectForKey:@"safety"] intValue];
        data.signal = [[info objectForKey:@"signal"] intValue];
        
        BOOL flag = NO;
        
        if ([MYDataManager shareManager].currnetWifiData && [[MYDataManager shareManager].currnetWifiData.ssid isEqualToString:data.ssid]) {
            
            data.password = [MYDataManager shareManager].currnetWifiData.password;
            [MYDataManager shareManager].currnetWifiData.safety = data.safety;
            [MYDataManager shareManager].currnetWifiData.signal = data.signal;
//            [MYDataManager shareManager].currnetWifiData = data;
            
            flag = YES;
        }
        
        if (!flag) {
            
            [self.dataArray addObject:data];
        }
        
        [data release];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.wifiSelectTableView reloadData];
    });
    
}

- (void)viewDidUnload {
    
    [self setWifiSelectTableView:nil];
    [self setWifiListLabel:nil];
    [self setAddwifiButton:nil];
    [super viewDidUnload];
}

- (IBAction)addWifiButtonAction:(id)sender {
    
    WifiSettingViewController * controller = [[WifiSettingViewController alloc] init];
    controller.cameraInfo = self.cameraInfo;
    controller.wifiDataArray = self.dataArray;
    
    WifiInfoData * data = [[WifiInfoData alloc] init];
    data.ssid = @"";
    data.safety = 0;
    data.signal = 0;
    data.isManualAdd = YES;
    controller.wifiInfoData = data;
    [data release];
    
    controller.title = NSLocalizedString(@"Add WIFI",nil);
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back",nil) style:UIBarButtonSystemItemCancel target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [backButton release];
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

@end
