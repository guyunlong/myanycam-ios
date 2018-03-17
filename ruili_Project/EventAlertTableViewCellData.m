

//
//  EventAlertTableViewCellData.m
//  Myanycam
//
//  Created by myanycam on 13/6/15.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "EventAlertTableViewCellData.h"

@implementation EventAlertTableViewCellData
@synthesize eventTime;
@synthesize recordTime;
@synthesize fileName;
@synthesize videoFileName;
@synthesize alertType;
@synthesize formatEventTime;
@synthesize indexTime;

- (void)dealloc{
    
    self.formatEventTime = nil;
    self.eventTime = nil;
    self.recordTime = nil;
    self.fileName = nil;
    self.videoFileName = nil;
    
    [super dealloc];
}

- (id)initWithString:(NSString *)pFileName{
    
    self = [super init];
    if (self) {
        
        self.fileName = pFileName;
        self.alertType = -1;
        //        self.recordType = -1;
        NSArray * array = [pFileName componentsSeparatedByString:@"_"];
        if ([array count] == 4) {//有图片 有录像的报警
            
            self.eventTime = [array objectAtIndex:0];
            self.alertType = [[array objectAtIndex:1] intValue];

            self.indexTime = [self.eventTime longLongValue];
            self.flagRecord = [[array objectAtIndex:2] intValue];
            //            self.recordType  = [[array objectAtIndex:3] intValue];
            self.recordTime  = [array objectAtIndex:3];
            
            NSArray * array2 = [self.recordTime componentsSeparatedByString:@"."];
            self.recordTime = [array2 objectAtIndex:0];
            self.videoFileName = [NSString stringWithFormat:@"%@.mp4",self.recordTime];
            
            NSMutableString * string = [NSMutableString stringWithString:self.eventTime];
            
            if ([string length] > 13) {
                
                [string insertString:@"-" atIndex:4];
                [string insertString:@"-" atIndex:7];
                [string insertString:@" " atIndex:10];
                [string insertString:@":" atIndex:13];
                [string insertString:@":" atIndex:16];
            }

            self.formatEventTime = string;
            
        }
        
        if ([array count] == 3) {//有图片 没有录像的报警
            
            self.eventTime = [array objectAtIndex:0];
            self.alertType = [[array objectAtIndex:1] intValue];
//            NSArray * array2 = [self.eventTime componentsSeparatedByString:@"."];
//            self.eventTime = [array2 objectAtIndex:0];
            self.indexTime = [self.eventTime longLongValue];
            
            NSMutableString * string = [NSMutableString stringWithString:self.eventTime];
            if ([string length] > 13) {
                
                [string insertString:@"-" atIndex:4];
                [string insertString:@"-" atIndex:7];
                [string insertString:@" " atIndex:10];
                [string insertString:@":" atIndex:13];
                [string insertString:@":" atIndex:16];
            }
  
            self.formatEventTime = string;
            
        }
        
        if ([array count] == 1) {//录像
            
            self.recordTime  = [array objectAtIndex:0];
            NSArray * array2 = [self.recordTime componentsSeparatedByString:@"."];
            self.recordTime = [array2 objectAtIndex:0];
            self.videoFileName = pFileName;
            
            self.indexTime = [self.recordTime longLongValue];
            
            if ([self.recordTime length] > 13) {
                
                NSMutableString * string = [NSMutableString stringWithString:self.recordTime];
                [string insertString:@"-" atIndex:4];
                [string insertString:@"-" atIndex:7];
                [string insertString:@" " atIndex:10];
                [string insertString:@":" atIndex:13];
                [string insertString:@":" atIndex:16];
                self.formatEventTime = string;
            }
        }
        
    }
    
    return self;
}

@end
