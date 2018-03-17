//
//  PhotosGridViewController.h
//  myanycam
//
//  Created by 中程 on 13-1-31.
//  Copyright (c) 2013年 中程. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import "ImageBrowserNavigationController.h"




@interface MYImageName : NSObject

@property (retain, nonatomic) NSString * imageName;
@property (retain, nonatomic) NSString * imagePath;
@property (retain, nonatomic) NSURL    * imageUrl;
@property (retain, nonatomic) NSDate *date;

@end

@interface PhotosGridViewController : BaseViewController<AQGridViewDataSource,AQGridViewDelegate,ImageBrowserDeleteImageDelegate>
{
    int _currentSelectCellIndex;
}

@property (assign, nonatomic) int listType;//0 image 1 video
@property (retain, nonatomic) IBOutlet UINavigationBar *fileListNavBar;
@property (retain, nonatomic) IBOutlet UINavigationItem *fileListNavItem;
@property (retain, nonatomic) IBOutlet UIButton *imageListBtn;
@property (retain, nonatomic) IBOutlet UIButton *videoListBtn;
@property (retain, nonatomic) IBOutlet AQGridView *fileGridView;


@property (retain, nonatomic) NSArray * dataArray;
@property (retain, nonatomic) IBOutlet UILabel *noPhotosTipLabel;

- (IBAction)imagesButton:(id)sender;
- (IBAction)videoButton:(id)sender;

@end
