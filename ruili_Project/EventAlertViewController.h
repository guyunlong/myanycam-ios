//
//  EventAlertViewController.h
//  Myanycam
//
//  Created by myanycam on 13-4-29.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "BaseViewController.h"
#import "AlertPictureListData.h"
#import "RecordListData.h"
#import "PictureDownloadUrlData.h"
#import "EventAlertPictureDelegate.h"
#import "EventAlertViewDelegate.h"
#import "AlertandRecordVideoDelegate.h"
#import "VideoDownloadUrlData.h"
#import "EventRecordViewCell.h"
#import "AlertImageUrlEngine.h"



@interface EventAlertViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,EventAlertViewDelegate,EventAlertPictureDelegate,EventAlertTableViewCellDelegate,AsyncSocketDelegate,AlertandRecordVideoDelegate,AHAlertViewDelegate,EventRecordViewDelegate,BaseAlertViewDelegate,AlertImageUrlEngineDelegate,UIAlertViewDelegate>
{
    NSInteger _currentPage;
    
    //数据部分
    NSMutableArray *_alertArray;
    NSMutableArray *_recordArray;
    
    //页面展示部分
    UITableView *   _alertTableView;
    UITableView *   _recordTableView;
    NSInteger       _tableViewType;//0:报警图片 1:录像
    NSInteger       _watchPictureOrVideo;//0:报警图片 1:录像
    
    BOOL _flagLocalOrProxy;//YES local , NO:proxy
    NSInteger _flagCheckIP;//-1:初始 0:local 不同 1:local 同
    NSMutableArray * _myPhotoSource;
    
    NSInteger _alertCurrentPos;
    NSInteger _recordCurrentPos;
    AsyncSocket * _checkSocket;
    BOOL      _flagDownFile;
    BOOL      _flagRequestAlertDataing;
    
    EventRecordViewCell * _currentRecordCell;
}

@property (retain, nonatomic) AsyncSocket * checkSocket;
@property (assign, nonatomic) NSInteger alertCurrentPos;
@property (assign, nonatomic) NSInteger recordCurrentPos;

@property (retain, nonatomic) PictureDownloadUrlData * alertPicture;
@property (retain, nonatomic) VideoDownloadUrlData * videoUrlData;

@property (retain, nonatomic) EventAlertTableViewCellData  * currentCellData;
@property (retain, nonatomic) NSIndexPath  * currentIndex;


@property (retain, nonatomic) NSMutableArray * myPhotoSource;
@property (retain, nonatomic) UITableView *  alertTableView;
@property (retain, nonatomic) UITableView *  recordTableView;
@property (retain, nonatomic) CameraInfoData    * cameraInfo;
@property (retain, nonatomic) AlertPictureListData    * alertEventData;
@property (retain, nonatomic) RecordListData          * recordListData;
@property (retain, nonatomic) MyPhotoSource           * photoSource;
@property (retain, nonatomic) NSMutableArray    * sectionArray;

@property (retain, nonatomic) NSArray    * dataArray;
@property (retain, nonatomic) NSMutableArray    * alertArray;
@property (retain, nonatomic) NSMutableArray    * recordArray;

//@property (retain, nonatomic) IBOutlet UITableView *alertEventTableView;
@property (retain, nonatomic) IBOutlet UINavigationBar *topNavigationBar;
@property (retain, nonatomic) IBOutlet UINavigationItem *topNavigationBarItem;

@property (retain, nonatomic) IBOutlet UIButton *alertRecordTabButton;
@property (retain, nonatomic) IBOutlet UIButton *recordTabButton;
@property (retain, nonatomic) IBOutlet UIImageView *topTabBackImageView;
@property (retain, nonatomic) IBOutlet UIImageView *slidingImageView;
@property (retain, nonatomic) IBOutlet UIScrollView *slidingScrollView;
@property (retain, nonatomic) IBOutlet UILabel *alarmLabel;
@property (retain, nonatomic) IBOutlet UILabel *recordLabel;
@property (retain, nonatomic) IBOutlet UIView *eventButtonView;
@property (retain, nonatomic) IBOutlet UIView *recordButtonView;
@property (retain, nonatomic) IBOutlet UIView *buttonBackView;
@property (retain, nonatomic) IBOutlet UILabel *noAlertPictureOrVideoTipLabel;

- (IBAction)alertRecordTabButtonAction:(id)sender;
- (IBAction)recordTabButtonAction:(id)sender;


@end
