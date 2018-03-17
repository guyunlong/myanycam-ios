//
//  RecordListData.h
//  Myanycam
//
//  Created by myanycam on 13-5-22.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventAlertTableViewCell.h"


@interface RecordListData : NSObject


@property (assign, nonatomic) NSInteger userid;
@property (assign, nonatomic) NSInteger pos;
@property (assign, nonatomic) NSInteger cameraId;
@property (assign, nonatomic) NSInteger count;
@property (retain, nonatomic) NSMutableDictionary * fileDict;

- (id)initWithInfo:(NSDictionary *)info;
- (void)addInfoWithDict:(NSDictionary *)info;
- (void)deleteFileWithName:(NSString *)fileName;
- (void)addEventData:(EventAlertTableViewCellData *)eventData;
- (EventAlertTableViewCellData * )cellDataWithFileName:(NSString *)fileName;

@end
