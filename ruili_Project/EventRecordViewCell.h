//
//  EventRecordViewCell.h
//  Myanycam
//
//  Created by myanycam on 13-5-24.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventAlertTableViewCell.h"

@protocol EventRecordViewDelegate;


@interface EventRecordViewCell : UITableViewCell{
    
    EventAlertTableViewCellData * _cellData;
    UIImageView * _lineImageView;
}

@property (retain, nonatomic) EventAlertTableViewCellData * cellData;
@property (retain, nonatomic) IBOutlet UIImageView *recordTypeImageView;
@property (retain, nonatomic) IBOutlet UILabel *recordTimeLabel;
@property (retain, nonatomic) IBOutlet UIImageView *cellBackImageView;
@property (assign, nonatomic) id<EventRecordViewDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIButton *downFileButton;
@property (retain, nonatomic) CameraInfoData    *cameraInfo;

- (IBAction)downFileButtonAction:(id)sender;

- (void)changeDownLoadButtonState;

@end


@protocol EventRecordViewDelegate <NSObject>

- (void)downLoadFile:(EventAlertTableViewCellData *)cellData cell:(EventRecordViewCell *)cell;

@end