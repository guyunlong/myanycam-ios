//
//  RecordVideoSetCell.h
//  Myanycam
//
//  Created by myanycam on 13-2-28.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RecordVideoSetDelegate;

@interface RecordVideoSetCell : UITableViewCell{
    RecordVideoSetCellData * _cellData;
}

@property (retain, nonatomic) IBOutlet UISwitch *cellSwitch;
@property (retain, nonatomic) RecordVideoSetCellData * cellData;
@property (retain, nonatomic) IBOutlet UILabel *cellNameLabel;
@property (retain, nonatomic) IBOutlet UIImageView *selectStateImageView;
@property (assign, nonatomic) id<RecordVideoSetDelegate> delegate;


- (IBAction)cellSwitchAction:(id)sender;


@end

@protocol RecordVideoSetDelegate <NSObject>

- (void)recordVideoSwitchChange:(RecordVideoSetCell *)cell;

@end