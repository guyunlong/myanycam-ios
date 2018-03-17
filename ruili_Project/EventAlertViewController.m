//
//  EventAlertViewController.m
//  Myanycam
//
//  Created by myanycam on 13-4-29.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "EventAlertViewController.h"
#import "EventAlertPictureViewController.h"
#import "AlertandRecordVideoViewController.h"
#import "EventAlertTableViewCell.h"
#import "EventRecordViewCell.h"
#import "AppDelegate.h"
#import "VideoPlayerViewController.h"
#import "ImageBrowserNavigationController.h"
#import "SVPullToRefresh.h"
#import "WaitLogoAnimationView.h"
#import "AlertEventData.h"
#import "UINavigationItem+UINavigationItemTitle.h"
#import "VideoDownLoadAlertView.h"

@interface EventAlertViewController ()

@end

@implementation EventAlertViewController
@synthesize sectionArray;
@synthesize dataArray;
@synthesize cameraInfo;
@synthesize alertEventData;
@synthesize recordListData;
@synthesize alertTableView = _alertTableView;
@synthesize recordTableView = _recordTableView;
@synthesize alertArray = _alertArray;
@synthesize recordArray = _recordArray;
@synthesize myPhotoSource;
@synthesize currentCellData;
@synthesize currentIndex;
@synthesize alertCurrentPos;
@synthesize recordCurrentPos;
@synthesize checkSocket = _checkSocket;
@synthesize photoSource;

- (void)dealloc {
    
    [MYDataManager shareManager].flagNeedToUpdateEventState = YES;
    [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.eventAlertdelegate = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationDeletePictureSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationDeleteVideoSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationCameraInfoAlertEvent object:nil];
    
    self.checkSocket = nil;
    self.currentIndex = nil;
    self.currentCellData = nil;
    self.alertPicture = nil;
    self.myPhotoSource = nil;
    self.dataArray = nil;
    self.sectionArray = nil;
    self.alertArray = nil;
    self.recordArray = nil;
    self.cameraInfo =nil;
    self.alertTableView = nil;
    self.recordTableView = nil;
    self.alertCurrentPos = nil;
    self.recordCurrentPos = nil;
    self.photoSource = nil;
    
    [_topNavigationBar release];
    [_topNavigationBarItem release];
    [_alertRecordTabButton release];
    [_recordTabButton release];
    [_topTabBackImageView release];
    [_slidingImageView release];
    [_slidingScrollView release];
    [_alarmLabel release];
    [_recordLabel release];
    [_eventButtonView release];
    [_recordButtonView release];
    [_buttonBackView release];
    [_noAlertPictureOrVideoTipLabel release];
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"EventAlertViewController"];
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
     [self.slidingScrollView setContentOffset:CGPointMake( w*_tableViewType, 0)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    [self.slidingScrollView setContentOffset:CGPointMake( w*_tableViewType, 0)];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"EventAlertViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isShowBottomBar = YES;
    _flagCheckIP = -1;
    [MYDataManager shareManager].flagNeedToUpdateEventState = NO;
    [[MYDataManager shareManager].alertNumberDict removeObjectForKey:[NSNumber numberWithInt:self.cameraInfo.cameraId]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCameraInfoAlertEvent object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletePictureSuccess:) name:kNotificationDeletePictureSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteVideoSuccess:) name:kNotificationDeleteVideoSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAlertEventUpdataView) name:kNotificationCameraInfoAlertEvent object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadAlertListData) name:KNotificationDownAlertImage object:nil];
    
    if (![AppDelegate getAppDelegate].apModelOrCloudModel) {
        
        NSString * imageNormalStr = @"icon_Return.png";
        NSString * imageSelectStr = @"icon_Return_hover.png";
        UIBarButtonItem *backButton = [ViewToolClass customBarButtonItem:imageNormalStr buttonSelectImage:imageSelectStr title:NSLocalizedString(@"", nil) size:CGSizeMake(32, 32) target:self  action:@selector(goToBack)];
        self.topNavigationBarItem.leftBarButtonItem = backButton;
    }

    
    if ([ToolClass systemVersionFloat] >= 7.0 ) {
        
        CGRect fr = self.topNavigationBar.frame;
        fr.size.height = 64;
        self.topNavigationBar.frame = fr;
        
        fr = self.buttonBackView.frame;
        fr.origin.y = 64;
        self.buttonBackView.frame = fr;
        
        fr = self.slidingScrollView.frame;
        fr.origin.y = 64 + 48 + 1;
        self.slidingScrollView.frame = fr;
    }
    
    [self.topNavigationBar setBackgroundImage:[[UIImage imageNamed:@"topBar.png"] resizableImage] forBarMetrics:UIBarMetricsDefault];
    [self.topNavigationBarItem setCustomTitle:NSLocalizedString(@"Event", nil)];
    
    
    [self initAlarmData];
    
    self.alertRecordTabButton.highlighted = YES;
//    [self.alertRecordTabButton setShowsTouchWhenHighlighted:YES];
//    [self.recordTabButton setShowsTouchWhenHighlighted:YES];
    self.myPhotoSource = [NSMutableArray arrayWithCapacity:1];
    
    self.alarmLabel.text = NSLocalizedString(@"Picture", nil);
    self.recordLabel.text = NSLocalizedString(@"Record", nil);
    
    self.noAlertPictureOrVideoTipLabel.text = @"";
    self.noAlertPictureOrVideoTipLabel.hidden = YES;
    
    [self initScrollView];
    
    if (!self.checkSocket) {
        
        AsyncSocket * socket = [[AsyncSocket alloc] initWithDelegate:self];
        self.checkSocket = socket;
        [socket release];
    }
    
//    CGRect buttonFrame = self.alertRecordTabButton.frame;
//    buttonFrame.size.width = [UIScreen mainScreen].bounds.size.width/2;
//    self.alertRecordTabButton.frame = buttonFrame;
//    
//    buttonFrame.origin.x = buttonFrame.size.width;
//    self.recordTabButton.frame = buttonFrame;
//    
//    self.eventButtonView.center = self.alertRecordTabButton.center;
//    self.recordButtonView.center = self.recordTabButton.center;
//    self.slidingImageView.frame = CGRectMake(0, 45, [UIScreen mainScreen].bounds.size.width/2, 3);

}

- (void)initAlarmData{
    
    [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.eventAlertdelegate = self;
    AlertPictureListData * data = nil;
    
//    [[MYDataManager shareManager] getAlertEventListDataWithCameraID:self.cameraInfo.cameraId];
    
    if (!data )
    {
        
        if (self.cameraInfo.status != 0) {
            
            [[AppDelegate getAppDelegate].mygcdSocketEngine sendGetAlertListRequest:[MYDataManager shareManager].userInfoData.userId
                                                                 cameraid:self.cameraInfo.cameraId
                                                                      pos:0 waitView:YES];
        }
        
    }
    else{
        
        self.alertArray = [NSMutableArray arrayWithArray:[data.fileDict allValues]];
        [self.alertArray sortUsingDescriptors:[NSArray arrayWithObjects:
                                               [NSSortDescriptor sortDescriptorWithKey:@"indexTime" ascending:NO],
                                               nil]];
        self.alertCurrentPos = data.count;
    }
    
    
}

- (void)initRecordData{
    
    RecordListData * recordData = [[MYDataManager shareManager] getRecordDataWithCameraId:self.cameraInfo.cameraId];
    
    if (!recordData ) {
        
        if (self.cameraInfo.status != 0) {
            
            [[AppDelegate getAppDelegate].mygcdSocketEngine sendGetRecordList:self.cameraInfo.cameraId
                                                                pos:0 waitView:YES];
        }
    }
    else{
        
        self.recordArray = [NSMutableArray arrayWithArray:[recordData.fileDict allValues]];
        [self.recordArray sortUsingDescriptors:[NSArray arrayWithObjects:
                                                [NSSortDescriptor sortDescriptorWithKey:@"indexTime" ascending:NO],
                                                nil]];
        self.recordCurrentPos = recordData.count;
        [self.recordTableView reloadData];

    }
}

- (void)refresh:(id)sender {
    
    if (self.cameraInfo.status == 0) {
        
        return;
    }
    
    if (_tableViewType == 0) {
        
        [[AppDelegate getAppDelegate].mygcdSocketEngine sendGetAlertListRequest:[MYDataManager shareManager].userInfoData.userId
                                                             cameraid:self.cameraInfo.cameraId
                                                                  pos:0 waitView:YES];
        [[MYDataManager shareManager] deleteAlertEventDataFromDict:self.cameraInfo.cameraId];
        
    }
    else{
        
        [[AppDelegate getAppDelegate].mygcdSocketEngine sendGetRecordList:self.cameraInfo.cameraId
                                                            pos:0 waitView:YES];
        
        [[MYDataManager shareManager] deleteRecordDataFromDict:self.cameraInfo.cameraId];
    }
    
}

- (void)addAlertEventUpdataView{
    
    AlertEventData * data = [AppDelegate getAppDelegate].mygcdSocketEngine.alertEvent;
    
    if (data && data.pitureFileName && data.cameraid == self.cameraInfo.cameraId && self.cameraInfo.status != 0) {
        
        [[[MYDataManager shareManager] getAlertEventListDataWithCameraID:self.cameraInfo.cameraId] addEventData:data.alertData];
        
        if (self.alertArray == nil) {
            
            self.alertArray = [NSMutableArray arrayWithArray:[[[MYDataManager shareManager] getAlertEventListDataWithCameraID:self.cameraInfo.cameraId].fileDict allValues]];
            [self.alertArray sortUsingDescriptors:[NSArray arrayWithObjects:
                                                   [NSSortDescriptor sortDescriptorWithKey:@"indexTime" ascending:NO],
                                                   nil]];
        }
        else{
            
            [self.alertArray insertObject:data.alertData atIndex:0];
        }
        
        
        NSArray * array = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self.alertTableView beginUpdates];
        [self.alertTableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
        [self.alertTableView endUpdates];

        
    }
    
}

- (void)refreshData{
            
    self.alertArray = [NSMutableArray arrayWithArray:[[[MYDataManager shareManager] getAlertEventListDataWithCameraID:self.cameraInfo.cameraId].fileDict allValues]];
    [self.alertArray sortUsingDescriptors:[NSArray arrayWithObjects:
                                           [NSSortDescriptor sortDescriptorWithKey:@"indexTime" ascending:NO],
                                           nil]];

    self.recordArray = [NSMutableArray arrayWithArray:[[[MYDataManager shareManager] getRecordDataWithCameraId:self.cameraInfo.cameraId].fileDict allValues]];
    [self.recordArray sortUsingDescriptors:[NSArray arrayWithObjects:
                                            [NSSortDescriptor sortDescriptorWithKey:@"indexTime" ascending:NO],
                                            nil]];
}

- (void)downloadAlertListData{
    
    if (self.alertCurrentPos %20 ==0 && [[AppDelegate getAppDelegate].mygcdSocketEngine isConnect] && !_flagRequestAlertDataing) {
        
        _flagRequestAlertDataing = YES;
        [[AppDelegate getAppDelegate].mygcdSocketEngine sendGetAlertListRequest:[MYDataManager shareManager].userInfoData.userId
                                                                       cameraid:self.cameraInfo.cameraId
                                                                            pos:self.alertCurrentPos waitView:YES];
    }
    else{
        
        [self.alertTableView.infiniteScrollingView stopAnimating];
    }

}

- (void)downloadRecordListData{
    
    if (self.recordCurrentPos %20 ==0 && [[AppDelegate getAppDelegate].mygcdSocketEngine isConnect]) {
        
       [[AppDelegate getAppDelegate].mygcdSocketEngine sendGetRecordList:self.cameraInfo.cameraId
                                                           pos:self.recordCurrentPos waitView:NO];
    }
    else{
        
        [self.recordTableView.infiniteScrollingView stopAnimating];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (tableView == self.alertTableView) {
//        
//        return 64;
//    }
    
    return 64 ;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.alertTableView) {
        
        return [self.alertArray count];
        
    }
    else{
        return [self.recordArray count];
        
    }
    
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (tableView == self.alertTableView) {
            
            EventAlertTableViewCellData * cellData = [self.alertArray objectAtIndex:indexPath.row];
            [self deletePictureWithFileName:cellData.fileName];
            
            
            [self.alertArray removeObjectAtIndex:indexPath.row];
            
        }
        else{

            EventAlertTableViewCellData * cellData = [self.recordArray objectAtIndex:indexPath.row];
            [self deleteVideoWithFileName:cellData.fileName];
            [self.recordArray removeObjectAtIndex:indexPath.row];
            
        }
        
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.currentIndex = indexPath;
    
    if(tableView == self.alertTableView){
        
//        [self sendAlertPictureRequest:[self.alertArray objectAtIndex:indexPath.row]];
        [self goToBrowserPictureWithIndex:indexPath.row];
    }
    else{
        
//        [self sendRecordRequest:[self.recordArray objectAtIndex:indexPath.row]];
        [self goToWatchVideoWithCameraInfo:self.cameraInfo EventCellData:[self.recordArray objectAtIndex:indexPath.row]];
        
    }
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellStyle = @"alertCell";
    static NSString * recordStyle = @"recordStyle";

    if (tableView == self.alertTableView) {
        
        EventAlertTableViewCell * cell = nil;
        
         cell = [tableView dequeueReusableCellWithIdentifier:cellStyle];
        if (!cell) {
            
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"EventAlertTableViewCell" owner:nil options:nil];
            
            if ([array count]) {
                
                cell = [array lastObject];
                UIImageView * view = [[[UIImageView alloc] init] autorelease];
                [view setBackgroundColor:[UIColor clearColor]];
                cell.accessoryView = view;
                
            }
        }

        cell.delegate = self;
        cell.cellData= [self.alertArray objectAtIndex:indexPath.row];
        cell.cameraid = self.cameraInfo.cameraId;
        
        
        return cell;
    }
    else{
        
        EventRecordViewCell * cell = nil;
        
        cell = [tableView dequeueReusableCellWithIdentifier:recordStyle];
        
        if (!cell) {
            
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"EventRecordViewCell" owner:nil options:nil];
            
            if ([array count]) {
                
                cell = [array lastObject];
                UIImageView * view = [[[UIImageView alloc] init] autorelease];
                [view setBackgroundColor:[UIColor clearColor]];
                cell.accessoryView = view;
            }
        }
        cell.delegate = self;
        cell.cameraInfo = self.cameraInfo;
        cell.cellData = [self.recordArray objectAtIndex:indexPath.row];
        return cell;
    }
    
    return nil;
}

- (void)checkDownloadData{
    
    if (self.alertCurrentPos % 20 != 0) {
        
        self.alertTableView.showsInfiniteScrolling = NO;
    }
    else
    {
        self.alertTableView.showsInfiniteScrolling = YES;
    }
    
    
    if (self.recordCurrentPos % 20 != 0) {
        
        self.recordTableView.showsInfiniteScrolling = NO;
    }
    else
    {
        self.recordTableView.showsInfiniteScrolling = YES;
    }
    
}

- (void)getEventAlertPictureRsp:(NSDictionary *)info{
    
    
    [self.alertTableView.infiniteScrollingView stopAnimating];
    [self.alertTableView.pullToRefreshView stopAnimating];
    
    [[MYDataManager shareManager] updateAlertEventFileListWithDict:info];
    self.alertCurrentPos = [[MYDataManager shareManager] getAlertEventListDataWithCameraID:self.cameraInfo.cameraId].count;
    
    [self checkDownloadData];
    
    self.alertArray = [NSMutableArray arrayWithArray:[[[MYDataManager shareManager] getAlertEventListDataWithCameraID:self.cameraInfo.cameraId].fileDict allValues]];
    
    [self.alertArray sortUsingDescriptors:[NSArray arrayWithObjects:
                                            [NSSortDescriptor sortDescriptorWithKey:@"indexTime" ascending:NO],
                                            nil]];
    [self.alertTableView reloadData];
    
    if (self.photoSource) {
        
        [self.photoSource updatePhotosWithArray:[[MYDataManager shareManager] getAlertEventListDataWithCameraID:self.cameraInfo.cameraId].alertImageSourceArray];
        DebugLog(@"self.photoSource count %d",[self.photoSource numberOfPhotos]);
    }
    
    _flagRequestAlertDataing = NO;
    
   [self updateTipText];
    
}


- (void)getRecordFileNameRsp:(NSDictionary *)info{
    
     [self.recordTableView.infiniteScrollingView stopAnimating];
    [self.recordTableView.pullToRefreshView stopAnimating];
    
    [[MYDataManager shareManager] updateRecordFileListWithDict:info];
    
    self.recordCurrentPos = [[MYDataManager shareManager] getRecordDataWithCameraId:self.cameraInfo.cameraId].count;
    
    [self checkDownloadData];
    self.recordArray = [NSMutableArray arrayWithArray:[[[MYDataManager shareManager] getRecordDataWithCameraId:self.cameraInfo.cameraId].fileDict allValues]];
    
    [self.recordArray sortUsingDescriptors:[NSArray arrayWithObjects:
                                                [NSSortDescriptor sortDescriptorWithKey:@"indexTime" ascending:NO],
                                                nil]];
    
    [self.recordTableView reloadData];
    
    
    [self updateTipText];

}

- (void)getPictureDownloadUrlRsp:(NSDictionary *)dat{
    
    [[AppDelegate getAppDelegate].window hideWaitAlertView];
    PictureDownloadUrlData * data = [[PictureDownloadUrlData alloc] initWithDictInfo:dat];
    self.alertPicture = data;
    [data release];
    
    if (_flagCheckIP == -1) {
        
        [self.checkSocket connectToHost:self.alertPicture.localUrlIp onPort:self.alertPicture.localPort withTimeout:2 error:nil];
    }
    else
    {
        if (_flagCheckIP == 0) {
            
            [self goToAlertOrRecordViewControllerByProxyurl];
        }
        else
        {
            [self goToAlarmOrRecordViewControllerBylocalurl];
        }
    }
    
}

- (void)getAlertandRecordVideoUrl:(NSDictionary *)dat{
    
    VideoDownloadUrlData * data = [[VideoDownloadUrlData alloc] initWithDictInfo:dat];
    self.videoUrlData = data;
    [data release];
    
    
    if (_flagCheckIP == -1) {
        
        [self.checkSocket connectToHost:self.videoUrlData.localUrlIp onPort:self.videoUrlData.localPort withTimeout:2 error:nil];
    }
    else
    {
        if (_flagCheckIP == 0) {
            
            [self goToAlertOrRecordViewControllerByProxyurl];
        }
        else
        {
            [self goToAlarmOrRecordViewControllerBylocalurl];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setTopNavigationBar:nil];
    [self setTopNavigationBarItem:nil];
    [self setAlertRecordTabButton:nil];
    [self setRecordTabButton:nil];
    [self setTopTabBackImageView:nil];
    [self setSlidingImageView:nil];
    [self setSlidingScrollView:nil];
    [self setAlarmLabel:nil];
    [self setRecordLabel:nil];
    [self setEventButtonView:nil];
    [self setRecordButtonView:nil];
    [self setButtonBackView:nil];
    [self setNoAlertPictureOrVideoTipLabel:nil];
    [super viewDidUnload];
}

- (void) btnActionShow
{
    if (_currentPage == 0) {
        
        [self alertRecordTabButtonAction:nil];
    }
    else{
        [self recordTabButtonAction:nil];
    }
}

- (IBAction)alertRecordTabButtonAction:(id)sender {
    
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationDuration:0.2];
    
//    self.slidingImageView.frame = CGRectMake(0, 45, [UIScreen mainScreen].bounds.size.width/2, 3);
    [self.slidingScrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width*0, 0)];//页面滑动
    _tableViewType = 0;
    
    self.recordTabButton.highlighted = NO;
    [self keepOnlyButtonHighlight:self.alertRecordTabButton];
    
    [UIView commitAnimations];

    [self updateTipText];
}

- (void)updateTipText{
    
    if (_tableViewType == 0) {
        
        AlertPictureListData * data = [[MYDataManager shareManager] getAlertEventListDataWithCameraID:self.cameraInfo.cameraId];
        if (data.count == 0) {
            
            self.noAlertPictureOrVideoTipLabel.hidden = NO;
            self.noAlertPictureOrVideoTipLabel.text = NSLocalizedString(@"No Alarm Picture", nil);
        }
        else
        {
            self.noAlertPictureOrVideoTipLabel.hidden = YES;
        }
    }
    else
    {
        RecordListData * recordData = [[MYDataManager shareManager] getRecordDataWithCameraId:self.cameraInfo.cameraId];
        if (recordData.count == 0) {
            
            
            self.noAlertPictureOrVideoTipLabel.hidden = NO;
            self.noAlertPictureOrVideoTipLabel.text = NSLocalizedString(@"No Video", nil);
        }
        else
        {
            self.noAlertPictureOrVideoTipLabel.hidden = YES;
        }
    }
    
    

}

- (IBAction)recordTabButtonAction:(id)sender {
    
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationDuration:0.2];
    
//    self.slidingImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2, 45, [UIScreen mainScreen].bounds.size.width/2, 3);
    [self.slidingScrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width*1, 0)];
    _tableViewType = 1;
    
    [UIView commitAnimations];
    
    self.alertRecordTabButton.highlighted = NO;
    [self keepOnlyButtonHighlight:self.recordTabButton];
    
    [self initRecordData];
    
    [self updateTipText];

    
}

#pragma mark 左右滑动相关函数

- (void)initScrollView{
    
    
    //设置 tableScrollView
    // a page is the width of the scroll view
    CGRect frame = self.slidingScrollView.frame;
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    frame.size.height = [UIScreen mainScreen].bounds.size.height - 50 - 44 - 48 - 20;
    self.slidingScrollView.frame = frame;
    
    self.slidingScrollView.pagingEnabled = YES;
    self.slidingScrollView.clipsToBounds = NO;
    self.slidingScrollView.contentSize = CGSizeMake(self.slidingScrollView.frame.size.width * 2, self.slidingScrollView.frame.size.height);
    self.slidingScrollView.showsHorizontalScrollIndicator = NO;
    self.slidingScrollView.showsVerticalScrollIndicator = NO;
    self.slidingScrollView.scrollsToTop = NO;
    self.slidingScrollView.delegate = self;
    self.slidingScrollView.userInteractionEnabled = YES;
    self.slidingScrollView.scrollEnabled = NO;
    
    [self.slidingScrollView setContentOffset:CGPointMake(0, 0)];
    
    //公用
    _currentPage = 0;

    [self createAllEmptyPagesForScrollView];
}

- (void)createAllEmptyPagesForScrollView {

    CGRect viewFrame = [UIScreen mainScreen].bounds;
    
    //设置 tableScrollView 内部数据
    _alertTableView = [[UITableView alloc]init ];
    _alertTableView.backgroundColor = [UIColor clearColor];
    _alertTableView.frame = CGRectMake(viewFrame.size.width*0, 0, viewFrame.size.width, self.slidingScrollView.frame.size.height);
    _recordTableView = [[UITableView alloc]init ];
    _recordTableView.backgroundColor = [UIColor clearColor];
    _recordTableView.frame = CGRectMake(viewFrame.size.width*1, 0, viewFrame.size.width, self.slidingScrollView.frame.size.height);
    
    //设置tableView委托并添加进视图
    _alertTableView.delegate = self;
    _alertTableView.dataSource = self;
    [self.slidingScrollView addSubview: _alertTableView];
    _recordTableView.delegate = self;
    _recordTableView.dataSource = self;
    [self.slidingScrollView addSubview: _recordTableView];
    
    self.alertTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // setup pull-to-refresh
        
    [self.alertTableView addInfiniteScrollingWithActionHandler:^{
        [self downloadAlertListData];
    }];
    
    [self.alertTableView addPullToRefreshWithActionHandler:^{
        [self refresh:nil];
    }];

    
    WaitLogoAnimationView * imageView = [[WaitLogoAnimationView alloc] initWithFrame:CGRectMake(0, 0, viewFrame.size.width-20, 60)];
    [self.alertTableView.infiniteScrollingView setCustomView:imageView forState:SVInfiniteScrollingStateAll];
    [imageView release];

    // setup infinite scrolling
    [self.recordTableView addInfiniteScrollingWithActionHandler:^{
        [self downloadRecordListData];
    }];

    [self.recordTableView addPullToRefreshWithActionHandler:^{
        [self refresh:nil];
    }];

    imageView = [[WaitLogoAnimationView alloc] initWithFrame:CGRectMake(0, 0, viewFrame.size.width - 20, 60)];
    [self.recordTableView.infiniteScrollingView setCustomView:imageView forState:SVInfiniteScrollingStateAll];
    [imageView release];
    
    [self checkDownloadData];

 
}

- (void)goToBack{
    
    
    [self.alertTableView.infiniteScrollingView removeFromSuperview];
    self.alertTableView.infiniteScrollingView = nil;
    
    [self.alertTableView.pullToRefreshView removeFromSuperview];
    self.alertTableView.pullToRefreshView = nil;
   
    [self.recordTableView.infiniteScrollingView removeFromSuperview];
    self.recordTableView.infiniteScrollingView  = nil;
    
    DebugLog(@"self.recordTableView.pullToRefreshView.retainCount %d" ,[self.recordTableView.pullToRefreshView retainCount]);
   
    [self.recordTableView.pullToRefreshView removeFromSuperview];
    self.recordTableView.pullToRefreshView  = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRootControllerDismiss object:nil userInfo:nil];
    
//    [self customDismissModalViewControllerAnimated:NO];
    [[AppDelegate getAppDelegate].window jumpToRootViewControllerWithOutAnimation];

}

- (void)customDismissModalViewControllerAnimated:(BOOL)animated{
    
    [self.alertTableView.infiniteScrollingView removeFromSuperview];
    self.alertTableView.infiniteScrollingView = nil;
    
    [self.alertTableView.pullToRefreshView removeFromSuperview];
    self.alertTableView.pullToRefreshView = nil;
    
    [self.recordTableView.infiniteScrollingView removeFromSuperview];
    self.recordTableView.infiniteScrollingView  = nil;
    
    DebugLog(@"self.recordTableView.pullToRefreshView.retainCount %d" ,[self.recordTableView.pullToRefreshView retainCount]);
    
    [self.recordTableView.pullToRefreshView removeFromSuperview];
    self.recordTableView.pullToRefreshView  = nil;

    [super customDismissModalViewControllerAnimated:animated];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = self.slidingScrollView.frame.size.width;
    int page = floor((self.slidingScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    _currentPage = page;
//    [self btnActionShow];
}


- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    return YES;
}
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return NO;
}



- (void)sendAlertPictureRequest:(EventAlertTableViewCellData *)cellData{
    
    _watchPictureOrVideo = 0;
    self.currentCellData = cellData;

    [[MYDataManager shareManager].imageUrlEngine sendAlertPictureRequest:self.cameraInfo fileName:cellData.fileName delegate:self];
    
    [self ShowWaitAlertView:NSLocalizedString(@"Loading...", nil)];
    [MobClick event:@"APR"];

}

- (void)sendRecordRequest:(EventAlertTableViewCellData *)cellData{
    
    _watchPictureOrVideo = 1;
    self.currentCellData = cellData;
    
    [[MYDataManager shareManager].imageUrlEngine sendRecordRequest:self.cameraInfo fileName:cellData.videoFileName delegate:self];
    
    [self ShowWaitAlertView:NSLocalizedString(@"Loading...", nil)];
    [MobClick event:@"RVR"];

}

- (void)watchAlertImage:(EventAlertTableViewCellData *)cellData{
    
    [self sendAlertPictureRequest:cellData];
    
}

- (void)watchAlertVideo:(EventAlertTableViewCellData *)cellData{
    
    [self sendRecordRequest:cellData];
}

- (void)deletePictureWithFileName:(NSString *)fileName{
    
    [[AppDelegate getAppDelegate].mygcdSocketEngine sendDeletePictureFromCamera:self.cameraInfo fileName:fileName];
}

- (void)deleteVideoWithFileName:(NSString *)fileName{
    
    [[AppDelegate getAppDelegate].mygcdSocketEngine sendDeleteVideoFromCamera:self.cameraInfo fileName:fileName];
}

- (void)deletePictureSuccess:(NSNotification *)notify{
    
    DebugLog(@"notify %@",notify);
    NSDictionary * userInfo = notify.userInfo;
    
    AlertPictureListData * data = [[MYDataManager shareManager] getAlertEventListDataWithCameraID:self.cameraInfo.cameraId];
    data.total = data.total - 1;
    [data deleteFileWithName:[userInfo objectForKey:@"filename"]];
    
    [self refreshData];
    
    if (_tableViewType == 0) {
        
        [_alertTableView reloadData];
    }
    else
    {
        [_recordTableView reloadData];
    }
    

}

- (void)deleteVideoSuccess:(NSNotification *)notify{
    
    NSDictionary * userInfo = notify.userInfo;
    [[[MYDataManager shareManager] getRecordDataWithCameraId:self.cameraInfo.cameraId] deleteFileWithName:[userInfo objectForKey:@"filename"]];
    
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    
    DebugLog(@"_tableViewType %d",_tableViewType);
    
    _flagCheckIP = 1;
    
    [self goToAlarmOrRecordViewControllerBylocalurl];
    
    [sock disconnect];
}

- (void)goToAlarmOrRecordViewControllerBylocalurl{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (_watchPictureOrVideo == 0) {
            
            [self goToBrowserPicture:self.alertPicture.localUrl];
        }
        else
        {
            if (!_flagDownFile) {
                
                [self goToWatchRecord:self.videoUrlData.localUrl];
            }
            else
            {
                [self downloadVideo:self.videoUrlData.localUrl ];
            }
            
            _flagDownFile = NO;
        }
    });
}

- (void)downloadVideo:(NSString *)videoUrl{
    
    [self hideWaitAlertView];
    
    VideoDownLoadAlertView * alertView = nil;
    
    NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"VideoDownLoadAlertView" owner:nil options:nil];
    if ([views count] > 0) {
        alertView = [views lastObject];
        alertView.frame = [UIScreen mainScreen].bounds;
        alertView.baseDelegate = self;
    }
    
    [alertView show];
    [alertView downloadVideo:videoUrl cellData:self.currentCellData cameraInfo:self.cameraInfo];
    
}

- (void)goToAlertOrRecordViewControllerByProxyurl{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (_watchPictureOrVideo == 0) {
            
            if (self.alertPicture.proxyurl  && [self.alertPicture.proxyurl length] > 10) {
                
                [self goToBrowserPicture:self.alertPicture.proxyurl];
            }
            else{
                
                [[AppDelegate getAppDelegate].window hideWaitAlertView];
                
                [self showAlertView:@"Sorry" alertMsg:KUPNPErrorTip userInfo:nil delegate:self canclButtonStr:@"OK" otherButtonTitles:nil];
            }
            
        }
        else
        {
            if (self.videoUrlData.proxyurl  && [self.videoUrlData.proxyurl length] > 10) {
                
                
                if (!_flagDownFile) {
                    
                    [self goToWatchRecord:self.videoUrlData.proxyurl];
                }
                else
                {
                    [self downloadVideo:self.videoUrlData.proxyurl];
                }
                
                _flagDownFile = NO;
            }
            else{
                
                [[AppDelegate getAppDelegate].window hideWaitAlertView];
                
                [self showAlertView:@"Sorry" alertMsg:KUPNPErrorTip userInfo:nil delegate:self canclButtonStr:@"OK" otherButtonTitles:nil];
            }
            
        }
        
    });
  
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err{
    
    DebugLog(@"err %@",err);
    _flagCheckIP = 0;
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock{
    
    if (_flagCheckIP != 1) {
        
        [self goToAlertOrRecordViewControllerByProxyurl];
    }
    
}

- (void)goToBrowserPictureWithIndex:(NSInteger )index{
    
    MyPhotoSource *source = [[MyPhotoSource alloc] initWithPhotos:[[MYDataManager shareManager] getAlertEventListDataWithCameraID:self.cameraInfo.cameraId].alertImageSourceArray];
    ImageBrowserNavigationController * controller = [[ImageBrowserNavigationController alloc] initWithPhotoSource:source currentIndex:index imageBrowserType:PhotoBrowseTypeAlertPhoto];
    controller.currentCellData = self.currentCellData;
    controller.cameraInfo = self.cameraInfo;
    [self customPresentModalViewController:controller animated:NO];
    [controller release];
    self.photoSource = source;
    [source release];
}

- (void)goToWatchVideoWithCameraInfo:(CameraInfoData *)acameraInfo EventCellData:(EventAlertTableViewCellData *)data{
    
    VideoPlayerViewController * controller = [[VideoPlayerViewController alloc] init];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.cellData = data;
    controller.cameraInfo = acameraInfo;
    [self customPresentModalViewController:controller animated:NO];
    [controller release];
}

- (void)goToBrowserPicture:(NSString *)url{
    
    [self hideWaitAlertView];
    DebugLog(@"urlStr %@",url);
    
//    MyPhoto *photo = [[MyPhoto alloc] initWithImageURL:[NSURL URLWithString:url] name:self.currentCellData.fileName];
//    photo.imagePath = url;
//    [self.myPhotoSource addObject:photo];
//    [photo release];
    
//    MyPhotoSource *source = [[MyPhotoSource alloc] initWithPhotos:[NSArray arrayWithObject:photo]];
    
    MyPhotoSource *source = [[MyPhotoSource alloc] initWithPhotos:[[MYDataManager shareManager] getAlertEventListDataWithCameraID:self.cameraInfo.cameraId].alertImageSourceArray];
    ImageBrowserNavigationController * controller = [[ImageBrowserNavigationController alloc] initWithPhotoSource:source currentIndex:0 imageBrowserType:PhotoBrowseTypeAlertPhoto];
    controller.currentCellData = self.currentCellData;
    controller.cameraInfo = self.cameraInfo;
    [self customPresentModalViewController:controller animated:NO];
    [controller release];
    [source release];
}

- (void)goToWatchRecord:(NSString *)url{
    
    [self hideWaitAlertView];
    
    DebugLog(@"play record url %@",url);
    
    VideoPlayerViewController * controller = [[VideoPlayerViewController alloc] init];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.cellData = self.currentCellData;
    controller.cameraInfo = self.cameraInfo;
    controller.recordUrl = url;
    [self customPresentModalViewController:controller animated:NO];
    [controller release];
    
}

- (void)alertView:(AHAlertView *)alertView otherButtonIndex:(NSInteger)buttonIndex{
    
    EventAlertTableViewCellData *cellData  = (EventAlertTableViewCellData *)([alertView.userInfo objectForKey:@"delete-download"]);
    EventRecordViewCell * cell = (EventRecordViewCell *)([alertView.userInfo objectForKey:@"cell"]);
    
    if (cellData && cell) {
        
        if (buttonIndex == 0) {
            
            _flagDownFile = YES;
            _currentRecordCell = cell;
//            [self sendRecordRequest:cellData];
            
            NSString * fileName = cellData.videoFileName;
            fileName = [NSString stringWithFormat:@"%@_%@",self.cameraInfo.cameraSn,fileName];
            [[MYDataManager shareManager] deleteDownloadFileName:fileName];
            
            //初始化Documents路径
//            NSString *  path = [[MYDataManager shareManager] getFilePathAtDocument:Kdownloadvideos];
            NSString *  path = [[MYDataManager shareManager] getVideoFilePath:Kdownloadvideos];
            NSString *  downloadPath = [path stringByAppendingPathComponent:fileName];
            [ToolClass deleteFileWithPath:downloadPath];
            
            [self.recordTableView reloadData];
            
        }

    }

}

- (void)cancelButtonAction:(NSDictionary *)info{
    
    [self hideWaitAlertView];
}

- (void)downLoadFile:(EventAlertTableViewCellData *)cellData cell:(EventRecordViewCell *)cell{
    
    NSString * fileName = cellData.videoFileName;
    fileName = [NSString stringWithFormat:@"%@_%@",self.cameraInfo.cameraSn,fileName];
    if ([[MYDataManager shareManager] checkHaveDownloadVideoWithFileName:fileName]) {
        
        [self showAskAlertView:nil msg:NSLocalizedString(@"你已经下载了这个视频，要删除下载文件吗？", nil) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:cellData,@"delete-download", cell,@"cell",nil]];
        
        DebugLog(@"have download");
        return;
    }
    
    _flagDownFile = YES;
    _currentRecordCell = cell;
    [self sendRecordRequest:cellData];

}


- (void)alertView:(id)alertView clickButtonAtIndex:(NSInteger)index{
    
    [_currentRecordCell changeDownLoadButtonState];
    _currentRecordCell = nil;
    
}

- (void)alertImageOrRecordUrl:(NSString *)url type:(NSInteger)type{
    
    
//    dispatch_async(dispatch_get_main_queue(), ^{
    
    if (type == 1)//local
    {
        if (_watchPictureOrVideo == 0) {//照片
            
            [self goToBrowserPicture:url];
        }
        else
        {
            if (!_flagDownFile) {
                
                [self goToWatchRecord:url];//看录像
            }
            else
            {
                [self downloadVideo:url];//下载视频
            }
            
            _flagDownFile = NO;
        }
    }
    else//proxy
    {

        if (_watchPictureOrVideo == 0) {
            
            if (url  && [url length] > 10) {
                
                [self goToBrowserPicture:url];
            }
            else{
                
                [[AppDelegate getAppDelegate].window hideWaitAlertView];
                [self showAlertView:@"Sorry" alertMsg:KUPNPErrorTip userInfo:nil delegate:self canclButtonStr:@"OK" otherButtonTitles:nil];
            }
            
        }
        else
        {
            if (url  && [url length] > 10) {
                
                
                if (!_flagDownFile) {
                    
                    [self goToWatchRecord:url];
                }
                else
                {
                    [self downloadVideo:url];
                }
                
                _flagDownFile = NO;
            }
            else{
                
                [[AppDelegate getAppDelegate].window hideWaitAlertView];
                [self showAlertView:@"Sorry" alertMsg:KUPNPErrorTip userInfo:nil delegate:self canclButtonStr:@"OK" otherButtonTitles:nil];
            }
        }
    }
        
//    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
     [self hideWaitAlertView];
}

- (void)doHighlight:(UIButton*)b {
    
    [b setHighlighted:YES];
}

- (void)keepOnlyButtonHighlight:(id)sender{
    
    [self performSelector:@selector(doHighlight:) withObject:sender afterDelay:0];
    
}


@end
