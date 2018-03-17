//
//  CameraGridImageDownload.h
//  Myanycam
//
//  Created by myanycam on 13/10/25.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CameraGridImageDownload : NSObject<AsyncSocketDelegate>
{
    
    BOOL _checkStateing;
}

@property (retain, nonatomic) AsyncSocket * checkSocket;
@property (retain, nonatomic) CameraInfoData       * cameraInfo;


@end
