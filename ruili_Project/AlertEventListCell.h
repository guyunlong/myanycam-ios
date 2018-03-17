//
//  AlertEventListCell.h
//  Myanycam
//
//  Created by myanycam on 13-5-2.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertEventListCell : UITableViewCell
{
    CameraInfoData      * _cameraInfo;
}
@property (retain, nonatomic) IBOutlet UIImageView *cameraImageView;
@property (retain, nonatomic) IBOutlet UILabel *cameraName;
@property (retain, nonatomic) CameraInfoData * cameraInfo;

@end
