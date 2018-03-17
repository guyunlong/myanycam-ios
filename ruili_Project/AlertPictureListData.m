//
//  AlertPictureListData.m
//  Myanycam
//
//  Created by myanycam on 13-5-22.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "AlertPictureListData.h"
#import "MYDataManager.h"

@implementation AlertPictureListData

@synthesize userid;
@synthesize cameraId;
@synthesize pos;
@synthesize count;
@synthesize total;
@synthesize fileDict;
@synthesize alertImageSourceArray;


- (void)dealloc{
    
    self.fileDict = nil;
    self.alertImageSourceArray = nil;
    [super dealloc];
}

- (id)initWithInfo:(NSDictionary *)info{
    
    self = [super init];
    if (self) {
        
        self.userid = [[info objectForKey:@"userid"] intValue];
        self.cameraId = [[info objectForKey:@"cameraid"] intValue];
        self.pos = [[info objectForKey:@"pos"] intValue];
        self.count = [[info objectForKey:@"count"] intValue];
        self.total = [[info objectForKey:@"total"] intValue];
        
        self.fileDict = [NSMutableDictionary dictionaryWithCapacity:20];
        self.alertImageSourceArray = [NSMutableArray arrayWithCapacity:10];

        NSString * fileStr = @"file%d";
        
        for (int i = 1; i <= self.count; i ++) {
            
            NSString * file = [NSString stringWithFormat:fileStr,i];
            NSString * fileName = [info objectForKey:file];
            if (fileName) {
                
                EventAlertTableViewCellData * data = [[EventAlertTableViewCellData alloc] initWithString:fileName];
                [self.fileDict setObject:data forKey:fileName];
                [data release];
                
                NSString * imagePath = [[MYDataManager shareManager].haveDownloadImageFile objectForKey:fileName];
                if (!imagePath)
                {
                    imagePath = @"";
                }
                
                MyPhoto *photo = [[MyPhoto alloc] initWithImageURL:[NSURL fileURLWithPath:imagePath] name:fileName];
                photo.proxyName = fileName;
                photo.cellData = data;
                
                [self.alertImageSourceArray addObject:photo];
                [photo release];
                
            }
        }
    }
    
    return self;
}

- (id)initDataWithAlertEvent:(AlertEventData *)alertEventData{
    
    self = [super init];
    if (self) {
        
        self.userid = alertEventData.userid;
        self.cameraId = alertEventData.cameraid;
        self.pos = 0;
        self.count = 1;
        
        self.fileDict = [NSMutableDictionary dictionaryWithCapacity:20];
        self.alertImageSourceArray = [NSMutableArray arrayWithCapacity:10];

        
            NSString * fileName = alertEventData.pitureFileName;
            if (fileName) {
                
                [self.fileDict setObject:alertEventData.alertData forKey:fileName];
                
                NSString * imageCameraIdName = [NSString stringWithFormat:@"%d_%@",self.cameraId,fileName];
                NSString * imagePath = [[MYDataManager shareManager].haveDownloadImageFile objectForKey:imageCameraIdName];
                if (!imagePath)
                {
                    imagePath = @"";
                }
                
                MyPhoto *photo = [[MyPhoto alloc] initWithImageURL:[NSURL fileURLWithPath:imagePath] name:fileName];
                photo.proxyName = fileName;
                photo.cellData = alertEventData.alertData;
                [self.alertImageSourceArray addObject:photo];
            
                
                [photo release];
            }
        
    }
    
    return self;
}

- (void)addEventDataWithAlertEventData:(AlertEventData *)alertEventData{
    
    self.pos = self.pos + 1;
    self.count = self.count + 1;
    NSString * fileName = alertEventData.pitureFileName;
    if (fileName) {
        [self.fileDict setObject:alertEventData.alertData forKey:fileName];
        
        NSString * imageCameraIdName = [NSString stringWithFormat:@"%d_%@",self.cameraId,fileName];
        NSString * imagePath = [[MYDataManager shareManager].haveDownloadImageFile objectForKey:imageCameraIdName];
        if (!imagePath)
        {
            imagePath = @"";
        }
        
        MyPhoto *photo = [[MyPhoto alloc] initWithImageURL:[NSURL fileURLWithPath:imagePath] name:fileName];
        photo.proxyName = fileName;
        photo.cellData = alertEventData.alertData;
        [self.alertImageSourceArray addObject:photo];
        
 
        [photo release];
    }
    
}

- (void)addInfoWithDict:(NSDictionary *)info{
    
    self.pos = [[info objectForKey:@"pos"] intValue];
    self.total = [[info objectForKey:@"total"] intValue];
    self.count = self.count  + [[info objectForKey:@"count"] intValue];
    
    NSString * fileStr = @"file%d";
    NSInteger count1 =  [[info objectForKey:@"count"] intValue];
    for (int i = 1; i <= count1; i ++) {
        
        NSString * file = [NSString stringWithFormat:fileStr,i];
        NSString * fileName = [info objectForKey:file];
        EventAlertTableViewCellData * data = [[EventAlertTableViewCellData alloc] initWithString:fileName];
        [self.fileDict setObject:data forKey:fileName];
        [data release];
        
        
        NSString * imageCameraIdName = [NSString stringWithFormat:@"%d_%@",self.cameraId,fileName];
        NSString * imagePath = [[MYDataManager shareManager].haveDownloadImageFile objectForKey:imageCameraIdName];
        if (!imagePath)
        {
            imagePath = @"";
        }
        
        MyPhoto *photo = [[MyPhoto alloc] initWithImageURL:[NSURL fileURLWithPath:imagePath] name:fileName];
        photo.proxyName = fileName;
        photo.cellData = data;

        [self.alertImageSourceArray addObject:photo];

        [photo release];
        
    }
}

- (void)deleteFileWithName:(NSString *)fileName{
    
    [self.fileDict removeObjectForKey:fileName];
    for (MyPhoto  * photo in self.alertImageSourceArray) {
        
        if ([photo.proxyName isEqualToString:fileName]) {
            
            [self.alertImageSourceArray removeObject:photo];
            break;
        }
    }
}

- (void)addEventData:(EventAlertTableViewCellData *)eventData{
    
    NSString * fileName = eventData.fileName;
    [self.fileDict setObject:eventData forKey:fileName];
    
    
    NSString * imageCameraIdName = [NSString stringWithFormat:@"%d_%@",self.cameraId,fileName];
    NSString * imagePath = [[MYDataManager shareManager].haveDownloadImageFile objectForKey:imageCameraIdName];
    if (!imagePath)
    {
        imagePath = @"";
    }
    
    MyPhoto *photo = [[MyPhoto alloc] initWithImageURL:[NSURL fileURLWithPath:imagePath] name:fileName];
    photo.proxyName = fileName;
    photo.cellData = eventData;
    
    [self.alertImageSourceArray addObject:photo];
    [photo release];
}

- (EventAlertTableViewCellData *)getEventDataWithFileName:(NSString *)fileName{
    
    EventAlertTableViewCellData * data = [self.fileDict objectForKey:fileName];
    return data;
}

@end
