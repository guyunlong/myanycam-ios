//
//  ImageBrowserNavigationController.h
//  Myanycam
//
//  Created by myanycam on 13-4-27.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventAlertTableViewCellData.h"
#import "ImageBrowserViewController.h"



@interface ImageBrowserNavigationController : UINavigationController
{
    id <EGOPhotoSource> _photoSource;
    NSInteger   _currentIndex;
    PhotoBrowseType   _imageBrowserType;//0:拍照相册浏览；  1:报警照片查看
    id<ImageBrowserDeleteImageDelegate> _deleteImageDelegate;
}

@property (assign, nonatomic) id<ImageBrowserDeleteImageDelegate> deleteImageDelegate;
@property (assign, nonatomic) PhotoBrowseType  imageBrowserType;
@property(nonatomic,readonly) id <EGOPhotoSource> photoSource;
@property (retain, nonatomic) EventAlertTableViewCellData  * currentCellData;
@property (retain, nonatomic) CameraInfoData * cameraInfo;
- (id)initWithPhotoSource:(id <EGOPhotoSource> )aPhotoSource currentIndex:(int)index imageBrowserType:(PhotoBrowseType)aImageBrowserType;
@end

