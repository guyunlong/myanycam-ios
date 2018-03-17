//
//  CameraSetSwitchTableViewCell.h
//  KCam
//
//  Created by myanycam on 2014/5/29.
//  Copyright (c) 2014年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLSwitch.h"

@protocol CameraSetSwitchTableDelegate;

@interface CameraSetSwitchTableViewCell : UITableViewCell
{
    RecordVideoSetCellData * _cellData;
}

@property (retain, nonatomic) RecordVideoSetCellData * cellData;
@property (retain, nonatomic) IBOutlet UILabel *cellTextLabel;
@property (retain, nonatomic) IBOutlet KLSwitch *cellSwitch;
@property (retain, nonatomic) IBOutlet UIImageView *cellBackImageView;
@property (assign, nonatomic) id<CameraSetSwitchTableDelegate> delegate;

@end


@protocol CameraSetSwitchTableDelegate <NSObject>

- (void)cameraSetSwitchChange:(CameraSetSwitchTableViewCell *)cell;

@end