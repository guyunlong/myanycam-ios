//
//  MediaData.h
//  Myanycam
//
//  Created by myanycam on 13-4-22.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaData : NSObject{
    
    struct MediaDataHeader * _header;
    NSData                 * _mediaData;
}

@property (assign, nonatomic) struct MediaDataHeader * header;
@property (retain, nonatomic) NSData    *mediaData;
@property (assign, nonatomic) unsigned long time;

@end