//
//  VideoQualitySettingViewController.h
//  Myanycam
//
//  Created by myanycam on 13/7/15.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "BaseViewController.h"
#import "ApsystemsetgetVideoSizeDelegate.h"
#import "CloudModelVideoQualitySetDelegate.h"

@interface VideoQualitySettingViewController : BaseViewController<ApsystemsetgetVideoSizeDelegate,CloudModelVideoQualitySetDelegate>


//@property (retain, nonatomic) IBOutlet UILabel *recordQualityLabel;
//@property (retain, nonatomic) IBOutlet UILabel *liveQualityLabel;
//@property (retain, nonatomic) IBOutlet UISegmentedControl *recordQualityControl;
//@property (retain, nonatomic) IBOutlet UISegmentedControl *videoQualitySettingControl;

@property (retain, nonatomic) IBOutlet UILabel *liveQualityLabel;
@property (retain, nonatomic) IBOutlet UILabel *recordQualityLabel;
@property (retain, nonatomic) IBOutlet UISegmentedControl *recordQualityControl;
@property (retain, nonatomic) IBOutlet UISegmentedControl *videoQualitySettingControl;



- (IBAction)liveQualitySettingAction:(id)sender;
- (IBAction)videoSizeSettingAction:(id)sender;
@end
