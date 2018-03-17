//
//  RecordVideoSetCell.m
//  Myanycam
//
//  Created by myanycam on 13-2-28.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "RecordVideoSetCell.h"
#import "MYDataManager.h"

@implementation RecordVideoSetCell
@synthesize cellData = _cellData;
@synthesize delegate;

- (void)dealloc {
    self.cellData = nil;
    self.delegate = nil;
    [_cellSwitch release];
    [_cellNameLabel release];
    [_selectStateImageView release];
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

- (void)setCellData:(RecordVideoSetCellData *)cellData{
    
    if (_cellData != cellData) {
        
        [_cellData removeObserver:self forKeyPath:@"isSelect"];
        [_cellData release];
        _cellData = [cellData retain];
    }
    if (cellData) {
        
        [cellData addObserver:self forKeyPath:@"isSelect" options:NSKeyValueObservingOptionNew|
         NSKeyValueObservingOptionOld context:nil];
        
        [self updataCellView];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"isSelect"]) {
        
        if (self.cellData.cellType != CellDataTypeRecordVideoCycleOpenSwitch){
            
            if (self.cellData.isSelect) {
                [self.selectStateImageView customShowWithAnimation:YES duration:0.2];
            }
            else{
                [self.selectStateImageView customHideWithAnimation:YES duration:0.2];
            }
        }
    }
}
- (void)updataCellView{
    
    RecordVideoSettingData * recordData = [MYDataManager shareManager].recordVideoSettingData;
    
    switch (self.cellData.cellType) {
            
        case CellDataTypeRecordVideoSettingPlan:
        {
            if (recordData.recordPolicy == 1) {
                
                [self.cellSwitch setOn:YES];
            }
            else{
                
                [self.cellSwitch setOn:NO];
            }
        }
            break;
        case CellDataTypeAllHoursRecordVideo:
        {
            if (recordData.recordPolicy == 0) {
                
                [self.cellSwitch setOn:YES];
            }
            else{
                
                 [self.cellSwitch setOn:NO];
            }
            
        }
            break;
        case CellDataTypeNotRecordVideo:
        {
            if (recordData.recordSwitch == 0) {
                
                [self.cellSwitch setOn:NO];
            }
            else{
                
                [self.cellSwitch setOn:YES];
            }
            
        }
            break;
        default:
            break;
    }
    
    self.cellNameLabel.text = self.cellData.cellText;
    self.selectStateImageView.hidden = YES;

}

- (void)recordStateChange{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordVideoSwitchChange:)]) {
        
        [self.delegate recordVideoSwitchChange:self];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)cellSwitchAction:(id)sender {
    
    RecordVideoSettingData * recordData = [MYDataManager shareManager].recordVideoSettingData;
        
    switch (self.cellData.cellType) {
            
        case CellDataTypeRecordVideoSettingPlan:
        {
            recordData.recordPolicy = self.cellSwitch.isOn?1:0;
            [self recordStateChange];
        }
            break;
        case CellDataTypeAllHoursRecordVideo:
        {
            recordData.recordPolicy = self.cellSwitch.isOn?0:1;
            [self recordStateChange];
        }
            break;
        case CellDataTypeNotRecordVideo:
        {
            recordData.recordSwitch = self.cellSwitch.isOn?1:0;
            [self recordStateChange];
        }
            break;
        default:
            break;
    }
}
@end
