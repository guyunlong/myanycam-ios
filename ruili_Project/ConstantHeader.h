//
//  ConstantHeader.h
//  myanycam
//
//  Created by myanycam on 13-2-26.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#ifndef myanycam_ConstantHeader_h
#define myanycam_ConstantHeader_h


#if TARGET_IPHONE_SIMULATOR

//#define HostIp @"192.168.1.200"
#define HostPort 5200

#define HostIp_Ip @"54.235.154.234"
#define HostIp @"app.myanycam.com"

#define ApHostIp @"192.168.42.1"
#define ApHostPort 5200

#define HostLocalIp @"192.168.1.200"
#define HostLocalPort 5200

#else

//#define HostIp @"192.168.0.200"
//#define HostPort 5200

#define HostIp_Ip @"54.235.154.234"
#define HostIp @"app.myanycam.com"
#define HostPort 5200

#define ApHostIp @"192.168.42.1" 
#define ApHostPort 5200

#define HostLocalIp @"192.168.1.200"
#define HostLocalPort 5200

#endif

#ifdef  DEBUG
#define DebugLog(...) NSLog(__VA_ARGS__)
#else
#define DebugLog(...)
#endif


#define KSOCKET_TIMEOUT 30
#define KSOCKET_CONNECT_TIMEOUT 4
#define KSOCKET_READ_TIMEOUT 30

#define ANIMATION_MIN_SCALE         1
#define ANIMATION_MAX_SCALE         1.03
#define ANIMATION_DURATION          0.045

#define IMAGELOAD_CACHESECONDS      60*60*24*7

#define FONT_SIZE   15.0

#define LOCALPORT   6897
#define CAMERA_NAME_LENGTH 32
#define CAMERA_PASSWORD_LENGTH 32
#define CAMERA_PASSWORD_MIN_LENGTH 8

#define ACCOUNT_PASSWORD_MaxLENGTH 32
#define ACCOUNT_PASSWORD_MinLENGTH 8

#define AVCODEC_MAX_AUDIO_FRAME_SIZE 192000

static const int  KSCREEN_WIDTH = 320;
static const int  KSCREEN_HEIGHT = 480;
static const int  KSCREEN_HEIGHT_IPHONE5 = 568;

#define KServiceName @"com.mycompany.myanycam"
#define KVersionStr @"1.0.3"
#define KIntVersion 103
#define KTwitterUrl @"https://www.twitter.com/Myanycam"
#define KMyanycamUrl @"http://www.bit-sea.com"
#define KMyanycamHLS001 @"http://t.cn/8sPgOXn"
#define KVIDEONAME @"VideoName"
#define KALARMIMAGENAME @"ALARMIMAGENAME"
#define KPUBLICKEY @"010151B446D50000"
#define KSHARE_URL @"http://myanycam.cn/videolive.php?token="
#define KBaiduShortUrl @"http://dwz.cn/create.php"
#define K955CCShortUrl @"http://955.cc/short/?url=%@&format=json"
#define KSinaShortUrl @"http://api.t.sina.com.cn/short_url/shorten.json?source=2230613802&url_long=%@"

#define KAPPSTORE_URL @"https://itunes.apple.com/us/app/myanycam-m/id1000263150?l=zh&ls=1&mt=8"
#define KRTSP_URL @"rtsp://192.168.42.1/stream2"
#define KGetPassword_URL @"http://www.myanycam.com/?getpassword"
#define KSAVEIMAGEPATH @"SaveImage"
#define KDownlodVideoFile @"havedownfile.plist"
#define KHaveDownlodImageFile @"haveDownImagefile.plist"
#define Kdownloadvideos  @""
#define KdownloadImage  @"downloadImage"
#define KCameraGridImagePath @"cameraGridImagePath"
#define KUPNPErrorTip @"You are not authorized to view this page"
#define KAppName @"Myanycam M"
#define KSharebyMyanycam @"Shared by Myanycam M"

#define KQQAppId @"101110453"//101110453
#define KQQAppKey @"e5749c02d2dc2382700bddef2e7c9c1e"//
#define KWXAppId @"wx44df31e4ee34c10d"//
#define KSinaAppId @"3339050423"//3339050423
#define KSinaAppSecret @"941aba67daee7984dffd202f7334533c"//
#define KFacebookAppKey @"706198286067092"//ainikaim@gmail.com
#define KFacebookAppSecret @"5e7260f46fdd9a0f9594e6217ff35d47"
#define KTwitterAppKey @"9TR5K5Rykle6p3rR7ypw"
#define KTwitterAppSecret @"WafZ5ZSiz76erRB0yXU5FgMX6YhjYFkznsMwH9yGY"
#define KShareSdkAppKey @"1ce29e329e1f"
#define KParseAppId @"rKcsECSetopfF2slD6Ys5hAPMrufL0pUJY41j39O"
#define KParseAppSecret @"qSuthIJTLpdQ9oisgETKLDILLyheTQ2H0CvFjnPn"
#define KMobileClick @"5397c18456240b4fbd010c78"



#define KQRWIFIFormatStr  @"wifi:S:%@;P:%@;;"


#define V_480P_W 320.0
#define V_480P_H 213.0

#define H_480P_W 480.0
#define H_480P_H 320.0

#define V_720P_W 320.0
#define V_720P_H 180.0

#define H_720P_W 480.0
#define H_720P_H 270.0

#define INFORMATION_WORD_COLOR [UIColor colorWithRed:147/255.0f green:189/255.0f blue:209/255.0f alpha:1.0]
#define Black_WORD_COLOR [UIColor colorWithRed:10/255.0f green:10/255.0f blue:10/255.0f alpha:1.0]
#define TABLE_LINE_COLOR [UIColor colorWithRed:200/255.0f green:206/255.0f blue:211/255.0f alpha:1.0]


typedef void (^DownLoadCompletionBlock)(void);

typedef enum {
    CellDataTypeRecordVideoCycleOpenSwitch = 0,//循环播放,自动录像
    CellDataTypeRecordVideoSettingPlan,//录像计划
    CellDataTypeWarningPlanSet,//报警设置
    CellDataTypeRecordVideoSetFreeSpace,//
    
    CellDataTypeNotRecordVideo,
    CellDataTypeAllHoursRecordVideo,
    CellDataTypePlanTimeRecordVideo,
    
    CellDataTypeIsAllDayAlert,
    CellDataTypeIsMotionAlert,
    CellDataTypeIsNoiseAlert,
    CellDataTypeIsPeriodAlert,
    CellDataTypeCloseAlert,
    CellDataTypeAlertRecordSwitch,
    
} CellDataType;

typedef enum {
    SOCKET_TAG_INIT = 4,
    SOCKET_TAG_LOGIN = 5,
    SOCKET_TAG_HEADER = 6,
    SOCKET_TAG_BODY = 7,
    SOCKET_TAG_CAMERALIST,
    SOCKET_TAG_CHECK_CAMERA_PWD,
    SOCKET_TAG_CHECK_CAMERA_PWD_ALERTVIEW,
}SOCKET_TAG;

enum CMD
{    
    CMD_INIT_DATA_CHANNEL=0,	//初始化
	CMD_CREATE_DATA_CHANNEL,   //创建通道
	CMD_JOIN_DATA_CHANNEL,     //加入通道
	CMD_SEND_DATA,		   //发送数据
	CMD_START_TCP_P2P,		   //进行TCP P2P
	CMD_CLOSE_DATA_CHANNEL,   //关闭通道
	CMD_TCP_P2P_OK,	       //TCP穿透成功，可选
	CMD_START_UDP_P2P,       //可是UDP P2P
	CMD_UDP_P2P_OK,          //获取NTP地址
	CMD_GET_UDP_ADDR,       //获取NTP地址
   	CMD_LEAVE_DATA_CHANNEL  //
};

typedef enum {
    
    Audio_Format_NONE = -1,
    Audio_Format_ARM = 0,
    Audio_Format_iLAB,
    Audio_Format_ADPCM,
    Audio_Format_AAC,
    Audio_Format_AAC_8000
    
}Audio_Format;

//videosize= 1,2,3//0:QQVGA 160*120 1：QCIF 176*144  2: QVG:320*240 3:CIF352*288 4:VGA640*480 5:720*480 6:720P 7:1080P
typedef enum {
    
    VIDEO_SIZE_TYPE_QQVGA = 0,
    VIDEO_SIZE_TYPE_QCIF = 1,
    VIDEO_SIZE_TYPE_QVGA = 2,
    VIDEO_SIZE_TYPE_CIF = 3,
    VIDEO_SIZE_TYPE_VGA = 4,
    VIDEO_SIZE_TYPE_480P = 5,
    VIDEO_SIZE_TYPE_720P = 6,
    VIDEO_SIZE_TYPE_1080P = 7,
    VIDEO_SIZE_TYPE_640X360 = 8,
    VIDEO_SIZE_TYPE_320X180 = 9,
    VIDEO_SIZE_TYPE_960X540 = 10,
    
}VIDEO_SIZE_TYPE;


enum AlertViewType{
    
    AlertViewTypeWait = 100,
    AlertViewTypeQuestion,
    AlertViewTypeTop,
};

//原来的图片属性 0：移动侦测报警 1：声音报警 增加一个2:手动拍照 增加一个图标来显示是手动拍照

enum AlertEventType{
    
    AlertTypeNone = -1,//不是报警
    AlertTypeMotion,//移动侦测报警
    AlertTypeNoise,//噪声报警
    AlertTypeManual,//手动拍照
    AlertTypeThermalInfrared,//热红外人体感应报警
    AlertTypeLow_Power,//电量不足
    AlertTypeOther,//其他
};


//录像类型：0：定时录像 1：报警录像 2：手动录像
enum RecordType{
    
    RecordTypeNone = -1,// 
    RecordTypeTiming,//定时录像
    RecordTypeAlert,//报警录像
    RecordTypeManually,//手动录像
};


typedef enum{
    
    DeviceLanaguage_EN ,//
    DeviceLanaguage_ZH_T,//
    DeviceLanaguage_ZH_S,//
    DeviceLanaguage_RU,//
} DeviceLanaguage ;


enum AUDIO_PLAY_STATE{
    
    AUDIO_PLAY_STATE_NONE ,
    AUDIO_PLAY_STATE_PREPARE,
    AUDIO_PLAY_STATE_PLAY,
    AUDIO_PLAY_STATE_PAUSE,
    AUDIO_PLAY_STATE_STOP,
    AUDIO_PLAY_STATE_WaitBuffering
};

typedef enum {
    
    PhotoBrowseTypeNone = 0,//
    PhotoBrowseTypeTakePhoto,//拍照相册
    PhotoBrowseTypeAlertPhoto,//报警相册
    
} PhotoBrowseType;

typedef enum {
    
    LoginTypeNone = 0,//
    LoginTypeFacebook,//facebook 登录
    LoginTypeTwitter,//twitter 登录
    LoginTypeQQ,//qq 登录
    
} LoginType;



typedef enum {
    
    DeviceTypeIphone,//
    DeviceTypeIphone5,//
    DeviceTypeIpad1,
    DeviceTypeIpad2,
    DeviceTypeIpadMini
    
} DeviceType;

typedef enum {
    
    CameraStateNone = -1,
    CameraStateOffline = 0,
    CameraStateOnline,//在线
    CameraStateHadWatch,//被看
    CameraStateUpdate,//升级
    
} CameraState;

typedef enum {
    
    ChipTypeAmbarella = 1,
    ChipTypeAnyka = 2 ,
    
} ChipType;

typedef enum {
    
    CameraWorkTypeAP = 1,
    CameraWorkTypeCloud = 2 ,
    
} CameraWordType;


typedef enum {
    
    BaseAlertViewButtonTypeCancel = 0,
    BaseAlertViewButtonTypeOK = 1 ,
    
} BaseAlertViewButtonType;


//type：0：移动侦测 1：声音报警 2：一键通话 3：视频留言

typedef enum {
    
    CameraApnsStateMotion = 0,
    CameraApnsStateNoise,
    CameraApnsStateCall,
    CameraApnsStateVideoFile,
    
} CameraApnsState;


typedef enum {
    SoundEffectDefault = 1000,
    SoundEffectCall = 1001,
    SoundEffectShot = 1002,
    SoundEffectNone = 9999,
    
} SoundEffect;

//partner=1   myanycam
//partner=2  myanycamHD
//partner=3  abbric
//partner=4  abbricHD

typedef enum {
    
    partnerMyanycam = 1,
    partnerMyanycamHD = 2,
    partnerAbbric = 3,
    partnerAbbricHD = 4,
    partnerKCam = 5,
    
} partnerType;

//命令里面 type : 3:安卓 myanycam 4: 苹果 myanycam 5:安卓 k.cam 6:苹果k.cam 7:安卓 wasy 8:ios wasy
typedef enum {
    
    myanycamAppType_android_myanycam= 3,
    myanycamAppType_ios_myanycam = 4,
    myanycamAppType_android_kcam =5,
    myanycamAppType_ios_kcam =6,
    myanycamAppType_android_wasy = 7,
    myanycamAppType_ios_wasy = 8,
    
} myanycamAppType;

typedef enum {
    SystemSetType_Account,
    SystemSetType_ChangePassword,
    SystemSetType_About,
} SystemSetType;


typedef enum {
    
    CameraSetType_CameraInfo,
    CameraSetType_ChangeCameraPassword,
    CameraSetType_SetWifi,
    CameraSetType_SetEthernet,
    CameraSetType_RecordSet,
    CameraSetType_AlarmSet,
    CameraSetType_Rotate180,
    CameraSetType_Sn,
    CameraSetType_Restart,
    
} CameraSetType;


#pragma pack(1)

struct  McuHeader{
    unsigned int totalLen;//数据总长度
    char          cmd;//命令类型
    unsigned int channelId;//数据通道
};

struct UdpMediaHeader{
    char msgHeader[4];
    unsigned int msgId;
    short         totalPacket;
    short         currentPacketNo;
};




struct MediaDataHeader{
    
    char  mediaType;
    char  mediaFormat;
    unsigned int  time;
    char  mediaFormatSize;
    
};






#pragma pack()


#define KIMAGEMODELNAME  @"KCam"
#define KALERTTYPE  @"KALERTTYPE"

#define KNotificationFBSessionStateOpen @"KNotificationFBSessionStateOpen"
#define KNotificationFBLoginError @"KNotificationFBLoginError"
#define KNotificationTwitterSessionStateOpen @"KNotificationTwitterSessionStateOpen"
#define KNotificationSaveSnapCurrentPicture @"KNotificationSaveSnapCurrentPicture"
#define KNotificationKICK_OFF @"KNotificationKICK_OFF"
#define KNotificationCameraState @"KNotificationCameraState"
#define KNotificationMYNetAsynsocketError @"KNotificationMYNetAsynsocket"
#define KNotificationResignActive @"KNotificationResignActive"
#define KNotificationBackgroundToForeground @"KNotificationBackgroundToForeground"
#define KNotificationForegroundToBackground @"KNotificationForegroundToBackground"
#define KNotificationBecomeActive @"KNotificationBecomeActive"
#define kNotificationAppWillResignActive @"kNotificationAppWillResignActive"
#define kNotificationAppDidBecomeActive @"kNotificationAppDidBecomeActive"
#define kNotificationDismissDelegate @"kNotificationDismissDelegate"
#define kNotificationLogout @"kNotificationLogout"
#define kNotificationLoginSuccess @"kNotificationLoginSuccess"
#define kNotificationDeleteCameraSuccess @"kNotificationDeleteCameraSuccess"
#define kNotificationDeletePictureSuccess @"kNotificationDeletePictureSuccess"
#define kNotificationDeleteVideoSuccess @"kNotificationDeleteVideoSuccess"
#define kNotificationCameraInfoModifySuccess @"kNotificationCameraInfoModifySuccess"
#define kNotificationCameraInfoAlertEvent @"kNotificationCameraInfoAlertEvent"
#define kNotificationNetworkStateChange @"kNotificationNetworkStateChange"
#define kNotificationRootControllerDismiss @"kNotificationRootControllerDismiss"
#define kNotificationCellNeedWobble @"kNotificationCellNeedWobble"
#define kNotificationChooseTwitterAccountCancel @"kNotificationChooseTwitterAccountCancel"
#define KNotificationGetAgentError @"KNotificationGetAgentError"
#define KNotificationDownAlertImage @"KNotificationDownAlertImage"
#define KNotificationDownCameraGridImage @"KNotificationDownCameraGridImage"
#define KNotificationNeedChangeVideoQuality @"KNotificationNeedChangeVideoQuality"
#define KNotificationDownAlarmImage @"KNotificationDownAlarmImage"
#define KNotificationAPmodeManualRecord @"KNotificationAPmodeManualRecord"
#define KNotificationAPmodeManualTakePhoto @"KNotificationAPmodeManualTakePhoto"
#define KNotificationShowChangePasswordAlert @"KNotificationShowChangePasswordAlert"



#endif
