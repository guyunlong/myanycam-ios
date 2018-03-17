//
//  BuildSocketData.m
//  myanycam
//
//  Created by myanycam on 13-2-26.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "BuildSocketData.h"
#import "dealWithCommend.h"
#import "base64.h"
#import "ToolClass.h"
#import "NSData+AES.h"
#import "GTMBase64.h"


@implementation BuildSocketData

//1.获取网络设置参数
//xns= XNS_CAMERA
//cmd= GET_NETWORK_INFO

+ (NSString *)buildGetNetSettingInfoString:(NSInteger)userid cameraid:(NSInteger)cameraid{
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"GET_NETWORK_INFO"];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%ld",(long)userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%ld",(long)cameraid]];
    return cmd;
}

//2.修改网络参数
//客户端发送
//xns= XNS_CAMERA
//cmd= MODIFY_NETWORK_INFO
//dhcp=0 //0:false 1:true
//ip=192.168.1.100 //IP地址
//mask=255.255.255.0 //子网掩码
//netgate= 192.168.1.1//默认网关
//dns1 = 202.96.134.133 //DNS
//dns2= 202.96.134.122 //备用DNS
//mac=AD-DB-FF-CC-87-CA-35-11 //网卡物理地址
+ (NSString *)buildSettingEthernetString:(NSString *)dhcp ip:(NSString *)ipAddress mask:(NSString *)maskAddress gateWay:(NSString *)gateWay dns1:(NSString *)dns1 dns2:(NSString *)dns2 userid:(NSInteger)userid cameraid:(NSInteger)cameraid{
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"MODIFY_NETWORK_INFO"];
    cmd=[dealWithCommend addElement:cmd eName:@"dhcp" eData:dhcp];
    cmd=[dealWithCommend addElement:cmd eName:@"ip" eData:ipAddress];
    cmd=[dealWithCommend addElement:cmd eName:@"mask" eData:maskAddress];
    cmd=[dealWithCommend addElement:cmd eName:@"netgate" eData:gateWay];
    cmd=[dealWithCommend addElement:cmd eName:@"dns1" eData:dns1];
    cmd=[dealWithCommend addElement:cmd eName:@"dns2" eData:dns2];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraid]];
    return cmd;
}

//3.获取wifi参数
//客户端发送：
//xns= XNS_CAMERA
//cmd= GET_WIFI_INFO

//摄像头回复：
//xns= XNS_CAMERA
//cmd= WIFI_INFO
//wifi= 0; //是否开启WIFI功能 0：关闭 1：开启
//ssid=TP-LINK; //当前使用的ssid
//safety= 0//安全类型 0：NONE 1:WPA 2:WP2
//password=********//wifi密码

//当前其他可用热点：
//xns= XNS_CAMERA
//cmd= HOT_SPOT
//ssid=TP-LINK; //当前使用的ssid
//safety= 0//安全类型 0：NONE 1:WPA 2:WP2
//signal=0; //信号强度
//注：如果有多个发送多次

+ (NSString *)buildGetWifiInfoString:(NSInteger)userid cameraid:(NSInteger)cameraid {
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"GET_WIFI_INFO"];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraid]];
    return cmd;
}

//4.修改wifi参数
//客户端发送：
//xns= XNS_CAMERA
//cmd= SET_WIFI_INFO
//wifi= 0; //是否开启WIFI功能 0：关闭 1：开启
//ssid=TP-LINK; //当前使用的ssid
//safety= 0//安全类型 0：NONE 1:WPA 2:WP2
//password=********//wifi密码
//摄像头不回

+ (NSString *)buildSetWifiInfoString:(NSString *)wifiOpen ssid:(NSString *)ssid safety:(NSString *)safety password:(NSString *)password userid:(NSInteger)userid cameraid:(NSInteger)cameraid {
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"SET_WIFI_INFO"];
    cmd=[dealWithCommend addElement:cmd eName:@"wifi" eData:wifiOpen];
    cmd=[dealWithCommend addElement:cmd eName:@"ssid" eData:ssid];
    cmd=[dealWithCommend addElement:cmd eName:@"safety" eData:safety];
    cmd=[dealWithCommend addElement:cmd eName:@"password" eData:password];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraid]];
    return cmd;
}

//5.获取用户信息参数
//客户端发送：
//xns= XNS_CAMERA
//cmd= GET_DEVICE_INFO
//
//摄像头回复：
//xns= XNS_CAMERA
//cmd= DEVICE_INFO
//sn= E417-D54F-40b4-DE56 //系统序列号 只读
//password = *****//访问密码
//timezone = 8;    //时区
//producter = anke;	//生产厂家 只读
//mode = //型号 只读

+ (NSString *)buildGetDeviceInfoString{
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"GET_DEVICE_INFO"];
    return cmd;
}

//6.修改用户信息参数
//xns= XNS_CAMERA
//cmd= CONIFG
//password=****** //
//time_zone= //时区  -12 到 13
+ (NSString *)buildSetDeviceInfoString:(NSString *)password timeZone:(NSString *)timeZone{
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"CONIFG"];
    cmd=[dealWithCommend addElement:cmd eName:@"password" eData:password];
//    cmd=[dealWithCommend addElement:cmd eName:@"time_zone" eData:timeZone];
    return cmd;
}

+ (NSString *)buildRegisterString:(NSString *)accountString password:(NSString *)passwordStr{
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"REGISTER"];
    cmd=[dealWithCommend addElement:cmd eName:@"account" eData:accountString];
    cmd=[dealWithCommend addElement:cmd eName:@"password" eData:[MyMD5 md5:passwordStr]];
    return cmd;
}

//xns=XNS_CLIENT
//cmd=LOGIN
//account=*****
//password=***** //MD5加密后的值
//type=0   //0:windows 1:web 3:android 4:ios 5:imac
//logintype = 0; //0:myanycam 1:facebook 2:twitter 3:qq
//logintoken=*******************; //用户用其他系统登录时使用
//devicetoken=*****************; //苹果手机等消息推送的设备ID
//version=****  //程序版本

//login:<xns=XNS_CLIENT><cmd=LOGIN><account=andida@andida.com><password=e10adc3949ba59abbe56e057f20f883e><type=4><logintype=0><logintoken=><devicetoken=(null)><version=103>
//<version=103> 版本为 1.0.3，传整型103
//
//loginRsp:<cmd=LOGIN_RESP><fromuid=0><ret=0><touid=0><userid=268><xns=XNS_CLIENT><upgradetype=0>
//新增：<upgradeType=0>  0：不升级 1：可选升级  2：强制升级

+ (NSString *)buildLoginString:(NSString *)accountString password:(NSString *)passwordStr  logintype:(NSInteger)logintype logintoken:(NSString *)logintoken devicetoken:(NSString *)devicetoken partner:(NSInteger)partner {
    
    NSString * cmd = @"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"LOGIN"];
    cmd=[dealWithCommend addElement:cmd eName:@"account" eData:accountString];
    cmd=[dealWithCommend addElement:cmd eName:@"password" eData:[MyMD5 md5:passwordStr]];
    cmd=[dealWithCommend addElement:cmd eName:@"type" eData:[NSString stringWithFormat:@"%d",myanycamAppType_ios_kcam]];
    cmd=[dealWithCommend addElement:cmd eName:@"logintype" eData:[NSString stringWithFormat:@"%d",logintype]];
    cmd=[dealWithCommend addElement:cmd eName:@"logintoken" eData:logintoken];
    cmd=[dealWithCommend addElement:cmd eName:@"devicetoken" eData:devicetoken];
    cmd=[dealWithCommend addElement:cmd eName:@"version" eData:[NSString stringWithFormat:@"%d",KIntVersion]];
    cmd=[dealWithCommend addElement:cmd eName:@"partner" eData:[NSString stringWithFormat:@"%d",partner]];
    return cmd;
}



+ (NSString *)buildAgentAddressData{
    
    NSString *initCmd=@"";
    initCmd=[dealWithCommend addElement:initCmd eName:@"cmd" eData:@"GET_AGENT_ADDR"];
    initCmd=[dealWithCommend addElement:initCmd eName:@"fromuid" eData:@"0"];
    initCmd=[dealWithCommend addElement:initCmd eName:@"touid" eData:@"0"];
    initCmd=[dealWithCommend addElement:initCmd eName:@"xns" eData:@"XNS_CLIENT"];
    return initCmd;
}

+ (NSString *)buildDownloadCamera:(NSInteger )userId{
 
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"DOWNLOAD_CAMERA"];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userId]];
    return cmd;
}

+ (NSString *)buildGetMcu:(NSInteger)userId{
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"GET_MCU"];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userId]];
    return cmd;
}

+ (NSString *)buildSwitchAudioStr:(NSString *)mcpIp mcuPort:(NSInteger)port channelId:(NSInteger)channelId userid:(NSInteger)userid cameraid:(NSInteger)cameraid switchFlag:(NSInteger)switchFlag{
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"AUDIO_SWITCH"];
    cmd=[dealWithCommend addElement:cmd eName:@"mcuip" eData:mcpIp];
    cmd=[dealWithCommend addElement:cmd eName:@"mcuport" eData:[NSString stringWithFormat:@"%d",port]];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraid]];
    cmd=[dealWithCommend addElement:cmd eName:@"channelid" eData:[NSString stringWithFormat:@"%d",channelId]];
    cmd=[dealWithCommend addElement:cmd eName:@"switch" eData:[NSString stringWithFormat:@"%d",switchFlag]];//switch= //0: 关闭 1打开
    return cmd;
}

//xns= XNS_CLIENT
//cmd= STOP_WATCH_CAMERA
//userid=
//cameraid=
//password=//摄像头访问密码
+ (NSString *)buildStopWatchCamera:(NSInteger)userId cameraid:(NSString *)cameraid password:(NSString *)password {
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"STOP_WATCH_CAMERA"];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userId]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData: cameraid];
    cmd=[dealWithCommend addElement:cmd eName:@"password" eData: password];
    
    return cmd;
}

//添加摄像头
//xns=XNS_CLIENT
//cmd= ADD_CAMERA
//userid=
//sn=
//password=//访问密码

+ (NSString *)buildAddCamera:(NSInteger)userId cameraSn:(NSString *)cameraSn password:(NSString *)password name:(NSString *)name type:(NSInteger)type timezone:(NSInteger)timezone {
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"ADD_CAMERA"];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userId]];
    cmd=[dealWithCommend addElement:cmd eName:@"sn" eData:cameraSn];
    cmd=[dealWithCommend addElement:cmd eName:@"name" eData:[ToolClass encodeBase64:name]];
    cmd=[dealWithCommend addElement:cmd eName:@"type" eData:[NSString stringWithFormat:@"%d",type]];
//    cmd=[dealWithCommend addElement:cmd eName:@"timezone" eData:[NSString stringWithFormat:@"%d",timezone]];
    cmd=[dealWithCommend addElement:cmd eName:@"password" eData:password];
    
    return cmd;
}

//调节摄像头视频
//
//xns=XNS_CLIENT
//cmd= MODIFY_VIDEO_SIZE0
//userid=
//cameraid=
//password=//摄像头访问密码
//mcuip=192.168.1.22
//mcuport=3399
//channelid=3455789
//videosize= //0:QQVGA 160*120 1：QCIF 176*144  2: QVG:320*240 3:CIF352*288 4:VGA640*480 5:720P 6:1080P
//
//注：需要记录上一帧数据的时间戳，如果两个帧的时差超过3秒需要降低分辨率，PC端默认的分辨率为 VGA  移动端默认为QVGA 。如果时差连续30帧小于1秒 可以增加分辨率，直到达到最优，或者是摄像头不支持为止

+ (NSString *)buildModifyVideoSizeData:(NSInteger)userId cameraId:(NSInteger)cameraId password:(NSString *)password mcuIp:(NSString *)mcuIp mcuPort:(NSInteger)port channelId:(NSInteger)channelId videoSize:(NSInteger)videoSize {
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"MODIFY_VIDEO_SIZE"];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userId]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraId]];
    cmd=[dealWithCommend addElement:cmd eName:@"password" eData:password];
    cmd=[dealWithCommend addElement:cmd eName:@"mcuip" eData:mcuIp];
    cmd=[dealWithCommend addElement:cmd eName:@"mcuport" eData:[NSString stringWithFormat:@"%d",port]];
    cmd=[dealWithCommend addElement:cmd eName:@"channelid" eData:[NSString stringWithFormat:@"%d",channelId]];
    cmd=[dealWithCommend addElement:cmd eName:@"videosize" eData:[NSString stringWithFormat:@"%d",videoSize]];
    return cmd;
}


//Xns = XNS_CLIENT
//Cmd = RECORD_CONFIG
//policy= 0; //录像策略 0：不录像 1：循环录像 2：分段录像
//repeat=1110011;  //重复周期 7位数字分别代表周一到周日，0：不录像 1：录像
//begintime1=00:00:00
//endtime1=00:00:00
//switch1=0        //时段是否有效
//begintime2=00:00:00
//endtime2=00:00:00
//switch2=0        //时段是否有效
//begintime3=00:00:00
//endtime3=00:00:00
//switch3=0        //时段是否有效
//begintime4=00:00:00
//endtime4=00:00:00
//switch4=0        //时段是否有效

//20130719 andida
//policy= 0; //录像策略 0:24小时循环录像 1:报警录像

+ (NSString *)buildRecordConfig:(NSInteger)policy cameraid:(NSInteger)cameraid password:(NSString *)password repeat:(NSInteger)repeat beginAndEndTimes:(NSArray *)times recordSwitch:(NSInteger)recordSwitch userId:(NSInteger)userId{
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"RECORD_CONFIG"];
    cmd=[dealWithCommend addElement:cmd eName:@"policy" eData:[NSString stringWithFormat:@"%d",policy]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraid]];
    cmd=[dealWithCommend addElement:cmd eName:@"password" eData: password];
    cmd=[dealWithCommend addElement:cmd eName:@"repeat" eData:[NSString stringWithFormat:@"%d",repeat]];
    cmd=[dealWithCommend addElement:cmd eName:@"switch" eData:[NSString stringWithFormat:@"%d",recordSwitch]];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userId]];

    
    for (int i = 0; i < 4; i ++) {
        
        TimePeriodSelectData *  timeData = [times objectAtIndex:i];
        NSString * beginTime = [NSString stringWithFormat:@"%d:%d:%d",timeData.beginHour,timeData.beginmin,timeData.beginsec];
        NSString * endTime = [NSString stringWithFormat:@"%d:%d:%d",timeData.overHour,timeData.overmin,timeData.oversec];
        
        NSString * keyBegin = [NSString stringWithFormat:@"begintime%d",i+1];
        NSString * keyEnd = [NSString stringWithFormat:@"endtime%d",i+1];
        NSString * keySwitch = [NSString stringWithFormat:@"switch%d",i+1];
        
        cmd=[dealWithCommend addElement:cmd eName:keyBegin eData:beginTime];
        cmd=[dealWithCommend addElement:cmd eName:keyEnd eData:endTime];
        cmd=[dealWithCommend addElement:cmd eName:keySwitch eData:[NSString stringWithFormat:@"%d",timeData.isOn]];
        
    }
    
    return cmd;
}

+ (NSString *)buildGetRecordConfig:(NSInteger )cameraid password:(NSString* )password userId:(NSInteger)userId{
    NSString * cmd = @"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"GET_RECORD_CONFIG"];
    cmd=[dealWithCommend addElement:cmd eName:@"password" eData: password];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userId]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraid]];
    return cmd;
}

//26.	报警设置
//Xns = XNS_CLIENT
//Cmd = ALARM_CONFIG
//switch = 0 0：不报警
//policy= 0; //报警策略  1：全天报警 2：分段报警
//voicealarm=1;	//声音报警 0:关闭 1：开启
//movealarm=1;// 移动侦测报警 0:关闭 1：开启
//record=1;     //报警是否录像 0：不录像 1：录像
//repeat=1111100;  //重复周期 7位数字分别代表周一到周日，0：不录像 1：录像
//beintime1=00:00:00
//endtime1=00:00:00
//switch1=0        //时段是否有效
//begintime2=00:00:00
//endtime2=00:00:00
//switch2=0        //时段是否有效
//begintime3=00:00:00
//endtime3=00:00:00
//switch3=0        //时段是否有效
//begintime4=00:00:00
//endtime4=00:00:00
//switch4=0        //时段是否有效

+ (NSString *)buildGetAlertConfig:(NSInteger )cameraid userid:(NSInteger )userid{
    NSString * cmd = @"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"GET_ALARM_CONFIG"];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d", userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraid]];
    return cmd;
}

+ (NSString *)buildAlertConfig:(NSInteger)policy cameraid:(NSInteger)cameraid password:(NSString *)password repeat:(NSInteger)repeat beginAndEndTimes:(NSArray *)times voicealarm:(NSInteger)voicealarm movealarm:(NSInteger)movealarm record:(NSInteger)record alertSwitch:(NSInteger)alertSwitch userid:(NSInteger)userid{
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"ALARM_CONFIG"];
    cmd=[dealWithCommend addElement:cmd eName:@"policy" eData:[NSString stringWithFormat:@"%d",policy]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraid]];
    cmd=[dealWithCommend addElement:cmd eName:@"password" eData: password];
    cmd=[dealWithCommend addElement:cmd eName:@"repeat" eData:[NSString stringWithFormat:@"%d",repeat]];
    cmd=[dealWithCommend addElement:cmd eName:@"voicealarm" eData:[NSString stringWithFormat:@"%d",voicealarm]];
    cmd=[dealWithCommend addElement:cmd eName:@"movealarm" eData:[NSString stringWithFormat:@"%d",movealarm]];
    cmd=[dealWithCommend addElement:cmd eName:@"record" eData:[NSString stringWithFormat:@"%d",record]];
    cmd=[dealWithCommend addElement:cmd eName:@"switch" eData:[NSString stringWithFormat:@"%d",alertSwitch]];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    
    for (int i = 0; i < 4; i ++) {
        
        TimePeriodSelectData *  timeData = [times objectAtIndex:i];
        NSString * beginTime = [NSString stringWithFormat:@"%d:%d:%d",timeData.beginHour,timeData.beginmin,timeData.beginsec];
        NSString * endTime = [NSString stringWithFormat:@"%d:%d:%d",timeData.overHour,timeData.overmin,timeData.oversec];
        
        NSString * keyBegin = [NSString stringWithFormat:@"begintime%d",i+1];
        NSString * keyEnd = [NSString stringWithFormat:@"endtime%d",i+1];
        NSString * keySwitch = [NSString stringWithFormat:@"switch%d",i+1];
        
        cmd=[dealWithCommend addElement:cmd eName:keyBegin eData:beginTime];
        cmd=[dealWithCommend addElement:cmd eName:keyEnd eData:endTime];
        cmd=[dealWithCommend addElement:cmd eName:keySwitch eData:[NSString stringWithFormat:@"%d",timeData.isOn]];
        
    }
    
    return cmd;
}


//获取报警事件图片列表
//Xns = XNS_CLIENT
//Cmd = GET_PICTURE_LIST
//userid=0 //
//cameraid= 0;
//pos=0;	//开始位置 一次20个
//

+ (NSString *)buildGetAlertListString:(NSInteger)userid cameraid:(NSInteger)cameraId pos:(NSInteger)pos{
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"GET_PICTURE_LIST"];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraId]];
    cmd=[dealWithCommend addElement:cmd eName:@"pos" eData:[NSString stringWithFormat:@"%d",pos]];
    return cmd;
}

//回复
//<xns=XNS_CAMERA>
//<cmd=PICTURE_LIST_INFO>
//<userid=%d>
//<cameraid=%d>
//<pos=%d>
//<count=%d>
//<file1=%s>
//<file2=%s>
//.....
//<file20=%s>
//
//
//获取录像列表
//Xns = XNS_CLIENT
//Cmd = GET_VIDEO_LIST
//userid=0 //
//cameraid= 0;
//pos=0;	//开始位置 一次20个
//

+ (NSString *)buildGetRecordListString:(NSInteger)userid cameraid:(NSInteger)cameraId pos:(NSInteger)pos{
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"GET_VIDEO_LIST"];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraId]];
    cmd=[dealWithCommend addElement:cmd eName:@"pos" eData:[NSString stringWithFormat:@"%d",pos]];
    return cmd;
}

//回复
//<xns=XNS_CAMERA>
//<cmd=VIDEO_LIST_INFO>
//<userid=%d>
//<cameraid=%d>
//<pos=%d>
//<count=%d> 个数
//<file1=%s>
//<file2=%s>
//.....
//<file20=%s>
//


//获取图片下载路径
//Xns = XNS_CLIENT
//Cmd = DOWNLOAD_PICTURE
//userid=0 //
//cameraid= 0;
//filename=”123.mp4”;	文件名
//

+ (NSString *)buildGetImageDownLoadUrlString:(NSInteger)userid cameraid:(NSInteger)cameraId filename:(NSString *)filename{
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"DOWNLOAD_PICTURE"];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraId]];
    cmd=[dealWithCommend addElement:cmd eName:@"filename" eData:filename];
    return cmd;
}


//<xns=XNS_CAMERA>
//<cmd=DOWNLOAD_PICTURE_RESP>
//<userid=%d>
//<cameraid=%d>
//<loaclurl=%s>   //内网地址
//<proxyurl=%s>   //外网地址


//获取视频下载路径
//Xns = XNS_CLIENT
//Cmd = DOWNLOAD_VIDEO
//userid=0 //
//cameraid= 0;
//filename=”123.mp4”;	文件名
//

+ (NSString *)buildGetVideoDownLoadUrlString:(NSInteger)userid cameraid:(NSInteger)cameraId filename:(NSString *)filename{
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"DOWNLOAD_VIDEO"];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraId]];
    cmd=[dealWithCommend addElement:cmd eName:@"filename" eData:filename];
    return cmd;
}

//<xns=XNS_CAMERA>
//<cmd=DOWNLOAD_VIDEO_RESP>
//<userid=%d>
//<cameraid=%d>
//<loaclurl=%s>   //内网地址
//<proxyurl=%s>   //外网地址
//


//报警
//<xns=XNS_CAMERA>
//<cmd=ALARM_EVENT>
//<userid=%d>
//<cameraid=%d>
//<type=%d>
//<time=%u>
//<piture=%s>
//<bvideo=%d>
//<video=%s>

//9. 删除摄像头
//xns=XNS_CLIENT
//cmd= DELETE_CAMERA
//cameraid=
//userid = 
//xns=XNS_CLIENT
//cmd= DELETE_CAMERA_RESP
//cameraid=
//ret=0 //0：ok 1:error

+ (NSString *)buildDeleteCameraString:(NSInteger)cameraId userid:(NSInteger)userid{
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"DELETE_CAMERA"];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraId]];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    return cmd;
}

+ (NSString *)buildModifyCamera:(CameraInfoData *)cameraInfo cameraName:(NSString *)cameraName cameraMemo:(NSString *)cameraMemo userid:(NSInteger)userid password:(NSString *)passwordStr{
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"MODIFY_CAMERA"];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraInfo.cameraId]];
    cmd=[dealWithCommend addElement:cmd eName:@"sn" eData:cameraInfo.cameraSn];
    cmd=[dealWithCommend addElement:cmd eName:@"password" eData:passwordStr];
    cmd=[dealWithCommend addElement:cmd eName:@"type" eData:[NSString stringWithFormat:@"%d",cameraInfo.type]];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"name" eData:[ToolClass encodeBase64:cameraName]];
    cmd=[dealWithCommend addElement:cmd eName:@"memo" eData:[ToolClass encodeBase64:cameraMemo]];
    return cmd;
}


//CMD: DELETE_PICTURE 参数： filename
//回复：DELETE_PICTURE_RESP 参数： filename  ret: 0 成功
//<cameraid=10><cmd=DELETE_PICTURE_VIDEO_RESP><filename=._11.jpg><fromuid=10><remoteip=58.251.102.204><ret=0><serverid=1791469948><sessionid=4196298163><touid=10><userid=10><xns=XNS_CLIENT>
//
//
//CMD: DELETE_VIDEO 参数： filename
//回复：DELETE_VIDEO_RESP 参数： filename  ret: 0 成功
+ (NSString *)buildDeletePictureFromCamera:(CameraInfoData *)cameraInfo filename:(NSString *)fileName userid:(NSInteger)userid{
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"DELETE_PICTURE"];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraInfo.cameraId]];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"filename" eData:fileName];
    return cmd;
}

+ (NSString *)buildDeleteVideoFromCamera:(CameraInfoData *)cameraInfo filename:(NSString *)fileName userid:(NSInteger)userid{
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"DELETE_VIDEO"];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraInfo.cameraId]];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"filename" eData:fileName];
    return cmd;
}


//CCmdPacket rCmdPacket("XNS_CLIENT","SPEAKER_SWITCH",0,0);
//rCmdPacket.PutAttribUL("userid",m_ulUserID);
//rCmdPacket.PutAttribUL("cameraid", rWatchCamera.ulCameraID);
//rCmdPacket.PutAttrib("password", rWatchCamera.strPassword);
//rCmdPacket.PutAttrib("mcuip",rWatchCamera.strMcuIp);
//rCmdPacket.PutAttribUS("mcuport",rWatchCamera.usMcuPort);
//rCmdPacket.PutAttribUL("channelid", rWatchCamera.ulChannelID);
//rCmdPacket.PutAttribUL("switch", rWatchCamera.ucSpeakerSwitch);

+ (NSString *)buildCameraSwitchSpeaker:(CameraInfoData *)cameraInfo mcuip:(NSString *)mcuIp mcuPort:(NSInteger)port userid:(NSInteger)userid flagswitch:(NSInteger)flagSwitch{
    
    NSString *cmd=@"";
    
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"SPEAKER_SWITCH"];
    cmd=[dealWithCommend addElement:cmd eName:@"password" eData:cameraInfo.password];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraInfo.cameraId]];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"mcuip" eData:mcuIp];
    cmd=[dealWithCommend addElement:cmd eName:@"mcuport" eData:[NSString stringWithFormat:@"%d",port]];
    cmd=[dealWithCommend addElement:cmd eName:@"switch" eData:[NSString stringWithFormat:@"%d",flagSwitch]];
    
    return cmd;
}

//10. 修改密码
//xns=XNS_CLIENT
//cmd= MODIFY_PWD
//userid=
//oldpassword=
//newpassword=
//
//xns=XNS_CLIENT
//cmd= MODIFY_PWD_RESP
//userid=
//ret=0 //0:成功 1：失败
+ (NSString *)buildModifyAccountPassword:(NSString *)newpassword oldpassword:(NSString *)oldpassword userid:(NSInteger)userid{
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"MODIFY_PWD"];
    cmd=[dealWithCommend addElement:cmd eName:@"oldpassword" eData:[MyMD5 md5:oldpassword]];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"newpassword" eData:[MyMD5 md5:newpassword]];
    return cmd;
}


//videosize= //0:QQVGA 160*120 1：QCIF 176*144  2: QVG:320*240 3:CIF352*288 4:VGA640*480 5:720*480 6:720P 7:1080P
//录像:
//<videosize=0><cmd=MODIFY_RECORD_VIDEO_QUALITY>
//视频:
//<videosize=0><cmd=MODIFY_LIVE_VIDEO_QUALITY>

+ (NSString *)buildApModifyVideoSizeWithSize:(NSInteger)videoSize userid:(NSInteger)userid cameraid:(NSInteger)cameraid{
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"MODIFY_LIVE_VIDEO_QUALITY"];
    cmd=[dealWithCommend addElement:cmd eName:@"videosize" eData:[NSString stringWithFormat:@"%d",videoSize]];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraid]];
    return cmd;
}

//videosize= //0:QQVGA 160*120 1：QCIF 176*144  2: QVG:320*240 3:CIF352*288 4:VGA640*480 5:720*480 6:720P 7:1080P
// 获取实时视频分辨率请求: <cmd=GET_LIVE_VIDEO_SIZE_QUALITY>
// 获取实时视频分辨率返回: <cmd=GET_LIVE_VIDEO_SIZE_QUALITY_RSP><videosize=0>

// 获取录像视频分辨率请求: <cmd=GET_RECORD_VIDEO_SIZE_QUALITY>
// 获取录像视频分辨率返回: <cmd=GET_RECORD_VIDEO_SIZE_QUALITY_RSP><videosize=0>

+ (NSString *)buildGetLiveVideoSize:(NSInteger)userid cameraid:(NSInteger)cameraid{
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"GET_LIVE_VIDEO_SIZE_QUALITY"];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraid]];
    return cmd;
}

//videosize= //1:  2：  3:

+ (NSString *)buildModifyRecordQualityWithSize:(NSInteger)videoSize userid:(NSInteger)userid cameraid:(NSInteger)cameraid{
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"MODIFY_RECORD_VIDEO_QUALITY"];
    cmd=[dealWithCommend addElement:cmd eName:@"videosize" eData:[NSString stringWithFormat:@"%d",videoSize]];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraid]];
    return cmd;
}

+ (NSString *)buildGetRecordVideoSize:(NSInteger)userid cameraid:(NSInteger)cameraid{
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"GET_RECORD_VIDEO_SIZE_QUALITY"];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraid]];
    return cmd;
}

+ (NSString *)buildSetCameraTimeZone{
    
//    NSDate *date = [NSDate date];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
//    NSInteger time = (NSInteger)[localeDate timeIntervalSince1970];
    
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date]/3600;
    
    NSInteger time = [date timeIntervalSince1970];
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"SET_CAMERA_TIME_ZONE"];
    cmd=[dealWithCommend addElement:cmd eName:@"timezone" eData:[NSString stringWithFormat:@"%d",interval]];
    cmd=[dealWithCommend addElement:cmd eName:@"time" eData:[NSString stringWithFormat:@"%d",time]];
    return cmd;

}

//<xns=XNS_CAMERA><cmd=USER_PROVEN><userid=%d><cameraid=%d><password=%s>
//<xns=XNS_CAMERA><cmd=USER_PROVEN_RESP><userid=%d><cameraid=%d><ret=%d>

+ (NSString *)buildUserProven:(NSString *)password userid:(NSInteger)userid cameraid:(NSInteger)cameraid{
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"USER_PROVEN"];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"password" eData:password];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraid]];
    
    return cmd;
}

//<userid=223><cmd=CALL_MASTER_RESP><ret=0> ret=0: 接听 1：拒绝
+ (NSString *)buildCallingRespone:(NSInteger)userid cameraid:(NSInteger)cameraid ret:(NSInteger)ret{
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"CALL_MASTER_RESP"];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"ret" eData:[NSString stringWithFormat:@"%d",ret]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraid]];

    return cmd;
}

//增加手动更新功能，在设置-->摄像头信息 里面增加一个摄像头软件版本和更新功能
//客户端发送
//<xns=XNS_CAMERA><cmd=GET_CAMERA_VERSION><userid=%d><cameraid=%d>获取摄像头程序版本
//<xns=XNS_CAMERA><cmd=GET_CAMERA_VERSION_RESP><userid=%d><cameraid=%d><version=%s><newversion=%s><downloadurl=%s><versioninfo=%s>
//newversion：程序的最新版本
//versioninfo：程序的当前版本
//downloadurl：程序的下载路径
//versioninfo：版本的更新信息
//
+ (NSString *)buildGetCameraVersion:(NSInteger)userid cameraid:(NSInteger)cameraid{
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"GET_CAMERA_VERSION"];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraid]];
    
    return cmd;
}


//如果版本不同，用户按下更新按钮
//发送<xns=XNS_CAMERA><cmd=UPDATE_CAMERA><cameraid=%d><downloadurl=%s> downloadurl 就是get_version_resp里面的downloadurl

+ (NSString *)buildUpdateCameraVersion:(NSString *)downloadurl cameraid:(NSInteger)cameraid userid:(NSInteger)userid{
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"UPDATE_CAMERA"];
    cmd=[dealWithCommend addElement:cmd eName:@"downloadurl" eData:downloadurl];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraid]];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    
    return cmd;
}

//获取摄像头的快照
//<xns=XNS_CLIENT><cmd=GET_CAMERA_SNAP><userid=%d><cameraid=%d>
//摄像头回复
//<xns=XNS_CAMERA><cmd=GET_CAMERA_SNAP_RESP><userid=%d><cameraid=%d><loaclurl=%s><proxyurl=%s>


+ (NSString *)buildDownCameraGridImage:(NSInteger)userid cameraid:(NSInteger)cameraid password:(NSString *)password{
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"GET_CAMERA_SNAP"];
    cmd=[dealWithCommend addElement:cmd eName:@"password" eData:password];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraid]];
    
    return cmd;
}


//在云模式和P2P模式下在查看视频的时候增加 MANUAL_SNAP 拍照 和 录像 MANUAL_RECORD 命令，switch=1 开始录像 switch=0 停止录像，

+ (NSString *)buildTakePhotoStr:(NSInteger )userid cameraid:(NSInteger)cameraid{
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"MANUAL_SNAP"];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraid]];
    return cmd;
}

+ (NSString *)buildStartTakeVideoStrWithFlag:(NSInteger )userid cameraid:(NSInteger)cameraid swithFlag:(NSInteger)swithFlag{
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"MANUAL_RECORD"];
    cmd=[dealWithCommend addElement:cmd eName:@"switch" eData:[NSString stringWithFormat:@"%d",swithFlag]];//switch= //0: 关闭 1打开
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraid]];
    return cmd;
}


//camerid         
//userid          
//生成时间UTC      
//有效时间（分钟）   
//验证方式         
//共享名称         
//访问密码         
//Access key
//<cameraid=123><userid=234><utc=13525455645><validity=0><type=0><sharename=test><pwd=12345678><accesskey=sadfsadhfsjadsjfhsjdf==>
//<cameraid=258><userid=467><utc=1389775589><validity=0><shareName=anycam><type=0><pwd=><accesskey=>
//<cameraid=258><cmd=USER_PROVEN_RESP><fromuid=258><ret=0><sessionid=3908603155><touid=467><userid=467><xns=XNS_CLIENT>
+ (NSString *)shareUrlToken:(NSInteger)cameraid userid:(NSInteger)userid  validity:(NSInteger)validity type:(NSInteger)type shareName:(NSString *)shareName password:(NSString *)password accessKey:(NSString *)accessKey{
    
    NSInteger startTime = [[NSDate date] timeIntervalSince1970];
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraid]];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"utc" eData:[NSString stringWithFormat:@"%d",startTime]];
    cmd=[dealWithCommend addElement:cmd eName:@"validity" eData:[NSString stringWithFormat:@"%d",validity]];
    cmd=[dealWithCommend addElement:cmd eName:@"shareName" eData:shareName];
    cmd=[dealWithCommend addElement:cmd eName:@"type" eData:[NSString stringWithFormat:@"%d",type]];
    cmd=[dealWithCommend addElement:cmd eName:@"pwd" eData:password];
    cmd=[dealWithCommend addElement:cmd eName:@"accesskey" eData:accessKey];
    DebugLog(@"token %@",cmd);
    
    
    NSData * test = [NSData dataWithBytes:[cmd UTF8String] length:[cmd length]];
    NSData * data = [test AES128EncryptWithKey:KPUBLICKEY];
    data = [GTMBase64 encodeData:data];
    NSString * base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease];
    
    cmd = [NSString stringWithFormat:@"%@%@",KSHARE_URL,base64String];

    return cmd;

}


//视频分享时"<xns=XNS_CLIENT><cmd=SHARE_CAMERA><switch=?><password=?>");
//<xns=XNS_CLIENT><cmd=SHARE_CAMERA><password=><switch=1><userid=467><cameraid=258>
//switch = 0 不共享，1 共享 ，password 是共享密码，可以为空

+ (NSString *)buildOpenShareCameraStr:(NSInteger)cameraid userid:(NSInteger)userid swithFlag:(NSInteger)swithFlag passwrod:(NSString *)password{
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"SHARE_CAMERA"];
    cmd=[dealWithCommend addElement:cmd eName:@"password" eData:password];
    cmd=[dealWithCommend addElement:cmd eName:@"switch" eData:[NSString stringWithFormat:@"%d",swithFlag]];//switch= //0: 关闭 1打开
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraid]];
    return cmd;
}

//WATCH_CAMERA_TCP
//<xns=XNS_CAMERA><cmd=WATCH_CAMERA_TCP_RESP><serverip=%s><serverport=%s><userid=%s><cameraid=%d><ret=%d>
//REBOOT_CAMERA

+ (NSString *)buildRestartCameraStr:(NSInteger)cameraid userid:(NSInteger)userid{
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"REBOOT_CAMERA"];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraid]];
    return cmd;
}

//<cmd=SET_VIDEO_ROTATE><vflip=0>  0:不旋转 1：旋转
//<cmd=SET_VIDEO_ROTAT_RESP><ret=0> 0:成功 1：不成功

+ (NSString *)buildRotateCameraStr:(NSInteger)cameraid userid:(NSInteger)userid vflip:(NSInteger)vflip{
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"SET_VIDEO_ROTATE"];
    cmd=[dealWithCommend addElement:cmd eName:@"vflip" eData:[NSString stringWithFormat:@"%d",vflip]];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraid]];
    return cmd;
    
}


//云台控制指令
//客户端发送：
//<xns=XNS_CLIENT><cmd=MODIFY_CAMERA_PTZ><userid=%d><cameraid=%d><direction=%d><step=%d>
//direction：方向 1：上 2：下 3：左 4：右
//step：步长（角度） 8的倍数 （具体取值根据实际测试调整）
//摄像头返回：
//<xns=XNS_CAMERA><cmd=MODIFY_CAMERA_PTZ_RESP><userid=%d><cameraid=%d><ret=%d><direction=%d><step=%d>
//ret：结果 0：成功 1：失败
//direction：客户端发过来的值
//step：客户端发过来的值

+ (NSString *)buildPTZCameraStr:(NSInteger)cameraid userid:(NSInteger)userid direction:(NSInteger)direction step:(NSInteger)step{
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"SET_VIDEO_ROTATE"];
    cmd=[dealWithCommend addElement:cmd eName:@"direction" eData:[NSString stringWithFormat:@"%d",direction]];
    cmd=[dealWithCommend addElement:cmd eName:@"step" eData:[NSString stringWithFormat:@"%d",step]];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",userid]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",cameraid]];
    return cmd;
    
}

//<xns=XNS_CLIENT><cmd=GET_PWD><account=%s>
//<xns=XNS_CLIENT><cmd=GET_PWD_RESP><account=%s><ret=%d>
//ret = 0 :修改成功 1：用户不存在

+ (NSString *)buildGetPwdStr:(NSString *)account{
    
    NSString *cmd=@"";
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:@"GET_PWD"];
    cmd=[dealWithCommend addElement:cmd eName:@"account" eData:account];

    return cmd;
}

@end
