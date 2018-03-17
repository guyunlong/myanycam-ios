//
//  WiFiSelectViewCell.m
//  myanycam
//
//  Created by myanycam on 13-2-26.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "WiFiSelectViewCell.h"

@implementation WiFiSelectViewCell
@synthesize wifiData = _wifiData;

- (void)dealloc{
    self.wifiData = nil;
    [_currentWiFiFlagImageView release];
    [_WiFiNameLabel release];
    [_passwordStateImageView release];
    [_wifiSingalLevelImageView release];
    [_settingButton release];
    [_cellBackImageView release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setWifiData:(WifiInfoData *)wifiData{
    if (_wifiData != wifiData) {
        [_wifiData release];
        _wifiData = [wifiData retain];
    }
    
    if (wifiData) {
        [self updateView];
    }
}

- (void)updateView{
    
    
    
    if (self.wifiData.password) {
        
        self.currentWiFiFlagImageView.hidden = NO;
        
    }
    else{
        self.currentWiFiFlagImageView.hidden = YES;
    }
    
    self.WiFiNameLabel.text = self.wifiData.ssid;
    
    int wifiLevel = [ToolClass wifiLevelFormat:self.wifiData.signal];
    NSString * imageName = nil;
        
    if (self.wifiData.safety > 0) {
        
        imageName= [NSString stringWithFormat:@"ic_wifi_lock_signal_%d",wifiLevel];
    }
    else{

        imageName= [NSString stringWithFormat:@"ic_wifi_signal_%d",wifiLevel];
    }
    
    UIImage * wifiLevelWifi = [UIImage imageNamed:imageName];
    self.wifiSingalLevelImageView.image = wifiLevelWifi;
    
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        
        self.cellBackImageView.backgroundColor = [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1.0];
    }
    else
    {
        self.cellBackImageView.backgroundColor = [UIColor colorWithRed:51/255.0 green:49/255.0 blue:50/255.0 alpha:1.0];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
