//
//  RepeatDaysSelectCell.m
//  Myanycam
//
//  Created by myanycam on 13-3-5.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "RepeatDaysSelectCell.h"



@implementation WeekDayData

@synthesize index;
@synthesize dayName;
@synthesize selectState;

+ (WeekDayData *)weekDayData:(NSInteger )index dayName:(NSString *)dayName seletState:(BOOL)selectState{
    WeekDayData * data  = [[[WeekDayData alloc] init] autorelease];
    data.index = index;
    data.dayName = dayName;
    data.selectState = selectState;
    return data;
}

- (void)dealloc{
    self.dayName = nil;
    [super dealloc];
}
@end



@implementation RepeatDaysSelectCell
@synthesize cellData = _cellData;

- (void)dealloc{
    self.cellData = nil;
    [_selectStateImageView release];
    [_weekNameLabel release];
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

- (void)setCellData:(WeekDayData *)cellData{
    if (cellData != _cellData) {
        [_cellData removeObserver:self forKeyPath:@"selectState"];
        [_cellData release];
        _cellData = [cellData retain];
        
        
    }
    if (cellData) {
        [cellData addObserver:self forKeyPath:@"selectState" options:NSKeyValueObservingOptionNew|
         NSKeyValueObservingOptionOld context:nil];
        
        
        if (cellData.selectState != 0) {
            
            self.selectStateImageView.hidden = NO;
        }
        else{
            
            self.selectStateImageView.hidden = YES;
        }
        
        self.weekNameLabel.text = cellData.dayName;
        
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"selectState"]) {
        if (self.cellData.selectState) {
            
            [self.selectStateImageView customShowWithAnimation:YES duration:0.2];
        }
        else{
            
            [self.selectStateImageView customHideWithAnimation:YES duration:0.2];
        }
    }
}
@end
