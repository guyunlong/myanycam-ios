//
//  CameraListTableCell.h
//  Myanycam
//
//  Created by myanycam on 13-3-25.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CameraListCellDelegate;


@interface CameraListTableCell : UITableViewCell{

    CameraInfoData  * _cellCameraData;
    
}

@property (assign, nonatomic) id<CameraListCellDelegate>   delegate;
@property (retain, nonatomic) CameraInfoData * cellCameraData;
@property (retain, nonatomic) IBOutlet UIImageView *cellBackImageView;
@property (retain, nonatomic) IBOutlet UILabel *cameraName;
@property (retain, nonatomic) IBOutlet UILabel *cameraStateLabel;
@property (retain, nonatomic) IBOutlet UIImageView *cameraStateImageView;
@property (retain, nonatomic) IBOutlet UIButton *settingButton;

- (void)updateDeSelectState;
- (void)updateSelectState;

- (IBAction)settingButton:(id)sender;

@end


@protocol CameraListCellDelegate <NSObject>
- (void)cameraSettingWithCameraData:(CameraInfoData *)cameraData;
@end