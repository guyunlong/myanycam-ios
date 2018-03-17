//
//  ImageBrowserViewController.h
//  Myanycam
//
//  Created by myanycam on 13-4-27.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "EGOPhotoViewController.h"
#import "EventAlertTableViewCellData.h"

@protocol ImageBrowserDeleteImageDelegate;

@interface ImageBrowserViewController : EGOPhotoViewController<UIActionSheetDelegate>

{
    id<ImageBrowserDeleteImageDelegate> _deleteImageDelegate;
}

@property (assign, nonatomic) id<ImageBrowserDeleteImageDelegate> deleteImageDelegate;
@property (assign, nonatomic) NSInteger currentIndex;
@property (retain, nonatomic) EventAlertTableViewCellData  * currentCellData;
@property (retain, nonatomic) CameraInfoData * cameraInfo;
@property (retain, nonatomic) ALAssetsLibrary *alaSsetsLibrary;

- (void)goBackAction:(id)sender;
@end



@protocol ImageBrowserDeleteImageDelegate <NSObject>

- (void)deleteImageWithIndex:(NSInteger)imageIndex;

@end