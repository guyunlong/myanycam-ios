//
//  AlertSettingViewCell.h
//  Myanycam
//
//  Created by myanycam on 13-3-11.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLSwitch.h"

@interface AlertSettingViewCellData : NSObject

@property (retain, nonatomic) NSString * cellName;
@property (assign, nonatomic) CellDataType cellType;
@property (assign, nonatomic) NSInteger index;

+ (id)alertSettingCellData:(NSInteger)index name:(NSString *)cellName cellType:(CellDataType)cellType;

@end

@protocol AlertSettingViewCellDelegate;

@interface AlertSettingViewCell : UITableViewCell{
    AlertSettingViewCellData    *_cellData;
    id<AlertSettingViewCellDelegate> _delegate;
}

@property (assign, nonatomic) id<AlertSettingViewCellDelegate> delegate;
@property (retain, nonatomic) AlertSettingViewCellData * cellData;
@property (retain, nonatomic) IBOutlet UISwitch *isOnSwitch;
@property (retain, nonatomic) IBOutlet UILabel *cellName;
@property (retain, nonatomic) IBOutlet KLSwitch *cellSwitch;
@property (retain, nonatomic) IBOutlet UIImageView *cellBackImageView;

- (void)switchAction:(id)sender;

@end


@protocol AlertSettingViewCellDelegate <NSObject>

- (void)alertSettingViewCellDelegate:(AlertSettingViewCell *)cell;

@end