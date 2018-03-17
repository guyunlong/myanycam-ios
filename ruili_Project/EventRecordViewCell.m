//
//  EventRecordViewCell.m
//  Myanycam
//
//  Created by myanycam on 13-5-24.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "EventRecordViewCell.h"
#import "MYDataManager.h"
@implementation EventRecordViewCell

@synthesize cellData = _cellData;
@synthesize cameraInfo;


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

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        
        self.cellBackImageView.backgroundColor = [UIColor colorWithRed:50/255.0 green:51/255.0 blue:53/255.0 alpha:1.0];
    }
    else
    {
        self.cellBackImageView.backgroundColor = [UIColor clearColor];
    }
}

- (void)setCellData:(EventAlertTableViewCellData *)cellData{
    
    if (_cellData != cellData) {
        
        [_cellData release];
        
        _cellData = [cellData retain];
    }
    
    if (cellData) {
        
        [self updateView];
        
        if (!_lineImageView) {
            
            CGFloat w =  [UIScreen mainScreen].bounds.size.width;
            UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height -1, w, 1)];
            imageview.backgroundColor = TABLE_LINE_COLOR;
            _lineImageView = [imageview retain];
            _lineImageView.alpha = 0.6;
            [self.contentView.superview addSubview:imageview];
            [imageview release];
        }
    }
}

- (void)updateView{
    
    self.recordTimeLabel.text = self.cellData.formatEventTime;
    self.recordTimeLabel.textColor = Black_WORD_COLOR;
    
    NSString * imageStr = @"手动录制.png";
//    switch (self.cellData.recordType)
    switch (0)
    {
        case RecordTypeAlert:
        {
            imageStr = @"报警录制.png";
        }
            
            break;
        case RecordTypeManually:
        {
            imageStr = @"手动录制.png";
        }
            
            break;
        case RecordTypeTiming:
        {
            imageStr = @"定时录像.png";
        }
            
            break;
        default:
            break;
    }
    
    imageStr = @"icon8.png";
    self.recordTypeImageView.image = [UIImage imageNamed:imageStr];
    
    NSString * fileName = self.cellData.videoFileName;
    fileName = [NSString stringWithFormat:@"%@_%@",self.cameraInfo.cameraSn,fileName];
    
    if ([[MYDataManager shareManager] checkHaveDownloadVideoWithFileName:fileName]) {
     
        [self.downFileButton setBackgroundImage:[UIImage imageNamed:@"icon10_1.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.downFileButton setBackgroundImage:[UIImage imageNamed:@"icon10.png"] forState:UIControlStateNormal];
    }
    
}

- (void)dealloc {
    
    self.cellData = nil;
    self.delegate = nil;
    self.cameraInfo = nil;
    [_recordTypeImageView release];
    [_recordTimeLabel release];
    [_cellBackImageView release];
    [_lineImageView release];
    _lineImageView = nil;
    [_downFileButton release];
    [super dealloc];
}

- (IBAction)downFileButtonAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(downLoadFile:cell:)]) {
        
        [self.delegate downLoadFile:self.cellData cell:self];
    }
    
    
    
}

- (void)changeDownLoadButtonState{
    
    
    NSString * fileName = self.cellData.videoFileName;
    fileName = [NSString stringWithFormat:@"%@_%@",self.cameraInfo.cameraSn,fileName];
    if ([[MYDataManager shareManager] checkHaveDownloadVideoWithFileName:fileName]) {
        
        [self.downFileButton setBackgroundImage:[UIImage imageNamed:@"icon10_1.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.downFileButton setBackgroundImage:[UIImage imageNamed:@"icon10.png"] forState:UIControlStateNormal];
    }
    
}

@end
