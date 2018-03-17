//
//  WiFiSelectViewCell.h
//  myanycam
//
//  Created by myanycam on 13-2-26.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WifiInfoData.h"

@interface WiFiSelectViewCell : UITableViewCell
{
    WifiInfoData    *_wifiData;
}

@property (retain, nonatomic) IBOutlet UIImageView *currentWiFiFlagImageView;
@property (retain, nonatomic) IBOutlet UILabel *WiFiNameLabel;
@property (retain, nonatomic) IBOutlet UIImageView *passwordStateImageView;
@property (retain, nonatomic) IBOutlet UIImageView *wifiSingalLevelImageView;
@property (retain, nonatomic) IBOutlet UIButton *settingButton;
@property (retain, nonatomic) WifiInfoData * wifiData;
@property (retain, nonatomic) IBOutlet UIImageView *cellBackImageView;


@end
