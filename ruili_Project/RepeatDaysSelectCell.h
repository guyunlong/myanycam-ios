//
//  RepeatDaysSelectCell.h
//  Myanycam
//
//  Created by myanycam on 13-3-5.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WeekDayData : NSObject
@property (assign, nonatomic) NSInteger  index;
@property (retain, nonatomic) NSString * dayName;
@property (assign, nonatomic) BOOL  selectState;

+ (WeekDayData *)weekDayData:(NSInteger )index dayName:(NSString *)dayName seletState:(BOOL)selectState;

@end

@interface RepeatDaysSelectCell : UITableViewCell{
    WeekDayData     *_cellData;
}

@property (retain, nonatomic) IBOutlet UIImageView *selectStateImageView;
@property (retain, nonatomic) IBOutlet UILabel *weekNameLabel;
@property (retain, nonatomic) WeekDayData   *cellData;
@end
