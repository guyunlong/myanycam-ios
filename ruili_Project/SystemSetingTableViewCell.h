//
//  SystemSetingTableViewCell.h
//  KCam
//
//  Created by myanycam on 2014/5/27.
//  Copyright (c) 2014年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemSetData : NSObject

@property (nonatomic, retain) NSString * cellText;
@property (nonatomic, assign) SystemSetType systemType;

+ (SystemSetData *)SystemDataWith:(NSString *)cellTextStr setType:(SystemSetType)setType;

@end


@interface SystemSetingTableViewCell : UITableViewCell
{
    SystemSetData * _cellData;
}

@property (retain, nonatomic) SystemSetData * cellData;
@property (retain, nonatomic) IBOutlet UIImageView *cellImage;
@property (retain, nonatomic) IBOutlet UIImageView *cellBackImageView;
@property (retain, nonatomic) IBOutlet UIImageView *cellChevronImageView;
@property (retain, nonatomic) IBOutlet UILabel *cellNameLabel;


@end
