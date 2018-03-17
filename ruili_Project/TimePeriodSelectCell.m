//
//  TimePeriodSelectCell.m
//  Myanycam
//
//  Created by myanycam on 13-3-6.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "TimePeriodSelectCell.h"


@implementation TimePeriodSelectCell
@synthesize delegate = _delegate;
@synthesize cellData = _cellData;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(TimePeriodSelectData *)cellData{
    
    if (cellData != _cellData) {
        
        [_cellData removeObserver:self forKeyPath:@"beginHour"];
        [_cellData removeObserver:self forKeyPath:@"beginmin"];
        [_cellData removeObserver:self forKeyPath:@"beginsec"];
        [_cellData removeObserver:self forKeyPath:@"overHour"];
        [_cellData removeObserver:self forKeyPath:@"overmin"];
        [_cellData removeObserver:self forKeyPath:@"oversec"];
        
        [_cellData release];
        
        _cellData = [cellData retain];
    }
    
    if (cellData) {
        
        [cellData addObserver:self forKeyPath:@"beginHour" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [cellData addObserver:self forKeyPath:@"beginmin" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [cellData addObserver:self forKeyPath:@"beginsec" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
        [cellData addObserver:self forKeyPath:@"overHour" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [cellData addObserver:self forKeyPath:@"overmin" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [cellData addObserver:self forKeyPath:@"oversec" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
//        UIImage * btnNorImage = [[UIImage imageNamed:@"checkbox_btn2_bg_nor@2x.png"] resizableImage];
//        UIImage * btnSelectImage = [[UIImage imageNamed:@"checkbox_btn2_bg_press@2x.png"] resizableImage];
//        [self.beginTimeButton setButtonBgImage:btnNorImage highlight:btnSelectImage];
//        [self.overTimeButton setButtonBgImage:btnNorImage highlight:btnSelectImage];
//        [self.deleteButton setShowsTouchWhenHighlighted:YES];
        
        self.indexLabel.text = [NSString stringWithFormat:@"%d",cellData.index];
        
        self.beginTimeLabel.layer.masksToBounds = YES;
        self.beginTimeLabel.layer.cornerRadius = 6;
        self.overTimeLabel.layer.masksToBounds = YES;
        self.overTimeLabel.layer.cornerRadius = 6;
        MYGestureRecognizer * gesture = [[MYGestureRecognizer alloc] initWithTarget:self action:@selector(beginButtonAction:)];
        [self.beginTimeLabel addGestureRecognizer:gesture];
        [gesture release];
        
        gesture = [[MYGestureRecognizer alloc] initWithTarget:self action:@selector(overTimeButtonAction:)];
        [self.overTimeLabel addGestureRecognizer:gesture];
        [gesture release];
        
        [self updateCellLabelText];
        
        self.StartTimeLabel.text = NSLocalizedString(@"Start Time", nil);
        self.endTimeLabel.text = NSLocalizedString(@"Stop Time", nil);
    }
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

- (void)updateCellLabelText{
    
    NSString * timeFormatHour = nil;
    NSString * timeFormatMin = nil;
    NSString * timeFormatSec = nil;
    
    timeFormatHour = [self timeStringWithInt:self.cellData.beginHour];
    timeFormatMin = [self timeStringWithInt:self.cellData.beginmin];
    timeFormatSec = [self timeStringWithInt:self.cellData.beginsec];
    
    self.beginTimeLabel.text = [NSString stringWithFormat:@"%@:%@:%@",timeFormatHour,timeFormatMin,timeFormatSec];
    
    timeFormatHour = [self timeStringWithInt:self.cellData.overHour];
    timeFormatMin = [self timeStringWithInt:self.cellData.overmin];
    timeFormatSec = [self timeStringWithInt:self.cellData.oversec];
    
    self.overTimeLabel.text = [NSString stringWithFormat:@"%@:%@:%@",timeFormatHour,timeFormatMin,timeFormatSec];
    [self.isOnSwitch setOn:(self.cellData.isOn == 1?YES:NO) animated:NO];
    
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{

    if ([keyPath isEqualToString:@"beginHour"]||[keyPath isEqualToString:@"beginmin"]||[keyPath isEqualToString:@"beginsec"]) {
        
//        self.beginTimeButton.hidden = YES;
//        self.beginTimeLabel.hidden = NO;
        NSString * timeFormatHour = nil;
        NSString * timeFormatMin = nil;
        NSString * timeFormatSec = nil;
        
        timeFormatHour = [self timeStringWithInt:self.cellData.beginHour];
        timeFormatMin = [self timeStringWithInt:self.cellData.beginmin];
        timeFormatSec = [self timeStringWithInt:self.cellData.beginsec];
      
        self.beginTimeLabel.text = [NSString stringWithFormat:@"%@:%@:%@",timeFormatHour,timeFormatMin,timeFormatSec];
    }
    
    if ([keyPath isEqualToString:@"overHour"]||[keyPath isEqualToString:@"overmin"]||[keyPath isEqualToString:@"oversec"]) {
        
//        self.overTimeButton.hidden = YES;
//        self.overTimeLabel.hidden = NO;
        
        NSString * timeFormatHour = nil;
        NSString * timeFormatMin = nil;
        NSString * timeFormatSec = nil;
        
        timeFormatHour = [self timeStringWithInt:self.cellData.overHour];
        timeFormatMin = [self timeStringWithInt:self.cellData.overmin];
        timeFormatSec = [self timeStringWithInt:self.cellData.oversec];
        
        self.overTimeLabel.text = [NSString stringWithFormat:@"%@:%@:%@",timeFormatHour,timeFormatMin,timeFormatSec];
    }
}

- (void)setBeginTimeButtonHighlightedState:(BOOL)flag{
    
    NSString * imageStr = nil;
    if (!flag) {
        
        imageStr = @"时间显示按扭.png";
    }
    else{
        
        imageStr = @"设置按扭.png";
    }
    
    UIImage * image = [UIImage imageNamed:imageStr];
    
    [self.beginTimeButton setButtonBgImage:image highlight:image];

}

- (void)setOverTimeButtonHighlightedState:(BOOL)flag{
    
    NSString * imageStr = nil;
    if (!flag) {
        
        imageStr = @"时间显示按扭.png";
    }
    else{
        
        imageStr = @"设置按扭.png";
    }
    
    UIImage * image = [UIImage imageNamed:imageStr];
    
    [self.overTimeButton setButtonBgImage:image highlight:image];
    
}
- (void)dealloc {
    
    self.delegate = nil;
    self.cellData = nil;
    [_beginTimeLabel release];
    [_overTimeLabel release];
    [_deleteButton release];
    [_beginTimeButton release];
    [_overTimeButton release];
    [_cellbgImageView release];
    [_indexLabel release];
    [_isOnSwitch release];//
    [_StartTimeLabel release];
    [_endTimeLabel release];
    [super dealloc];
}

- (IBAction)deleteButtonAction:(id)sender {
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(timePeroidSelectDelegate:cellData::)]) {
        [self.delegate timePeroidSelectDelegate:self cellData:self.cellData];
    }
}

- (IBAction)beginButtonAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellBeginButtonDelegate:cellData:)]) {
        [self.delegate cellBeginButtonDelegate:self cellData:self.cellData];
    }
}

- (IBAction)overTimeButtonAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellOverButtonDelegate:cellData:)]) {
        [self.delegate cellOverButtonDelegate:self cellData:self.cellData];
    }
}

- (IBAction)isSwitchAction:(id)sender {
    
    UISwitch * aSwitch = (UISwitch *)sender;
    self.cellData.isOn = aSwitch.isOn?1:0;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellSwitchStateChange:cellData:)]) {
        [self.delegate cellSwitchStateChange:self cellData:self.cellData];
    }
}
@end
