//
//  CameraDeviceData.h
//  Myanycam
//
//  Created by myanycam on 13-5-16.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CameraDeviceData : NSObject

@property (retain, nonatomic) NSString  * sn;
@property (retain, nonatomic) NSString  * timezone;
@property (retain, nonatomic) NSString  * producter;
@property (retain, nonatomic) NSString  * mode;
@property (retain, nonatomic) NSString  * password;



- (id)initWithInfo:(NSDictionary *)info;

@end
