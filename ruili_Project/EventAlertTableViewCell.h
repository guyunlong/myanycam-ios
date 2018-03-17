//
//  EventAlertTableViewCell.h
//  Myanycam
//
//  Created by myanycam on 13-5-24.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventAlertTableViewCellData.h"

@protocol EventAlertTableViewCellDelegate;


@interface EventAlertTableViewCell : UITableViewCell
{
    EventAlertTableViewCellData * _cellData;
    UIImageView                 * _lineImageView;
    
}

@property (assign, nonatomic) id<EventAlertTableViewCellDelegate> delegate;
@property (retain, nonatomic) EventAlertTableViewCellData * cellData;
@property (assign, nonatomic) NSInteger cameraid;
@property (retain, nonatomic) IBOutlet UIImageView *alertTypeImage;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UIImageView *pictureImage;
@property (retain, nonatomic) IBOutlet UIImageView *videoImageView;
@property (retain, nonatomic) IBOutlet UIButton *watchAlertImageButton;
@property (retain, nonatomic) IBOutlet UIButton *watchAlertVideoButton;
@property (retain, nonatomic) IBOutlet UIImageView *alarmImageView;
@property (retain, nonatomic) IBOutlet UIImageView *cellBackImageView;

- (IBAction)watchAlertImageAction:(id)sender;
- (IBAction)watchAlertVideoAction:(id)sender;

@end


@protocol EventAlertTableViewCellDelegate <NSObject>

- (void)watchAlertImage:(EventAlertTableViewCellData *)cellData;
- (void)watchAlertVideo:(EventAlertTableViewCellData *)cellData;

@end