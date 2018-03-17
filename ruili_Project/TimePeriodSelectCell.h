//
//  TimePeriodSelectCell.h
//  Myanycam
//
//  Created by myanycam on 13-3-6.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimePeroidSelectDelegate;



@interface TimePeriodSelectCell : UITableViewCell{
    TimePeriodSelectData        * _cellData;
    id<TimePeroidSelectDelegate> _delegate;
}

@property (assign, nonatomic) id<TimePeroidSelectDelegate>  delegate;
@property (retain, nonatomic) TimePeriodSelectData        * cellData;
@property (retain, nonatomic) IBOutlet UIButton *beginTimeButton;
@property (retain, nonatomic) IBOutlet UIButton *overTimeButton;
@property (retain, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *overTimeLabel;
@property (retain, nonatomic) IBOutlet UIButton *deleteButton;
@property (retain, nonatomic) IBOutlet UIImageView *cellbgImageView;
@property (retain, nonatomic) IBOutlet UISwitch *isOnSwitch;
@property (retain, nonatomic) IBOutlet UILabel *indexLabel;
@property (retain, nonatomic) IBOutlet UILabel *StartTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *endTimeLabel;


- (IBAction)deleteButtonAction:(id)sender;
- (IBAction)beginButtonAction:(id)sender;
- (IBAction)overTimeButtonAction:(id)sender;
- (IBAction)isSwitchAction:(id)sender;


- (void)setBeginTimeButtonHighlightedState:(BOOL)flag;
- (void)setOverTimeButtonHighlightedState:(BOOL)flag;

@end


@protocol TimePeroidSelectDelegate <NSObject>

- (void)timePeroidSelectDelegate:(TimePeriodSelectCell *)cell cellData:(TimePeriodSelectData *)cellData;
- (void)cellBeginButtonDelegate:(TimePeriodSelectCell *)cell cellData:(TimePeriodSelectData *)cellData;
- (void)cellOverButtonDelegate:(TimePeriodSelectCell *)cell cellData:(TimePeriodSelectData *)cellData;
- (void)cellSwitchStateChange:(TimePeriodSelectCell *)cell cellData:(TimePeriodSelectData *)cellData;

@end