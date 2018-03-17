//
//  EventAlertTableViewCellData.h
//  Myanycam
//
//  Created by myanycam on 13/6/15.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventAlertTableViewCellData : NSObject

@property (retain, nonatomic) NSString * eventTime;
@property (retain, nonatomic) NSString * formatEventTime;
@property (retain, nonatomic) NSString * recordTime;
@property (retain, nonatomic) NSString * fileName;
@property (retain, nonatomic) NSString * videoFileName;
@property (assign, nonatomic)  enum AlertEventType alertType;
@property (assign, nonatomic) long indexTime;
//@property (assign, nonatomic) enum RecordType recordType;
@property (assign, nonatomic) NSInteger flagRecord;

- (id)initWithString:(NSString *)pFileName;

@end
