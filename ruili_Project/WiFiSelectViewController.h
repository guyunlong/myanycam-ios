//
//  WiFiSelectViewController.h
//  myanycam
//
//  Created by myanycam on 13-2-26.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WifiInfoData.h"

@interface WiFiSelectViewController : BaseViewController<WifiSelectDelegate ,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray      *_dataArray;
    NSMutableArray      *_sectionArray;
}

@property (retain, nonatomic) CameraInfoData * cameraInfo;
@property (retain, nonatomic) NSMutableArray    *dataArray;
@property (retain, nonatomic) NSMutableArray    *sectionArray;
@property (retain, nonatomic) IBOutlet UITableView *wifiSelectTableView;
@property (retain, nonatomic) IBOutlet UILabel *wifiListLabel;
@property (retain, nonatomic) IBOutlet UIButton *addwifiButton;

- (IBAction)addWifiButtonAction:(id)sender;

@end
