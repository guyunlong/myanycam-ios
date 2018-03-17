//
//  CameraSetTableViewCell.h
//  KCam
//
//  Created by myanycam on 2014/5/28.
//  Copyright (c) 2014年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface  CameraSetData: NSObject

@property (nonatomic, retain) NSString * cellText;
@property (nonatomic, assign) CameraSetType cameraSetType;

+ (CameraSetData *)cameraSetDataWithCellText:(NSString *)cellTextStr cellSetType:(CameraSetType)setType;

@end


@interface CameraSetTableViewCell : UITableViewCell{
    
    CameraSetData * _cellData;
}

@property (retain, nonatomic) CameraSetData * cellData;
@property (retain, nonatomic) IBOutlet UIImageView *cellBackImageView;
@property (retain, nonatomic) IBOutlet UILabel *cellNameLabel;
@property (retain, nonatomic) IBOutlet UIImageView *checkImageView;

@end

