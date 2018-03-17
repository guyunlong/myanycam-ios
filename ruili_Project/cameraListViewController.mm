//
//  cameraListViewController.m
//  myanycam
//
//  Created by 中程 on 13-1-13.
//  Copyright (c) 2013年 中程. All rights reserved.
//

#import "cameraListViewController.h"
#import "dealWithCommend.h"
#import "cameraAddViewController.h"
#import "navButton.h"
#import "navTitleLabel.h"
#import "AppDelegate.h"
#import "AlertAQGridViewCell.h"
#import "MYDataManager.h"
#import "SystemSetViewController.h"
#import "AlertImageAlertView.h"
#import "UINavigationItem+UINavigationItemTitle.h"
#import "CallingAlertView.h"
#import "QRCodeReader.h"
#import "MYZXingController.h"
#import "WifiSettingViewController.h"


#ifndef ZXQR
#define ZXQR 1
#endif

#if ZXQR
#import "QRCodeReader.h"
#endif

#ifndef ZXAZ
#define ZXAZ 0
#endif

#if ZXAZ
#import "AztecReader.h"
#endif

@interface cameraListViewController ()

@end

@implementation cameraListViewController

@synthesize cameraListTable=_cameraListTable;
@synthesize cameraListArray;
@synthesize cameraListNavBar=_cameraListNavBar;
@synthesize cameraListNacItem=_cameraListNacItem;
@synthesize currentCameraInfo;
@synthesize fakeCameraData;

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationDeleteCameraSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationCameraInfoAlertEvent object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationShowChangePasswordAlert object:nil];

    [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.checkCameraPwdDelegate = nil;

    [_cameraListTable release];
    [_cameraListNavBar release];
    [_cameraListNacItem release];
    
    self.currentCameraInfo = nil; 
    self.cameraListArray = nil;
    self.fakeCameraData = nil;
    [_cameraGridview release];
    [_addCameraTipLabel release];
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

- (void)prepareData{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteCameraSuccess) name:kNotificationDeleteCameraSuccess object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertEventAlertView:) name:kNotificationCameraInfoAlertEvent object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showChangePasswordAlertView) name:KNotificationShowChangePasswordAlert object:nil];

    
    [self prepareFakeCameraData];
    [ToolClass deleteFileWithPath:[[MYDataManager shareManager] getFilePathAtDocument:@"downloadtemp"]];
    [[MYDataManager shareManager] prepareDataAfterLogin];

}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ([self.cameraListArray count] == 0) {
        
        [[AppDelegate getAppDelegate] mygcdSocketEngine].dealObject.carmeraListDelegate=self;
        [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.checkCameraPwdDelegate = self;
        [[AppDelegate getAppDelegate].mygcdSocketEngine sendGetMcuRequest];
        [[AppDelegate getAppDelegate].mygcdSocketEngine sendGetCameraListRequest];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareData];
    
    UIBarButtonItem * editButton = [ViewToolClass customBarButtonItem:@"icon_Gear.png"
                                                   buttonSelectImage:@"icon_Gear_hover.png"
                                                               title:nil
                                                                size:CGSizeMake(32, 32)
                                                              target:self
                                                              action:@selector(settingAction:)];
    
    _cameraListNacItem.rightBarButtonItem = editButton;
    
    
    UIBarButtonItem * addButton = [ViewToolClass customBarButtonItem:@"icon_Plus.png"
                                                    buttonSelectImage:@"icon_Plus_hover.png"
                                                                title:nil
                                                                 size:CGSizeMake(32, 32)
                                                               target:self
                                                               action:@selector(addCameraAction:)];
    
    _cameraListNacItem.leftBarButtonItem = addButton;

    [self.cameraListNacItem setCustomTitle:NSLocalizedString(@"Camera List", nil)];
    self.addCameraTipLabel.text = NSLocalizedString(@"Please add camera", nil);
    
    // grid view sits on top of the background image
    
    
    if ([ToolClass systemVersionFloat] >= 7.0) {
        
        CGRect fr = self.cameraListNavBar.frame;
        fr.size.height = 64;
        self.cameraListNavBar.frame = fr;
        
        fr = [UIScreen mainScreen].bounds;
        fr.origin.y = 64;
        fr.size.height = fr.size.height - 64 - 10;
        self.cameraGridview.frame = fr;
    }
    else
    {
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.origin.x = 0;
        frame.origin.y = 46;
        frame.size.height = frame.size.height - 46 - 10;
        self.cameraGridview.frame = frame;
    }
    
    [_cameraListNavBar setBackgroundImage:[[UIImage imageNamed:@"topBar.png"] resizableImage] forBarMetrics:UIBarMetricsDefault];

    
//    self.cameraGridview.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.cameraGridview.backgroundColor = [UIColor clearColor];
    self.cameraGridview.opaque = NO;

    [self.cameraGridview setRequiresSelection:YES];
    
    if ( UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) )
    {
        // bring 1024 in to 1020 to make a width divisible by five
        self.cameraGridview.leftContentInset = 2.0;
        self.cameraGridview.rightContentInset = 2.0;
    }
    
    UILongPressGestureRecognizer *lpgr = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongPressGestureRecognizer:)] autorelease];
    [self.cameraGridview addGestureRecognizer:lpgr];
    
    UITapGestureRecognizer *tapGestureTel2 = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TwoPressGestureRecognizer:)]autorelease];
    [tapGestureTel2 setNumberOfTapsRequired:2];
    [tapGestureTel2 setNumberOfTouchesRequired:1];
    [self.cameraGridview addGestureRecognizer:tapGestureTel2];
    
    [self.cameraGridview reloadData];

}

- (void)LongPressGestureRecognizer:(UIGestureRecognizer *)gr
{
    if (gr.state == UIGestureRecognizerStateBegan)
    {
        if (m_bTransform) {
            
            m_bTransform = NO;
            [MYDataManager shareManager].flagNeedToWobble = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCellNeedWobble object:nil];
        }
        else{
            
            m_bTransform = YES;
            [MYDataManager shareManager].flagNeedToWobble = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCellNeedWobble object:nil];
        }

    }
}

-(void)TwoPressGestureRecognizer:(UIGestureRecognizer *)gr
{
    if(m_bTransform==NO)
        return;
    m_bTransform = NO;
    [MYDataManager shareManager].flagNeedToWobble = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCellNeedWobble object:nil];
}

- (void)prepareFakeCameraData{
    
    CameraInfoData * data = [[CameraInfoData alloc] init];
    data.status = -1;
    self.fakeCameraData = data;
    [data release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCameraListTable:nil];
    [self setCameraListNavBar:nil];
    [self setCameraListNacItem:nil];
    [self setCameraGridview:nil];
    [self setAddCameraTipLabel:nil];
    [super viewDidUnload];
}

- (void)deleteCamera:(NSInteger)index{
    
    CameraInfoData * camaera = [self.cameraListArray objectAtIndex:index];
    [[AppDelegate getAppDelegate].mygcdSocketEngine sendDeleteCameraRequestWithCameraId:camaera.cameraId];
}

- (void)deleteCameraSuccess{
    
    [[MYDataManager shareManager] deleteCameraWithCameraId:self.currentCameraInfo.cameraId];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self updateTableViewInMainThread];
    });
    
}

//<cameraid=223><cmd=CALL_MASTER><time=1379838752>
- (void)calling:(NSMutableDictionary *)info{
    
    CameraInfoData * data = [[MYDataManager shareManager] getCameraInfoWithCameraId:[[info objectForKey:@"cameraid"] intValue]];
    if (data && data.status != 0) {
        
        CallingAlertView * alertView = nil;
        NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"CallingAlertView" owner:nil options:nil];
        if ([views count] > 0) {
            
            alertView = [views lastObject];
            alertView.baseDelegate = self;
            alertView.userInfo = [NSDictionary dictionaryWithObject:data forKey:@"CallingData"];
            alertView.frame = [UIScreen mainScreen].bounds;
            [alertView prepareData:data];
        }
        
        [alertView show];
        
    }
}

#pragma mark cameraListDelegate
-(void)cameraListInfo:(NSMutableDictionary *)info
{

    if ([info objectForKey:@"count"] && [[info objectForKey:@"count"] intValue] == 0 ) {
        
        self.addCameraTipLabel.hidden = NO;
    }
    else
    {
        [[MYDataManager shareManager] cameraListInfo:info];
        self.addCameraTipLabel.hidden = YES;
    }
    
    [self performSelectorOnMainThread:@selector(updateTableViewInMainThread) withObject:nil waitUntilDone:nil];

}

- (void)cameraStateInfo:(NSMutableDictionary *)info{
    
    [[MYDataManager shareManager] cameraStateInfoUpdate:info];
    
    NSInteger type = [[[MYDataManager shareManager].apnsDict objectForKey:@"type"] intValue];
    
    if (type == 2) {
        
        NSInteger cameraid = [[[MYDataManager shareManager].apnsDict objectForKey:@"cameraid"] intValue];
        CameraInfoData * data = [[MYDataManager shareManager] getCameraInfoWithCameraId:cameraid];
        if (cameraid == [[info objectForKey:@"cameraid"] intValue] && type == 2 && data && data.status == 1) {
            
            [self goToCameraView:data];
        }
    }

    [self performSelectorOnMainThread:@selector(updateGridView) withObject:nil waitUntilDone:nil];
}

- (void)updateTableViewInMainThread{
    
    NSArray * array = [[[MYDataManager shareManager].cameraListDiction allValues] sortedArrayUsingDescriptors:
                       [NSArray arrayWithObjects:
                        [NSSortDescriptor sortDescriptorWithKey:@"cameraId" ascending:YES],
                        nil]];
    
    self.cameraListArray = [NSMutableArray arrayWithArray:array];
//    [self.cameraListArray addObject:self.fakeCameraData];
    [self.cameraGridview reloadData];
}

- (void)updateGridView{

    [self.cameraGridview reloadData];
}


- (void)settingAction:(id)sender {
    
    SystemSetViewController * viewController = [[SystemSetViewController alloc] init];
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self customPresentModalViewController:viewController animated:YES];
    [viewController release];
    
}

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView{
    
    return [self.cameraListArray count];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ([alertView isKindOfClass:[MYAlertView class]]) {
        
        MYAlertView * alert = (MYAlertView *)alertView;
        CameraInfoData * data = [alert.userInfo objectForKey:@"DeleteCamera"];
        if (data&&buttonIndex == 0) {
            
            [[AppDelegate getAppDelegate].mygcdSocketEngine sendDeleteCameraRequestWithCameraId:data.cameraId];
        }
        
    }
}


- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index{
    
    static NSString * CellIdentifier = @"CellIdentifier";
    
    AlertAQGridViewCell * cell = nil;//(AlertAQGridViewCell *)[gridView dequeueReusableCellWithIdentifier: CellIdentifier];
    if ( cell == nil )
    {
        cell = [[[AlertAQGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 320, 221) reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
    }
    
//    DebugLog(@" cell.index %d",index);
    CameraInfoData * cameraData = [self.cameraListArray objectAtIndex:index];
    cell.cameraData = cameraData;
    return ( cell );
}

// all cells are placed in a logical 'grid cell', all of which are the same size. The default size is 96x128 (portrait).
// The width/height values returned by this function will be rounded UP to the nearest denominator of the screen width.
- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) gridView{
    
    return CGSizeMake(320, 221);
}

- (void)goToCameraView:(CameraInfoData *)data{
    
    if (data.status != 0)//
    {
        self.currentCameraInfo = data;
        [AppDelegate getAppDelegate].window.bottomBarView.cameraData = data;
        [MYDataManager shareManager].currentCameraData = data;

        cameraViewViewController *controller=[[cameraViewViewController alloc] initWithNibName:@"cameraViewViewController" bundle:nil info:data];
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        controller.flagNeedAutoP2p = YES;
        controller.flagIsCallign = YES;
        [self customPresentModalViewController:controller animated:YES];
        [controller release];
        
    }
}

- (void)showAlertImageView:(CameraInfoData *)cameraInfo fileName:(NSString *)fileName{
    
    
        AlertImageAlertView * alertView = nil;
        NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"AlertImageAlertView" owner:nil options:nil];
        if ([views count] > 0) {
            alertView = [views lastObject];
            alertView.frame = [UIScreen mainScreen].bounds;
        }
        
        [alertView prepareData:cameraInfo alertPictureName:fileName];
        [alertView show];
    
}

- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index{
    
    if (index > [self.cameraListArray count]) {
        
        return;
    }
    
    CameraInfoData * data = [self.cameraListArray objectAtIndex:index];
    self.currentCameraInfo = data;
    [AppDelegate getAppDelegate].window.bottomBarView.cameraData = data;

    
    if (data.status == -1) {
        
        [self addCameraAction:nil];
        return;
    }
    
    if ([MYDataManager shareManager].flagNeedToWobble) {
        
        NSString * tip = NSLocalizedString(@"delete camera", nil);
        NSString * msg = [NSString stringWithFormat:@"%@: %@",tip,data.cameraName];
        
        NSDictionary * userInfo = [NSDictionary dictionaryWithObject:data forKey:@"DeleteCamera"];
        
        [self showAlertView:nil
                   alertMsg:msg
                   userInfo:userInfo
                   delegate:self
             canclButtonStr:NSLocalizedString(@"OK", nil)
          otherButtonTitles:NSLocalizedString(@"Cancel", nil)];
        
        return;
    }
    
    if (data.status == CameraStateOffline )//
    {

        [self showAlertView:@"" alertMsg:NSLocalizedString(@"Camera is offline", nil) userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        return;
    }
    
    if (data.status == CameraStateUpdate )//
    {
        
        [self showAlertView:@"" alertMsg:NSLocalizedString(@"Camera is upgrade", nil) userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        return;
    }
    
    
    RootViewController * controller = [[RootViewController alloc] init];
    controller.cameraData = data;
    [AppDelegate getAppDelegate].window.myRootViewController = controller;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self customPresentModalViewController:controller animated:YES];
    [controller release];
    
    [MYDataManager shareManager].currentCameraData = data;
    
}

- (void)showChangePasswordAlertView{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self showChangePwdAlertView];
        [[AppDelegate getAppDelegate].window.myRootViewController dismisscurrentViewController];
        [[AppDelegate getAppDelegate].window.myRootViewController customDismissModalViewControllerAnimated:NO];
        
    });
}

- (void)checkCameraPasswordRespond:(NSDictionary *)data{
    
    if ([[data objectForKey:@"ret"] intValue] != 0) {
        
          [self showChangePasswordAlertView];
    }
    else
    {
        NSString * accesskey = [data objectForKey:@"accesskey"];
        NSString * password = [data objectForKey:@"sharepwd"];
        
        if (accesskey) {
            
           self.currentCameraInfo.accesskey = accesskey;
        }
        
        if (password) {
            
            self.currentCameraInfo.sharePassword = password;
        }
        
        if ([data objectForKey:@"shareswitch"]) {
            
            self.currentCameraInfo.shareswitch = [[data objectForKey:@"shareswitch"] boolValue];
        }
        
        if ([data objectForKey:@"upnp"]) {
            
            self.currentCameraInfo.flagUpnp_success = [[data objectForKey:@"upnp"] intValue];
        }
        
        if ([data objectForKey:@"natip"]) {
            
            self.currentCameraInfo.cameraNatip = [data objectForKey:@"natip"];
        }
        
        self.currentCameraInfo.flagUserProvenResp = YES;
        
    }
    
}

- (void)showChangePwdAlertView{
    
    ChangePasswordAlertView * alertView = nil;
    
    NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"ChangePasswordAlertView" owner:nil options:nil];
    if ([views count] > 0) {
        
        alertView = [views lastObject];
        alertView.baseDelegate = self;
        alertView.cameraInfo = self.currentCameraInfo;
        alertView.tag = AlertViewTypeQuestion;
        alertView.frame = [UIScreen mainScreen].bounds;
        [alertView show];
        
    }
    
}


- (void)alertView:(id)alertView clickButtonAtIndex:(NSInteger)index{
    

    BaseAlertView * alert = (BaseAlertView *)alertView;
    CameraInfoData * data = nil;
    if (index == BaseAlertViewButtonTypeCancel) {
        
        if ((data = [alert.userInfo objectForKey:@"CallingData"])) {

            [[AppDelegate getAppDelegate].mygcdSocketEngine sendCallingRsp:[MYDataManager shareManager].userInfoData.userId cameraid:data.cameraId ret:1];
        }
        else
        {
            [[AppDelegate getAppDelegate].window jumpToRootViewControllerWithOutAnimation];

        }
        
    }
    
    if (index == BaseAlertViewButtonTypeOK) {
        
        //一件通话

        if ((data = [alert.userInfo objectForKey:@"CallingData"])) {
            
            if (data) {
                
                if ([AppDelegate getAppDelegate].window.myRootViewController) {
                    
                    [[AppDelegate getAppDelegate].window jumpToRootViewControllerWithOutAnimation];
                    [[AppDelegate getAppDelegate].window.myRootViewController dismisscurrentViewController];
                    [AppDelegate getAppDelegate].cameraPlayView = nil;
                    
                    [[AppDelegate getAppDelegate].window.myRootViewController customDismissModalViewControllerAnimated:NO];
                    [AppDelegate getAppDelegate].window.myRootViewController = nil;
                    
                }
                else
                {
                    [[AppDelegate getAppDelegate].cameraPlayView customDismissModalViewControllerAnimated:NO];
                    [AppDelegate getAppDelegate].cameraPlayView = nil;
                }
                
                [[AppDelegate getAppDelegate].mygcdSocketEngine sendCallingRsp:[MYDataManager shareManager].userInfoData.userId cameraid:data.cameraId ret:0];
                
                self.currentCameraInfo = data;
                [self goToCameraView:data];
            }
        }
    }
    
}


- (void)alertEventAlertView:(NSNotification *)sender{
    
    NSDictionary * dict = sender.userInfo;
    NSInteger type = [[dict objectForKey:@"type"] intValue];
    if (type == AlertTypeLow_Power)
    {
        
        NSString * tip = NSLocalizedString(@"Camera‘s battery is low!", nil);
        
        if ([AppDelegate getAppDelegate].apModelOrCloudModel) {
            
            tip = NSLocalizedString(@"Camera‘s battery is low!", nil);
        }
        else
        {
            CameraInfoData * cameraData = [[MYDataManager shareManager] getCameraInfoWithCameraId:[[dict objectForKey:@"cameraid"] intValue]];
            tip = [NSString stringWithFormat:tip,cameraData.cameraName];
        }
        
        [self showAutoDismissAlertView:tip];
        
    }
}

- (void)zxingController:(ZXingWidgetController *)controller didScanResult:(NSString *)result{
    NSLog(@"%@",result);
    
    NSArray * resultArray = [result componentsSeparatedByString:@"#"];
    
    
    NSString * cameraSn = nil;
    NSString * cameraPassword = nil;
    NSString * cameraName = nil;
    
    if ([resultArray count] >1) {
        
        cameraSn = [[resultArray objectAtIndex:0] uppercaseString];
        cameraPassword = [resultArray objectAtIndex:1];
        cameraName = [NSString stringWithFormat:@"Myanycam_%@",[cameraSn substringWithRange:NSMakeRange([cameraSn length]- 1,1)]];
    }
    
    [self showAddCameraViewController:cameraSn password:cameraPassword name:cameraName controller:controller];

    
//    if ([ToolClass systemVersionFloat] >= 5.0) {
//        
//        [controller dismissViewControllerAnimated:YES completion:^{
//            
//        }];
//    }
//    else {
//        
//        [controller dismissModalViewControllerAnimated:NO];
//        
//        [self showAddCameraViewController:cameraSn password:cameraPassword name:cameraName controller:controller];
//
//    }
    

}

- (void)showAddCameraViewController:(NSString *)sn password:(NSString *)password name:(NSString *)name controller:(UIViewController *)controller{
    
    cameraAddViewController *cameraAddVC=[[cameraAddViewController alloc] init];
    cameraAddVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    cameraAddVC.cameraSnStr = sn;
    cameraAddVC.cameraPwd = password;
    cameraAddVC.cameraName = name;
    
    if (controller ) {
        
        if ([ToolClass systemVersionFloat] >= 5.0) {
            
            [controller presentViewController:cameraAddVC animated:NO completion:^{
                
            }];
        }
        else {
            
            [controller presentModalViewController:cameraAddVC animated:NO];
        }
    }
    
    [cameraAddVC release];
}

- (void)zixngCongrollerManuallyAdd:(ZXingWidgetController*)controller{
    
    [self showAddCameraViewController:nil password:nil name:nil controller:controller];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController *)controller{
    
    if ([ToolClass systemVersionFloat] >= 5.0) {
        
        [controller dismissViewControllerAnimated:YES completion:^{
            
//            [self showAddCameraViewController:nil password:nil name:nil ];

        }];
    }
    else {
        [controller dismissModalViewControllerAnimated:YES];
        
//        [self showAddCameraViewController:nil password:nil name:nil];

    }
}

- (IBAction)addCameraAction:(id)sender {
    
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
//        [self showAlertView:nil alertMsg:NSLocalizedString(@"Your Device Without Camera", nil) userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
//        
//        return;
         [self showAddCameraViewController:nil password:nil name:nil controller:self];
    }
    else
    {
        MYZXingController *widController = [[MYZXingController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
        widController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        NSMutableSet *readers = [[NSMutableSet alloc ] init];
        
#if ZXQR
        QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
        [readers addObject:qrcodeReader];
        [qrcodeReader release];
#endif
        
#if ZXAZ
        AztecReader *aztecReader = [[AztecReader alloc] init];
        [readers addObject:aztecReader];
        [aztecReader release];
#endif
        
        widController.readers = readers;
        [readers release];
        
        NSBundle *mainBundle = [NSBundle mainBundle];
        widController.soundToPlay =  [NSURL fileURLWithPath:[mainBundle pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];
        [self customPresentModalViewController:widController animated:YES];
        [widController release];
    }
    

    
}


@end
