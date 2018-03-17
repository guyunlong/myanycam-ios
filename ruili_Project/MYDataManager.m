//
//  MYDataManager.m
//  Myanycam
//
//  Created by myanycam on 13-3-11.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//



#import "MYDataManager.h"
#import "PhotosGridViewController.h"
#import "SFHFKeychainUtils.h"



static MYDataManager * _shareManager = nil;

@implementation MYDataManager
@synthesize alertSettingData = _alertSettingData;
@synthesize recordVideoSettingData = _recordVideoSettingData;
@synthesize pcmDataArray = _pcmDataArray;
@synthesize cmdType = _cmdType;
@synthesize currentVideoFrameTimeStamp = _currentVideoFrameTimeStamp;
@synthesize flagLoginSuccess = _flagLoginSuccess;
@synthesize imageFileArray;
@synthesize imageSourceArray;
@synthesize videoFileArray;
@synthesize cameraListArray;
@synthesize cameraListDiction;
@synthesize timezoneArray ;
@synthesize ethernetInfo;
@synthesize cameraDeviceInfo;
@synthesize alertEventListDataDict;
@synthesize recordListDataDict;
@synthesize flagLocalLogin = _flagLocalLogin;
@synthesize flagKickOff ;
@synthesize flagNeedToUpdateEventState = _flagNeedToUpdateEventState;
@synthesize currentCameraData;
@synthesize userInfoData;
@synthesize flagNeedToWobble;
@synthesize currentWifi;
@synthesize currnetWifiData;
@synthesize deviceTpye;
@synthesize myUdpSocket = _myUdpSocket;
@synthesize audioRecordEngine = _audioRecordEngine;
@synthesize downLoadQueue = _downLoadQueue;
@synthesize downloadVideoFileNameDic;
@synthesize apnsDict;
@synthesize apnsDataArray;
@synthesize haveDownloadVideoFile;
@synthesize imageUrlEngine = _imageUrlEngine;
@synthesize apnsAlertPictureDict;
@synthesize haveDownloadImageFile;
@synthesize currentVideoType;
//@synthesize tencentOAuth = _tencentOAuth;
@synthesize qqPermissions =  _qqPermissions;


- (void)dealloc{
    
    self.tencentOAuth = nil;
    self.qqPermissions = nil;
    
    self.haveDownloadImageFile = nil;
    self.userInfoData = nil;
    self.apnsAlertPictureDict = nil;
    self.downLoadQueue = nil;
    self.currentCameraData = nil;
    self.timezoneArray = nil;
    self.alertSettingData = nil;
    self.recordVideoSettingData = nil;

    self.pcmDataArray = nil;
    self.videoFileArray = nil;
    self.imageSourceArray = nil;
    self.imageFileArray = nil;
    self.cameraListArray = nil;
    self.cameraListDiction = nil;

    self.ethernetInfo = nil;
    self.cameraDeviceInfo = nil;
    self.recordListDataDict = nil;
    self.alertEventListDataDict = nil;
    self.alertNumberDict = nil;
    self.currentWifi = nil;
    self.currnetWifiData = nil;
    self.downloadVideoFileNameDic = nil;
    
    [self.myUdpSocket close];
    self.myUdpSocket = nil;
    
    self.apnsDataArray = nil;
    self.haveDownloadVideoFile = nil;
    
    self.imageUrlEngine = nil;
    
    [super dealloc];
    
}

#pragma mark - Singleton Methods
+ (MYDataManager *) shareManager{
    if (_shareManager == nil) {
        _shareManager = [[super allocWithZone:NULL] init];
        
    }
    return _shareManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self shareManager] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}
- (id)autorelease
{
    return self;
}
- (id)init{
    self = [super init];
    if (self) {
        [self prepareData];
    }
    return self;
}
/******************************/

- (void)prepareData{
    
//    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:KQQAppId andDelegate:self];
    
    self.userInfoData = [UserInfoData userInfoData];
    self.pcmDataArray = [NSMutableArray arrayWithCapacity:0];
    self.userInfoData.accountIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    self.userInfoData.loginType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"loginType"] intValue];
    self.userInfoData.passwordStr = [self getPassword:self.userInfoData.accountIdStr];
    self.flagNeedToUpdateEventState = YES;

    self.haveDownloadVideoFile = [NSMutableDictionary dictionaryWithContentsOfFile:[self getVideoFilePath:KDownlodVideoFile]];
    
    if (!self.haveDownloadVideoFile) {
        
        self.haveDownloadVideoFile = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    
    AlertImageUrlEngine * imageEngine = [[AlertImageUrlEngine alloc] init];
    self.imageUrlEngine = imageEngine;
    [imageEngine release];
    
    _downLoadQueue = [[ASINetworkQueue alloc] init];
    //   [queue reset];//重置
    [_downLoadQueue setShowAccurateProgress:YES];//高精度进度
    [_downLoadQueue go];//启动
    
    NSDictionary * cmdTypeNew =[[NSDictionary alloc] initWithObjectsAndKeys:
                                 [NSNumber numberWithInteger:1],@"GET_AGENT_ADDR_RESP",
                                 [NSNumber numberWithInteger:2],@"REGISTER_RESP",
                                 [NSNumber numberWithInteger:3],@"LOGIN_RESP",
                                 [NSNumber numberWithInteger:5],@"DOWNLOAD_CAMERA_RESP",
                                 [NSNumber numberWithInteger:6],@"CAMERA_STATUS",
                                 [NSNumber numberWithInteger:7],@"ADD_CAMERA_RESP",
                                 [NSNumber numberWithInteger:8],@"MODIFY_CAMERA_RESP",
                                 [NSNumber numberWithInteger:9],@"DELETE_CAMERA_RESP",
                                 [NSNumber numberWithInteger:10],@"MODIFY_PWD_RESP",
                                 [NSNumber numberWithInteger:11],@"GET_PWD_RESP",
                                 [NSNumber numberWithInteger:12],@"GET_MCU_RESP",
                                 [NSNumber numberWithInteger:13],@"WATCH_CAMERA_RESP",
                                 [NSNumber numberWithInteger:15],@"NETWORK_INFO",
                                 [NSNumber numberWithInteger:16],@"MODIFY_NETWORK_INFO_RESP",
                                 [NSNumber numberWithInteger:17],@"WIFI_INFO",
                                 [NSNumber numberWithInteger:18],@"HOT_SPOT",
                                 [NSNumber numberWithInteger:19],@"DEVICE_INFO",
                                 [NSNumber numberWithInteger:20],@"AUDIO_SWITCH_RESP",
                                 [NSNumber numberWithInteger:21],@"KICK_OFF",
                                 [NSNumber numberWithInteger:22],@"RECORD_CONFIG_INFO",
                                 [NSNumber numberWithInteger:23],@"RECORD_CONFIG_RESP",
                                 [NSNumber numberWithInteger:24],@"ALARM_CONFIG_INFO",
                                 [NSNumber numberWithInteger:25],@"ALARM_CONFIG_RESP",
                                 [NSNumber numberWithInteger:26],@"SET_WIFI_INFO_RESP",
                                 [NSNumber numberWithInteger:27],@"CONIFG_RESP",
                                 [NSNumber numberWithInteger:28],@"PICTURE_LIST_INFO",
                                 [NSNumber numberWithInteger:29],@"VIDEO_LIST_INFO",
                                 [NSNumber numberWithInteger:30],@"DOWNLOAD_PICTURE_RESP",
                                 [NSNumber numberWithInteger:31],@"DOWNLOAD_VIDEO_RESP",
                                 [NSNumber numberWithInteger:32],@"ALARM_EVENT",
                                 [NSNumber numberWithInteger:33],@"DELETE_PICTURE_RESP",
                                 [NSNumber numberWithInteger:34],@"DELETE_VIDEO_RESP",
                                 [NSNumber numberWithInteger:35],@"GET_LIVE_VIDEO_SIZE_QUALITY_RSP",
                                 [NSNumber numberWithInteger:36],@"GET_RECORD_VIDEO_SIZE_QUALITY_RSP",
                                 [NSNumber numberWithInteger:37],@"USER_PROVEN_RESP",
                                 [NSNumber numberWithInteger:38],@"CALL_MASTER",
                                 [NSNumber numberWithInteger:39],@"CALL_HANGUP",
                                 [NSNumber numberWithInteger:40],@"GET_CAMERA_VERSION_RESP",
                                 [NSNumber numberWithInteger:41],@"GET_CAMERA_SNAP_RESP",
                                 [NSNumber numberWithInteger:42],@"MANUAL_RECORD_RESP",
                                 [NSNumber numberWithInteger:43],@"MANUAL_SNAP_RESP",
                                 [NSNumber numberWithInteger:44],@"UPDATE_CAMERA_RESP",
                                 [NSNumber numberWithInteger:45],@"WATCH_CAMERA_TCP_RESP",
                                 [NSNumber numberWithInteger:46],@"SET_VIDEO_ROTATE_RESP",
                                 [NSNumber numberWithInteger:47],@"DEVICE_STATUS",
                                
                                 
                                 nil];
    self.cmdType = cmdTypeNew;
    [cmdTypeNew release];
    
    self.imageFileArray = [NSMutableArray arrayWithCapacity:10];
    self.imageSourceArray = [NSMutableArray arrayWithCapacity:10];
    self.videoFileArray = [NSMutableArray arrayWithCapacity:10];
    self.apnsDataArray = [NSMutableArray arrayWithCapacity:10];
    self.cameraListDiction = [NSMutableDictionary dictionaryWithCapacity:10];
    self.cameraListArray = [NSMutableArray arrayWithCapacity:10];
    
    self.alertEventListDataDict = [NSMutableDictionary dictionaryWithCapacity:10];
    self.recordListDataDict = [NSMutableDictionary dictionaryWithCapacity:10];
    self.alertNumberDict = [NSMutableDictionary dictionaryWithCapacity:10];
    self.apnsAlertPictureDict = [NSMutableDictionary dictionaryWithCapacity:10];

    

    CGRect frame = [UIScreen mainScreen].bounds;
        
    if (frame.size.width == 320) {
        
        if (frame.size.height == 480) {
            
            self.deviceTpye = DeviceTypeIphone;
        }
        else
        {
            self.deviceTpye = DeviceTypeIphone5;
        }
    }
    else
    {
        self.deviceTpye = DeviceTypeIpad1;
    }
    
}

- (void)resetData{
    
    [self.alertEventListDataDict removeAllObjects];
    [self.recordListDataDict removeAllObjects];
    [self.cameraListDiction removeAllObjects];
    [self.cameraListArray removeAllObjects];
//    [self.alertNumberDict removeAllObjects];
}

- (void)prepareDataAfterLogin{

//    self.haveDownloadVideoFile = [NSMutableDictionary dictionaryWithContentsOfFile:[self getFilePathAtUserIDPath:KDownlodVideoFile]];

    
    self.haveDownloadImageFile = [NSMutableDictionary dictionaryWithContentsOfFile:[self getFilePathAtUserIDPath:KHaveDownlodImageFile]];
    
    if (!self.haveDownloadImageFile) {
        self.haveDownloadImageFile = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    
    
    [self deleteImageCache];
    
}

- (void)addDownloadFileName:(NSString *)fileName{
    
    
    [self.haveDownloadVideoFile setObject:[NSNumber numberWithInt:1] forKey:fileName];
    [self.haveDownloadVideoFile writeToFile:[self getVideoFilePath:KDownlodVideoFile] atomically:YES];
//    [self.haveDownloadVideoFile writeToFile:[self getFilePathAtUserIDPath:KDownlodVideoFile] atomically:YES];

}

- (BOOL)checkHaveDownloadVideoWithFileName:(NSString *)fileName{
    
    if ([self.haveDownloadVideoFile objectForKey:fileName]) {
        
        return YES;
    }
    return NO;
}

- (void)deleteDownloadFileName:(NSString *)fileName{
    
    [self.haveDownloadVideoFile removeObjectForKey:fileName];
    [self.haveDownloadVideoFile writeToFile:[self getVideoFilePath:KDownlodVideoFile] atomically:YES];
    
}

- (void)updateRecordSetInfo:(NSDictionary *)info{
    
    RecordVideoSettingData * recordData = [[RecordVideoSettingData alloc] initWithDictionary:info];
    self.recordVideoSettingData = recordData;
    [recordData release];
}

- (void)updateAlertSetInfo:(NSDictionary *)info{
    
    AlertSettingData * settingData = [[AlertSettingData alloc] initWithDictInfo:info];
    self.alertSettingData = settingData;
    [settingData release];
}

- (void)updateEthernetInfo:(NSDictionary *)info{
    
    self.ethernetInfo = [[[EthernetInfoData alloc] initWithDictionary:info] autorelease];
}

- (void)updateCameraInfo:(NSDictionary *)info{
    
    self.cameraDeviceInfo = [[[CameraDeviceData alloc] initWithInfo:info] autorelease];
}

- (void)deleteImageCache{
    
    NSString *  path = [[MYDataManager shareManager] getFilePathAtDocument:KdownloadImage];
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
//    DebugLog(@"dirContents %@",dirContents);
    if ([dirContents count] > 500) {
        
        [[NSFileManager defaultManager]
         removeItemAtPath:path error:nil];
    }

}


-(void)getImgs{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        [self.imageFileArray removeAllObjects];
        [self.imageSourceArray removeAllObjects];
        
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
            
            NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
            
            if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
                NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
                
            }else{
                NSLog(@"相册访问失败.");
            }
        };
        
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result,NSUInteger index, BOOL *stop){
            if (result!=NULL) {
                
                if ([[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypePhoto]) {
                    
                    NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                    /*result.defaultRepresentation.fullScreenImage//图片的大图
                     result.thumbnail                            //图片的缩略图小图
                     //                    NSRange range1=[urlstr rangeOfString:@"id="];
                     //                    NSString *resultName=[urlstr substringFromIndex:range1.location+3];
                     //                    resultName=[resultName stringByReplacingOccurrencesOfString:@"&ext=" withString:@"."];//格式demo:123456.png
                     */
                    
                        MYImageName * imageName = [[MYImageName alloc] init];
                        imageName.imageName = urlstr;
                        imageName.imagePath = urlstr;
                        imageName.imageUrl =  [NSURL URLWithString:urlstr];
//                        DebugLog(@"urlstr %@ result %@",urlstr,result);
                        [self.imageFileArray addObject:imageName];
                        [imageName release];
                    
                        MyPhoto *photo = [[MyPhoto alloc] initWithImageURL:[NSURL URLWithString:imageName.imagePath] name:imageName.imageName];
                        photo.imagePath = imageName.imagePath;
                        [self.imageSourceArray addObject:photo];
                        [photo release];
                }
            }
            
        };
        
        ALAssetsLibraryGroupsEnumerationResultsBlock
        libraryGroupsEnumeration = ^(ALAssetsGroup* group,BOOL* stop){
            
            if (group == nil)
            {
                
            }
            
            if (group!=nil) {
                
                NSString* groupname = [group valueForProperty:ALAssetsGroupPropertyName];
                
                if ([groupname isEqualToString:KIMAGEMODELNAME]) {
                    
                    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:groupEnumerAtion];
                    
                    stop = false;
                }
                
            }
            
        };
        
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                              usingBlock:libraryGroupsEnumeration
                            failureBlock:failureblock];
        [library release];      
        [pool release];
    });  
    
}

- (void)addTakePhotoImage:(NSString * )urlstr{
    
    MYImageName * imageName = [[MYImageName alloc] init];
    imageName.imageName = urlstr;
    imageName.imagePath = urlstr;
    imageName.imageUrl =  [NSURL URLWithString:urlstr];
    [self.imageFileArray insertObject:imageName atIndex:0];
    [imageName release];
    
    MyPhoto *photo = [[MyPhoto alloc] initWithImageURL:[NSURL URLWithString:imageName.imagePath] name:imageName.imageName];
    photo.imagePath = imageName.imagePath;
    [self.imageSourceArray insertObject:photo atIndex:0];
    [photo release];
}

- (void)updateImageFile{
    
//    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self saveImagePath] error:nil];
//    NSArray *onlyPics = [dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.png'"]];
//    [self.imageFileArray removeAllObjects];
//    for (NSString * imageObject in onlyPics) {
//        MYImageName * imageName = [[MYImageName alloc] init];
//        imageName.imageName = imageObject;
//        imageName.imagePath = [[self saveImagePath] stringByAppendingPathComponent:imageObject];
//        [self.imageFileArray addObject:imageName];
//        [imageName release];
//    }
//    
//    [self.imageSourceArray removeAllObjects];
//    
//    for (MYImageName * imageObject in self.imageFileArray) {
//        
//        MyPhoto *photo = [[MyPhoto alloc] initWithImageURL:[NSURL fileURLWithPath:imageObject.imagePath] name:imageObject.imageName];
//        photo.imagePath = imageObject.imagePath;
//        [self.imageSourceArray addObject:photo];
//        [photo release];
//    }
    [self getImgs];
    
}

- (void)addImageFileWithImageName:(NSString *)imageName imagePath:(NSString *)imagePath{
    
    MYImageName * imageN = [[MYImageName alloc] init];
    imageN.imageName = imageName;
    imageN.imagePath = imagePath;
    [self.imageFileArray addObject:imageN];
    [imageN release];
    
    MyPhoto *photo = [[MyPhoto alloc] initWithImageURL:[NSURL fileURLWithPath:imageN.imagePath] name:imageN.imageName];
    photo.imagePath = imageN.imagePath;
    [self.imageSourceArray addObject:photo];
    [photo release];
}

- (void)deleteImageFromFileWithIndex:(NSInteger)index{
    
    MyPhoto * photo = (MyPhoto *)[self.imageSourceArray objectAtIndex:index];
    
    [[NSFileManager defaultManager] removeItemAtPath:photo.imagePath error:nil];
    [self.imageFileArray removeObjectAtIndex:index];
    [self.imageSourceArray removeObjectAtIndex:index];
    
}

- (void)addPcmDataToArray:(NSData *)pcmData{
    
    [self.pcmDataArray addObject:pcmData];
}

//0:下载中 1:下载成功 2:下载失败
- (void)updateDownLoadVideoState:(NSString *)videoName state:(NSInteger)state{
    
    if (!self.downloadVideoFileNameDic) {
        self.downloadVideoFileNameDic = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    
    [self.downloadVideoFileNameDic setObject:[NSNumber numberWithInt:state] forKey:videoName];
}

- (NSInteger)getDownLoadVideoFileState:(NSString *)videoName{
    
    NSNumber * number = [self.downloadVideoFileNameDic objectForKey:videoName];
    if (number) {
        
        return [number intValue];
    }
    
    return -1;
}

- (NSString *)getFilePathAtDocument:(NSString *)string{
    
    NSString * path = [NSString stringWithFormat:@"%ld/%@",(long)self.userInfoData.userId,string];
    NSString * imageFilePath = [[ToolClass documentDirectoryPath] stringByAppendingPathComponent:path];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:imageFilePath]) {
        return imageFilePath;
    }
    else{
        
        if ([fileManager createDirectoryAtPath:imageFilePath withIntermediateDirectories:YES attributes:nil error:nil]) {
            return imageFilePath;
        }
    }
    
    return nil;
    
}

- (NSString *)getFilePathAtUserIDPath:(NSString *)fileName{
    
    NSString * path = [NSString stringWithFormat:@"%ld",(long)self.userInfoData.userId];
    NSString * imageFilePath = [[ToolClass documentDirectoryPath] stringByAppendingPathComponent:path];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:imageFilePath]) {
        return [imageFilePath stringByAppendingPathComponent:fileName];
    }
    else{
        
        if ([fileManager createDirectoryAtPath:imageFilePath withIntermediateDirectories:YES attributes:nil error:nil]) {
            return [imageFilePath stringByAppendingPathComponent:fileName];
        }
    }
    
    return nil;
}

- (NSString *)getVideoFileTempPath{
    
    NSString * path = [NSString stringWithFormat:@"%@",@"tempvideo"];
    NSString * imageFilePath = [[ToolClass documentDirectoryPath] stringByAppendingPathComponent:path];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:imageFilePath]) {
        return imageFilePath;
    }
    else{
        
        if ([fileManager createDirectoryAtPath:imageFilePath withIntermediateDirectories:YES attributes:nil error:nil]) {
            return imageFilePath;
        }
    }
    return @"";
}
- (NSString *)getVideoFilePath:(NSString *)fileName{
    
    NSString * path = [NSString stringWithFormat:@"%@",@"video"];
    NSString * imageFilePath = [[ToolClass documentDirectoryPath] stringByAppendingPathComponent:path];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:imageFilePath]) {
        return [imageFilePath stringByAppendingPathComponent:fileName];
    }
    else{
        
        if ([fileManager createDirectoryAtPath:imageFilePath withIntermediateDirectories:YES attributes:nil error:nil]) {
            return [imageFilePath stringByAppendingPathComponent:fileName];
        }
    }
    
    return nil;
}


- (NSString *)saveImagePath{
    
    if (self.userInfoData.userId != 0) {
        
        NSString * path = [NSString stringWithFormat:@"%d/%@",self.userInfoData.userId,KSAVEIMAGEPATH];
        NSString * imageFilePath = [[ToolClass documentDirectoryPath] stringByAppendingPathComponent:path];
        NSFileManager * fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:imageFilePath]) {
            return imageFilePath;
        }
        else{
            
            if ([fileManager createDirectoryAtPath:imageFilePath withIntermediateDirectories:YES attributes:nil error:nil]) {
                return imageFilePath;
            }
        }
    }

    return nil;
}

-(void)cameraListInfo:(NSMutableDictionary *)info{
    
    NSNumber * cameraIdKey = [NSNumber numberWithInt:[[info objectForKey:@"cameraid"] intValue]];
    
     CameraInfoData * camera = [CameraInfoData  cameraDataWithDict:info];
//    if (camera.cameraCount != 0)
    {
        
        [self.cameraListDiction setObject:camera forKey:cameraIdKey];
        
//        for (int i = 0; i < 200; i ++) {
//            
//            cameraIdKey = [NSNumber numberWithInt:[[info objectForKey:@"cameraid"] intValue] + i];
//            [self.cameraListDiction setObject:camera forKey:cameraIdKey];
//
//        }
    }
    
    
}

- (void)deleteCameraWithCameraId:(NSInteger)cameraId{
    
    NSNumber * cameraIdKey = [NSNumber numberWithInt:cameraId];
    [self.cameraListDiction removeObjectForKey:cameraIdKey];
}

- (void)cameraStateInfoUpdate:(NSMutableDictionary *)info{
    
    NSInteger cameraid = [[info objectForKey:@"cameraid"] intValue];
    NSNumber * cameraIdKey = [NSNumber numberWithInt:cameraid];
    CameraInfoData * dict =  [self.cameraListDiction objectForKey:cameraIdKey];
    if (dict) {
        
        [dict updateCameraStatus:info];
    }
    
    //开始下载camera 图标
    if (dict.status == CameraStateOnline) {
        
        [[AppDelegate getAppDelegate].mygcdSocketEngine sendDownLoadCameraGridImageRequest:self.userInfoData.userId cameraid:cameraid password:dict.password];//
    }

}

- (CameraInfoData *)getCameraInfoWithCameraId:(NSInteger )cameraId{
    
    NSNumber * cameraIdKey = [NSNumber numberWithInt:cameraId];
    return  [self.cameraListDiction objectForKey:cameraIdKey];

}

- (void)setCameraStateValueWithCameraId:(NSInteger)cameraid{
    
    CameraInfoData * info = [self getCameraInfoWithCameraId:cameraid];
    info.flagUpnp_success = -1;
    info.flagUserProvenResp = NO;
    
}

- (void)deleteAlertEventDataFromDict:(NSInteger)cameraid{
    
    NSNumber * cameraId = [NSNumber numberWithInt:cameraid];
    [self.alertEventListDataDict removeObjectForKey:cameraId];
    
}

- (void)addAlertEventToAlertListData:(AlertEventData *)alertEventData{
    
    NSNumber * cameraId = [NSNumber numberWithInt:alertEventData.cameraid];
    AlertPictureListData * data = [self.alertEventListDataDict objectForKey:cameraId];
    if (!data) {
        
        AlertPictureListData * data = [[AlertPictureListData alloc] initDataWithAlertEvent:alertEventData];
        [self.alertEventListDataDict setObject:data forKey:cameraId];
        [data release];
    }
    else{
        
        [data addEventDataWithAlertEventData:alertEventData];
    }
    
    [self addalertEventNumberWithCameraId:alertEventData.cameraid];
    
//    NSNumber * number = [self.alertNumberDict objectForKey:cameraId];
//    NSInteger numberValue = 0;
//    if (number) {
//        
//        numberValue = [number intValue] + 1;
//    }
//    else
//    {
//        numberValue = 1;
//    }
//    number = [NSNumber numberWithInt:numberValue];
//    [self.alertNumberDict setObject:number forKey:cameraId];
    
}

- (void)addalertEventNumberWithCameraId:(NSInteger)cameraid{
    
    NSNumber * cameraId = [NSNumber numberWithInt:cameraid];
    NSNumber * number = [self.alertNumberDict objectForKey:cameraId];
    NSInteger numberValue = 0;
    if (number) {
        
        numberValue = [number intValue] + 1;
    }
    else
    {
        numberValue = 1;
    }
    
    number = [NSNumber numberWithInt:numberValue];
    [self.alertNumberDict setObject:number forKey:cameraId];
}

- (void)updateAlertEventFileListWithDict:(NSDictionary *)info{
    
    NSNumber * cameraId = [NSNumber numberWithInt:[[info objectForKey:@"cameraid"] intValue]];
    AlertPictureListData * data = [self.alertEventListDataDict objectForKey:cameraId];
    if (!data) {
        
        data = [[AlertPictureListData alloc] initWithInfo:info];
        [self.alertEventListDataDict setObject:data forKey:cameraId];
        [data release];       
    }
    else{
        
        [data addInfoWithDict:info];
    }
    
}

- (void)deleteRecordDataFromDict:(NSInteger)cameraid{
    
    NSNumber * cameraId = [NSNumber numberWithInt:cameraid];
    [self.recordListDataDict removeObjectForKey:cameraId];
    
}

- (AlertPictureListData *)getAlertEventListDataWithCameraID:(NSInteger)cameraid{
    
    NSNumber * cameraId = [NSNumber numberWithInt:cameraid];

    return [self.alertEventListDataDict objectForKey:cameraId];
}

- (RecordListData *)getRecordDataWithCameraId:(NSInteger)cameraid{
    
    NSNumber * cameraId = [NSNumber numberWithInt:cameraid];
    return [self.recordListDataDict objectForKey:cameraId];
}

- (void)updateRecordFileListWithDict:(NSDictionary *)info{
    

    NSNumber * cameraId = [NSNumber numberWithInt:[[info objectForKey:@"cameraid"] intValue]];
    RecordListData * data = [self.recordListDataDict objectForKey:cameraId];
    if (!data) {
        
        RecordListData * data = [[RecordListData alloc] initWithInfo:info];
        [self.recordListDataDict setObject:data forKey:cameraId];
        [data release];
    }
    else{
        
        [data addInfoWithDict:info];
    }
}

- (DeviceLanaguage)currentSystemLanguage{
    
    NSString* languageCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([languageCode isEqualToString:@"ru"]) {
        
        return DeviceLanaguage_RU;
        
    }
    
    if ([languageCode isEqualToString:@"en"]) {
        
        return DeviceLanaguage_EN;
    }
    
    if ([languageCode isEqualToString:@"zh-Hans"]) {
        
        return DeviceLanaguage_ZH_S;
    }
    
    if ([languageCode isEqualToString:@"zh-Hant"]) {
        
        return DeviceLanaguage_ZH_T;
    }

    return 0;
}

- (void)saveAccountInfo{
    
    [self saveAccountAndPassword:self.userInfoData.accountIdStr password:self.userInfoData.passwordStr];
}

- (void)saveAccountAndPassword:(NSString *)userName password:(NSString *)password{
    
    NSError *error;
    BOOL saved = [SFHFKeychainUtils storeUsername:userName
                                      andPassword:password
                                   forServiceName:KServiceName
                                   updateExisting:YES
                                            error:&error ];
    if (!saved) {
        DebugLog(@"保存密码时出错：%@", error);
    }

}

- (void)deleteAccountFromkeychain:(NSString *)userName{
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"loginType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSError * error;
    BOOL saved = [SFHFKeychainUtils deleteItemForUsername:userName andServiceName:KServiceName error:&error];
    
    if (!saved) {
        
         DebugLog(@"删除密码时出错：%@", error);
    }
}

- (NSString *)getPassword:(NSString *)userName{
    
    if (!userName) {
        
        return nil;
    }
    
    NSError *error;
    error = nil;
    NSString *thePassword = [SFHFKeychainUtils getPasswordForUsername:userName
                                                       andServiceName:KServiceName
                                                                error:&error];
    if(error){
        DebugLog(@"从Keychain里获取密码出错：%@", error);
    }
    
    return thePassword;
}


- (void)initMyUdpSocket:(NSDictionary *)mcuipdat{
    
    [self.myUdpSocket close];
    MYGCDAsyncUdpSocket * udp = [[MYGCDAsyncUdpSocket alloc] init];
    [udp initUdpSocket:mcuipdat];
    self.myUdpSocket = udp;
    [udp release];

}

- (void)initAudioRecordEngine{
    
    if (!self.audioRecordEngine) {
        
        AudioRecordEngine * record = [[AudioRecordEngine alloc] init];
        self.audioRecordEngine = record;
        [record release];
    }
    
    self.audioRecordEngine.delegate = self.myUdpSocket;

}

- (void)addHaveDownImageFileName:(NSString *)fileName path:(NSString *)path{
//    fileName = cameraid_imageName;
    [self.haveDownloadImageFile setObject:path forKey:fileName];
}

- (void)saveSomeFile{
    
    [self.haveDownloadImageFile writeToFile:[self getFilePathAtUserIDPath:KHaveDownlodImageFile] atomically:YES];
}

- (void)addAlertApnsDict:(NSDictionary *)userInfo cameraId:(NSInteger)cameraid{
    
    [self.apnsAlertPictureDict setObject:userInfo forKey:[NSNumber numberWithInt:cameraid]];
    
}

//<xns=XNS_CAMERA><cmd=GET_CAMERA_SNAP_RESP><userid=%d><cameraid=%d><loaclurl=%s><proxyurl=%s>
- (void)downloadCameraGridImage:(NSDictionary *)dataDict{
    
    NSString * filename = [NSString stringWithFormat:@"%d.jpg",[[dataDict objectForKey:@"cameraid"] intValue]];
    NSString *  path = [[MYDataManager shareManager] getFilePathAtDocument:KCameraGridImagePath];
    NSString *  downloadPath = [path stringByAppendingPathComponent:filename];
    
    NSInteger cameraid = [[dataDict objectForKey:@"cameraid"] intValue];
    CameraInfoData * cameraInfo = [[MYDataManager shareManager] getCameraInfoWithCameraId:cameraid];
    
    if ([[dataDict objectForKey:@"ret"] intValue] == 0) {
        
        cameraInfo.flagLock = NO;
        
        NSURL *url = [NSURL URLWithString:[dataDict objectForKey:@"proxyurl"]];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        request.userInfo = [NSDictionary dictionaryWithObject:downloadPath forKey:KVIDEONAME];
        request.delegate = self;//代理
        [request setDownloadDestinationPath:downloadPath];//下载路径
        [request setAllowResumeForFileDownloads:YES];//断点续传
        request.downloadProgressDelegate = self;//下载进度代理
        [request setCachePolicy:ASIDoNotReadFromCacheCachePolicy];
        [request setCacheStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];
        [[MYDataManager shareManager].downLoadQueue addOperation:request];//添加到队列，队列启动后不需重新启动
        
//        DebugLog(@"downloadPath %@  url %@",downloadPath,url);

    }
    else
    {
        
        cameraInfo.flagLock = YES;
        
        UIImage * lockImage = [UIImage imageNamed:@"img4.png"];
        NSData * imageData = UIImagePNGRepresentation(lockImage);
        [imageData writeToFile:downloadPath atomically:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationDownCameraGridImage object:nil];

    }
    

}

- (void)requestStarted:(ASIHTTPRequest *)request{
    
    
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    
    DebugLog(@"responseHeaders %@",responseHeaders);
    
}

- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL{
    
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    
    
    NSString * alarmImageFilePath = [request.userInfo objectForKey:KALARMIMAGENAME];
    if (alarmImageFilePath) {
        
        NSString * urlStr = [[[request.url description].description pathComponents] lastObject];
        [[MYDataManager shareManager] addHaveDownImageFileName:urlStr path:alarmImageFilePath];
        [[MYDataManager shareManager] saveSomeFile];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationDownAlarmImage object:alarmImageFilePath];

    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationDownCameraGridImage object:nil];
    }

}

- (void)requestFailed:(ASIHTTPRequest *)request{
    
}

- (void)requestRedirected:(ASIHTTPRequest *)request{
    
}

- (void)setProgress:(float)newProgress{
    
    DebugLog(@"newPregress %f",newProgress);
}

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin{
    
    
    
    [self.tencentOAuth getUserInfo];

}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
    
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    
    
}


- (void)setLoginType:(LoginType)loginType{
    
    self.userInfoData.loginType = loginType;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:loginType] forKey:@"loginType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)getUserInfoResponse:(APIResponse*) response{
    
    DebugLog(@"response %@",response);
    
    self.userInfoData.qqNickname = [response.jsonResponse objectForKey:@"nickname"];
    self.userInfoData.qqOpenId = self.tencentOAuth.openId;
    self.userInfoData.qqAccessToken = self.tencentOAuth.accessToken;
    self.userInfoData.gender = [response.jsonResponse objectForKey:@"gender"];
    
    [self setLoginType:LoginTypeQQ];
    [self sendQQloginRequest];
    
}

- (void)sendQQloginRequest{
    
    NSString * cmd = [BuildSocketData buildLoginString:[MYDataManager shareManager].userInfoData.qqOpenId
                                              password:[MYDataManager shareManager].userInfoData.qqAccessToken
                                             logintype:LoginTypeQQ
                                            logintoken:[MYDataManager shareManager].userInfoData.qqAccessToken
                                           devicetoken:[MYDataManager shareManager].userInfoData.device_token
                                               partner:partnerKCam];
    
    [[AppDelegate getAppDelegate].mygcdSocketEngine writeDataOnMainThread:cmd tag:0 waitView:YES];
    
}

- (void)loginWithQQ{
    
    self.qqPermissions = [NSMutableArray arrayWithObjects:
                     kOPEN_PERMISSION_GET_USER_INFO,
                     kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                     kOPEN_PERMISSION_ADD_ALBUM,
                     kOPEN_PERMISSION_ADD_IDOL,
                     kOPEN_PERMISSION_ADD_ONE_BLOG,
                     kOPEN_PERMISSION_ADD_PIC_T,
                     kOPEN_PERMISSION_ADD_SHARE,
                     kOPEN_PERMISSION_ADD_TOPIC,
                     kOPEN_PERMISSION_CHECK_PAGE_FANS,
                     kOPEN_PERMISSION_DEL_IDOL,
                     kOPEN_PERMISSION_DEL_T,
                     kOPEN_PERMISSION_GET_FANSLIST,
                     kOPEN_PERMISSION_GET_IDOLLIST,
                     kOPEN_PERMISSION_GET_INFO,
                     kOPEN_PERMISSION_GET_OTHER_INFO,
                     kOPEN_PERMISSION_GET_REPOST_LIST,
                     kOPEN_PERMISSION_LIST_ALBUM,
                     kOPEN_PERMISSION_UPLOAD_PIC,
                     kOPEN_PERMISSION_GET_VIP_INFO,
                     kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                     kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                     kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                     nil];
    
    [self.tencentOAuth authorize:self.qqPermissions localAppId:KQQAppId inSafari:NO];
}

- (NSArray * )getShareTypeArray{
    
    NSArray * array  = nil;
    
//    if ([self currentSystemLanguage] == DeviceLanaguage_ZH_S)
    {
        array = [ShareSDK getShareListWithType:ShareTypeSinaWeibo,ShareTypeWeixiTimeline,ShareTypeWeixiSession,ShareTypeWeixiFav,ShareTypeSMS,ShareTypeCopy,nil];
    }
//    else
//    {
//        array = [ShareSDK getShareListWithType:ShareTypeFacebook,ShareTypeTwitter,ShareTypeSMS,ShareTypeCopy,nil];
//    }
    
    return array;
}

- (id<ISSShareOptions>)getShareOptionsArray{
    
    
    id<ISSShareOptions> shareOptions = nil;
    
//    if ([self currentSystemLanguage] == DeviceLanaguage_ZH_S)
    {
        shareOptions = [ShareSDK defaultShareOptionsWithTitle:nil      //分享视图标题
                                              oneKeyShareList:[[MYDataManager shareManager] getShareTypeArray]           //一键分享菜单
                                               qqButtonHidden:YES                               //QQ分享按钮是否隐藏
                                        wxSessionButtonHidden:NO                   //微信好友分享按钮是否隐藏
                                       wxTimelineButtonHidden:NO                 //微信朋友圈分享按钮是否隐藏
                                         showKeyboardOnAppear:YES                  //是否显示键盘
                                            shareViewDelegate:nil                            //分享视图委托
                                          friendsViewDelegate:nil                          //好友视图委托
                                        picViewerViewDelegate:nil];                    //图片浏览视图委托
    }
//    else
//    {
//        shareOptions = [ShareSDK defaultShareOptionsWithTitle:nil      //分享视图标题
//                                              oneKeyShareList:[[MYDataManager shareManager] getShareTypeArray]           //一键分享菜单
//                                               qqButtonHidden:YES                               //QQ分享按钮是否隐藏
//                                        wxSessionButtonHidden:YES                   //微信好友分享按钮是否隐藏
//                                       wxTimelineButtonHidden:YES                //微信朋友圈分享按钮是否隐藏
//                                         showKeyboardOnAppear:YES                  //是否显示键盘
//                                            shareViewDelegate:nil                            //分享视图委托
//                                          friendsViewDelegate:nil                          //好友视图委托
//                                        picViewerViewDelegate:nil];                    //图片浏览视图委托
//    }
    
    return shareOptions;
    
}

@end
