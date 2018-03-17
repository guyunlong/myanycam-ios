//
//  AlertSettingViewCell.m
//  Myanycam
//
//  Created by myanycam on 13-3-11.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "AlertSettingViewCell.h"
#import "MYDataManager.h"

@implementation AlertSettingViewCellData
@synthesize index;
@synthesize cellType;
@synthesize cellName;

+ (id)alertSettingCellData:(NSInteger)index name:(NSString *)cellName cellType:(CellDataType)cellType{
    AlertSettingViewCellData  * data = [[[AlertSettingViewCellData alloc] init] autorelease];
    data.index = index;
    data.cellName = cellName;
    data.cellType = cellType;
    return data;
}

- (void)dealloc{
    self.cellName = nil;
    [super dealloc];
}
@end


@implementation AlertSettingViewCell
@synthesize cellData = _cellData;
@synthesize delegate = _delegate;

- (void)dealloc {
    self.cellData = nil;
    self.delegate = nil;
    [_isOnSwitch release];
    [_cellName release];
    [_cellSwitch release];
    [_cellBackImageView release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib{
    
    // Initialization code
    [self.cellSwitch setDidChangeHandler:^(BOOL isOn) {
        NSLog(@"Biggest switch changed to %d", isOn);
        [self performSelector:@selector(switchAction:) withObject:nil afterDelay:0.2];
//        [self switchAction:nil];
    }];
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

- (void)setCellData:(AlertSettingViewCellData *)cellData{
    
    if (_cellData != cellData) {
        [_cellData release];
        _cellData = [cellData retain];
    }
    if (cellData) {
        
        AlertSettingData * settingData = [MYDataManager shareManager].alertSettingData;

        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.cellName.text = cellData.cellName;
        self.cellName.font = [UIFont systemFontOfSize:16];
//        self.cellName.textColor = Black_WORD_COLOR;
        
        switch (cellData.cellType) {
            case CellDataTypeIsNoiseAlert:
            {
             
                if (settingData.isNoiseAlert == 1) {
                    
                    [self.cellSwitch setOn:YES];
                }
                else{
                    
                    [self.cellSwitch setOn:NO];
                }
            }
                break;
            case CellDataTypeIsMotionAlert:
            {
                if (settingData.isMotionAlert == 1) {
                    
                    [self.cellSwitch setOn:YES];
                }
                else{
                    
                    [self.cellSwitch setOn:NO];
                }
            }
                break;
            case CellDataTypeAlertRecordSwitch:
            {
                if (settingData.isAlertRecord == 1) {
                    
                    [self.cellSwitch setOn:YES];
                }
                else{
                    
                    [self.cellSwitch setOn:NO];
                }
            }
                break;
                
            case CellDataTypeIsAllDayAlert:
            {
                if (settingData.alertType == 0) {
                    
                    [self.cellSwitch setOn:YES];
                }
                else{
                    [self.cellSwitch setOn:NO];
                }

            }
                break;
            case CellDataTypeIsPeriodAlert:{
                
                if (settingData.alertType == 1) {
                    
                    [self.cellSwitch setOn:YES];
                }
                else{
                    
                    [self.cellSwitch setOn:NO];
                }
            }
                break;
            case CellDataTypeCloseAlert:
            {
                if(settingData.alertSwitch == 1){
                    
                    [self.cellSwitch setOn:YES];
                }
                else{
                    
                    [self.cellSwitch setOn:NO];
                }
            }
                break;
                
            default:
                break;
        }
    }
}

//policy= 0; //报警策略 0：不报警 1：全天报警 2：分段报警
//voicealarm=1;	//声音报警 0:关闭 1：开启
//movealarm=1;// 移动侦测报警 0:关闭 1：开启
//record=1;     //报警是否录像 0：不录像 1：录像

- (void)switchAction:(id)sender {
    
    AlertSettingData * settingData = [MYDataManager shareManager].alertSettingData;

    KLSwitch * switchControl = self.cellSwitch;
    
    switch (self.cellData.cellType) {
        case CellDataTypeIsNoiseAlert:
        {
            settingData.isNoiseAlert = switchControl.isOn?1:0;
        }
            break;
        case CellDataTypeIsMotionAlert:
        {
            settingData.isMotionAlert = switchControl.isOn?1:0;
        }
            break;
        case CellDataTypeIsAllDayAlert:
        {
            
            settingData.alertType = self.cellSwitch.isOn?0:1;
            
            [self alertViewCellDelegate];
        }
            break;
        case CellDataTypeIsPeriodAlert:{
            
            settingData.alertType = self.cellSwitch.isOn?1:0;
            [self alertViewCellDelegate];
        }
            break;
        
        case CellDataTypeCloseAlert:{
            
             settingData.alertSwitch = self.cellSwitch.isOn?1:0;
            [self alertViewCellDelegate];
        }
            break;
            
        case CellDataTypeAlertRecordSwitch:{
            settingData.isAlertRecord = self.cellSwitch.isOn?1:0;
        }
            
        default:
            break;
    }
}

- (void)alertViewCellDelegate{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertSettingViewCellDelegate:)]) {
        [self.delegate alertSettingViewCellDelegate:self];
    }
}

@end
