//
//  EventAlertTableViewCell.m
//  Myanycam
//
//  Created by myanycam on 13-5-24.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

//
//四、报警图像文件名说明
// 0_20130524110405_1_0_20130524110003.jpg
//1 事件类型： 0：移动侦测 1：声音 >1 是外接报警器报警
//2 事件产生的时间：固定的长度和格式
//3 是否有录像：0：没有 1：有
//4 录像类型：0：定时录像 1：报警录像 2：手动录像
//5 录像时间：固定格式和长度
//
// 上面事例的录像文件名就是0_20130524110003.mp4

//只有图片，没有录像的报警事件  0_20130524110405_0.jpg

//1_20130614201815_1_20130603114314.mp4.jpg

#import "EventAlertTableViewCell.h"
#import "MYDataManager.h"

@implementation EventAlertTableViewCell
@synthesize cellData = _cellData;
@synthesize delegate;
@synthesize cameraid;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAlarmImage:) name:KNotificationDownAlarmImage object:nil];
    }
    
    return self;
}

- (void)updateAlarmImage:(NSNotification *)notify{
    
    
    
//    NSString * imageFilePath = (NSString *)notify.object;
//    NSString * urlStr = [[imageFilePath pathComponents] lastObject];
//    if ([urlStr isEqualToString:self.cellData.fileName]) {
//        
//        UIImage * image   = [UIImage imageWithContentsOfFile:imageFilePath];
//        DebugLog(@"imageFilePath %@",imageFilePath);
//        self.alarmImageView.image = image;
//    }

    
}

- (void)setCellData:(EventAlertTableViewCellData *)cellData{
    
    if (_cellData != cellData) {
        [_cellData release];
        _cellData = [cellData retain];
    }
    
    if (cellData) {
        
        [self updataView];
        
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

- (void)updataView{
    
    
    NSString * alertTypeImageStr = @"躁声报警.png";
    
    if (self.cellData.alertType == AlertTypeMotion) {
        
        alertTypeImageStr = @"移动帧测.png";
    }
    if (self.cellData.alertType == AlertTypeNoise) {
        
        alertTypeImageStr = @"躁声报警.png";
    }
    if (self.cellData.alertType == AlertTypeManual) {
        
        alertTypeImageStr = @"手动拍照.png";
    }
    
    if (self.cellData.alertType == AlertTypeThermalInfrared) {
        
        alertTypeImageStr = @"红外报警.png";
        DebugLog(@"红外报警");
    }
    
    alertTypeImageStr = @"icon9.png";
    
    UIImage * alertTypeimagea = [UIImage imageNamed:alertTypeImageStr];
    self.alertTypeImage.image = alertTypeimagea;
    
    self.pictureImage.image = [UIImage imageNamed:@"photo02.png"];
    
    if (self.cellData.flagRecord == 1) {
        
        NSString * fileName = [NSString stringWithFormat:@"%@.MP4",self.cellData.recordTime];
        
        if ([[[MYDataManager shareManager] getRecordDataWithCameraId:self.cameraid] cellDataWithFileName:fileName]) {
            
              self.videoImageView.hidden = NO;
        }
        else{
              self.videoImageView.hidden = YES;
        }
       
    }
    else{
        self.videoImageView.hidden = YES;
    }
    
    self.timeLabel.text = self.cellData.formatEventTime;
    
    self.timeLabel.textColor = Black_WORD_COLOR;
    
    if (self.cellData.flagRecord == 0) {
        
        self.watchAlertVideoButton.hidden = YES;
    }
    else
    {
        self.watchAlertVideoButton.hidden = NO;
    }
   
    if ([MYDataManager shareManager].deviceTpye > DeviceTypeIphone5) {
        
        self.watchAlertVideoButton.autoresizingMask =  UIViewAutoresizingFlexibleRightMargin
        |UIViewAutoresizingFlexibleTopMargin;
    }
    
//    NSString * urlStr = self.cellData.fileName;
//    NSString * fileName =  [NSString stringWithFormat:@"%d_%@",[MYDataManager shareManager].currentCameraData.cameraId,urlStr];
//    NSString *  path = [[MYDataManager shareManager] getFilePathAtDocument:KdownloadImage];
//    NSString *  downloadimagePath = [path stringByAppendingPathComponent:fileName];
//    
//    UIImage * image   = [UIImage imageWithContentsOfFile:downloadimagePath];
//    if (image) {
//
//        self.alarmImageView.image = image;
//    }
//    else{
//        
//        self.alarmImageView.image = nil;
//        [[MYDataManager shareManager] getAlarmImageUrlWithName:self.cellData.fileName];
//    }
    
}

- (void)dealloc {
    
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationDownAlarmImage object:nil];
    
    self.cellData = nil;
    [_alertTypeImage release];
    [_timeLabel release];
    [_pictureImage release];
    [_videoImageView release];
    [_watchAlertImageButton release];
    [_watchAlertVideoButton release];
    [_lineImageView release];
    _lineImageView = nil;
    [_alarmImageView release];
    [_cellBackImageView release];
    [super dealloc];
}

- (IBAction)watchAlertImageAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(watchAlertImage:)]) {
        
        [self.delegate watchAlertImage:self.cellData];
    }
}

- (IBAction)watchAlertVideoAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(watchAlertVideo:)]) {
        
        [self.delegate watchAlertVideo:self.cellData];
    }
}
@end
