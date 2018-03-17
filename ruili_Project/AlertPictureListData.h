//
//  AlertPictureListData.h
//  Myanycam
//
//  Created by myanycam on 13-5-22.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventAlertTableViewCellData.h"
#import "AlertEventData.h"

@interface AlertPictureListData : NSObject

@property (assign, nonatomic) NSInteger userid;
@property (assign, nonatomic) NSInteger pos;
@property (assign, nonatomic) NSInteger cameraId;
@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) NSInteger total;

@property (retain, nonatomic) NSMutableDictionary * fileDict;
@property (retain, nonatomic) NSMutableArray * alertImageSourceArray;



- (id)initWithInfo:(NSDictionary *)info;
- (id)initDataWithAlertEvent:(AlertEventData *)alertEventData;
- (void)addInfoWithDict:(NSDictionary *)info;
- (void)deleteFileWithName:(NSString *)fileName;

- (void)addEventData:(EventAlertTableViewCellData *)eventData;
- (void)addEventDataWithAlertEventData:(AlertEventData *)alertEventData;


- (EventAlertTableViewCellData *)getEventDataWithFileName:(NSString *)fileName;


@end
