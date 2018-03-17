//
//  RecordListData.m
//  Myanycam
//
//  Created by myanycam on 13-5-22.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "RecordListData.h"

@implementation RecordListData

@synthesize userid;
@synthesize cameraId;
@synthesize pos;
@synthesize count;
@synthesize fileDict;


- (void)dealloc{
    
    self.fileDict = nil;
    [super dealloc];
}

- (id)initWithInfo:(NSDictionary *)info{
    
    self = [super init];
    
    if (self) {
        
        self.userid = [[info objectForKey:@"userid"] intValue];
        self.cameraId = [[info objectForKey:@"cameraid"] intValue];
        self.pos = [[info objectForKey:@"pos"] intValue];
        self.count = [[info objectForKey:@"count"] intValue];
        
        self.fileDict = [NSMutableDictionary dictionaryWithCapacity:20];
        
        NSString * fileStr = @"file%d";
        
        for (int i = 1; i <= self.count; i ++) {
            
            NSString * file = [NSString stringWithFormat:fileStr,i];
            NSString * fileName = [info objectForKey:file];
            
            EventAlertTableViewCellData * data = [[EventAlertTableViewCellData alloc] initWithString:fileName];
            [self.fileDict setObject:data forKey:fileName];
            [data release];
            
        }
        
    }
    
    return self;
}

- (void)addInfoWithDict:(NSDictionary *)info{
    
    self.pos = [[info objectForKey:@"pos"] intValue];
    self.count = self.count  + [[info objectForKey:@"count"] intValue];
    
    NSString * fileStr = @"file%d";
    
    NSInteger count1 =  [[info objectForKey:@"count"] intValue];
    
    for (int i = 1; i <= count1; i ++) {
        
        NSString * file = [NSString stringWithFormat:fileStr,i];
        NSString * fileName = [info objectForKey:file];
        
        if (fileName) {
            
            EventAlertTableViewCellData * data = [[EventAlertTableViewCellData alloc] initWithString:fileName];
            [self.fileDict setObject:data forKey:fileName];
            [data release];
        }
    }
}


- (void)deleteFileWithName:(NSString *)fileName{
    
    [self.fileDict removeObjectForKey:fileName];
}

- (EventAlertTableViewCellData * )cellDataWithFileName:(NSString *)fileName{
    
    return [self.fileDict objectForKey:fileName];
}

- (void)addEventData:(EventAlertTableViewCellData *)eventData{
    
    NSString * fileName = eventData.fileName;
    [self.fileDict setObject:eventData forKey:fileName];
    
}

@end
