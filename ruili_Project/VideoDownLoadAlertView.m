//
//  VideoDownLoadAlertView.m
//  Myanycam
//
//  Created by myanycam on 13/10/14.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "VideoDownLoadAlertView.h"
#import "MYDataManager.h"

@implementation VideoDownLoadAlertView
@synthesize downloadFilePath;
@synthesize fileRequest;
@synthesize cameraInfo;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)downloadVideo:(NSString *)videoUrl cellData:(EventAlertTableViewCellData *)cellData cameraInfo:(CameraInfoData *)camerainfo{
    
    DebugLog(@"创建请求 %@", [[videoUrl pathComponents] lastObject]);
    self.cameraInfo = camerainfo;

    self.fileNameLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"Video File", nil),cellData.formatEventTime];
    NSString * fileName = [[videoUrl pathComponents] lastObject];
    
    NSString * pathname = [NSString stringWithFormat:@"%@",fileName];
    
    fileName = [NSString stringWithFormat:@"%@_%@",self.cameraInfo.cameraSn,fileName];
    
    //初始化Documents路径
    NSString *  path = [[MYDataManager shareManager] getVideoFilePath:Kdownloadvideos];
    NSString *  pathtemp = [[MYDataManager shareManager] getVideoFileTempPath];
    
    NSString *  downloadPath = [path stringByAppendingPathComponent:fileName];
    NSString *  tempPath = [pathtemp stringByAppendingPathComponent:fileName];
    
    NSURL *url = [NSURL URLWithString:videoUrl];
    DebugLog(@"url %@",url);
    //创建请求
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    self.fileRequest = request;
    request.userInfo = [NSDictionary dictionaryWithObject:pathname forKey:KVIDEONAME];
    request.delegate = self;//代理
    [request setDownloadDestinationPath:downloadPath];//下载路径
    self.downloadFilePath = downloadPath;
    [request setTemporaryFileDownloadPath:tempPath];//缓存路径
    [request setAllowResumeForFileDownloads:YES];//断点续传
    request.downloadProgressDelegate = self;//下载进度代理
    [[MYDataManager shareManager].downLoadQueue addOperation:request];//添加到队列，队列启动后不需重新启动
    
    self.progressButton.userInteractionEnabled = NO;
    
}



- (void)requestStarted:(ASIHTTPRequest *)request{
    
    
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    
//    DebugLog(@"responseHeaders %@",responseHeaders);
    
}

- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL{
    
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    
}

- (void)requestRedirected:(ASIHTTPRequest *)request{
    
}

- (void)setProgress:(float)newProgress{
    
    DebugLog(@"newProgress %f",newProgress);
    self.downFileProgress.progress = newProgress;
    int prgress = (int)(100 * newProgress);

    NSString * progressStr =  [NSString stringWithFormat:@"%@: %d%%",NSLocalizedString(@"progress", nil),prgress];
    [self.progressButton setTitle:progressStr forState:UIControlStateNormal];
    if (newProgress >= 1) {
        
         [self.progressButton setTitle:NSLocalizedString(@"Save to Photos", nil) forState:UIControlStateNormal];
        UISaveVideoAtPathToSavedPhotosAlbum(self.downloadFilePath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    [self.progressButton setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    self.progressButton.userInteractionEnabled = YES;
    
    NSString * fileName = [[self.downloadFilePath pathComponents] lastObject];
    [[MYDataManager shareManager] addDownloadFileName:fileName];

}
// Called when the request receives some data - bytes is the length of that data
- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes{
    
    DebugLog(@"bytes %lld",bytes);
}


- (void)dealloc {
    
    self.downloadFilePath = nil;
    self.cameraInfo = nil;
    [_cancelButton release];
    [_downFileProgress release];
    [_fileNameLabel release];
    [_progressLabel release];
    [_progressButton release];
    [super dealloc];
}
- (IBAction)cancelButtonAction:(id)sender {
    
    [self.fileRequest setDelegate:nil];
    [self.fileRequest setDownloadProgressDelegate:nil];
    self.fileRequest = nil;
    
    if (self.baseDelegate && [self.baseDelegate respondsToSelector:@selector(alertView:clickButtonAtIndex:)]) {
        
        [self.baseDelegate alertView:self clickButtonAtIndex:0];
    }
    
    [self hide];
}

- (IBAction)progressButtonAction:(id)sender {
    
    [self cancelButtonAction:nil];
}
@end
