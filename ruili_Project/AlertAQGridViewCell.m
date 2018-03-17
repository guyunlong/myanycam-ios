//
//  AlertAQGridViewCell.m
//  Myanycam
//
//  Created by myanycam on 13-5-20.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "AlertAQGridViewCell.h"
#import "MYDataManager.h"
#import "MYGestureRecognizer.h"

@implementation AlertAQGridViewCell
@synthesize cameraData = _cameraData;
@synthesize name;
@synthesize nameLabel;
@synthesize cameraStateLabel;
@synthesize imageView;
@synthesize deleteImageView;
@synthesize eventNumberView;
@synthesize hadwatched;
@synthesize upgradeImageView;
@synthesize cameraStateImageView;


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationCameraInfoAlertEvent object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationCellNeedWobble object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationDownCameraGridImage object:nil];

    self.cameraData = nil;
    self.imageView = nil;
    self.nameLabel = nil;
    self.cameraStateLabel = nil;
    self.cameraStateImageView = nil;
    self.name = nil;
    self.eventNumberView = nil;
    self.deleteImageView = nil;
    self.upgradeImageView = nil;
    self.hadwatched = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)updateCameraGridImage:(NSNotification *)notify{
    
    NSString * fileName = [[MYDataManager shareManager] getFilePathAtUserIDPath:KCameraGridImagePath];
    fileName = [fileName stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg",self.cameraData.cameraId]];
    UIImage * image = [UIImage imageWithContentsOfFile:fileName];
    
    if (image) {
        
        if (self.cameraData.flagLock) {
            
            self.imageView.image = [UIImage imageNamed:@"img4.png"];
        }
        else
        {
            self.imageView.image = image;
        }
    }
    
    
    if (notify.object) {
        
        NSNumber * number = (NSNumber *)notify.object;
        if ([number intValue] == self.cameraData.cameraId) {
            
            if (self.cameraData.flagLock) {
                
                self.imageView.image = [UIImage imageNamed:@"img4.png"];
            }
            else
            {
                self.imageView.image = [UIImage imageNamed:@"img5.png"];
                if (image) {
                    
                    [ToolClass deleteFileWithPath:fileName];
                }
                
            }
        }
    }
    
}

- (id) initWithFrame:(CGRect)frame reuseIdentifier: (NSString *) reuseIdentifier {
    
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAlertEventNumberView) name:kNotificationCameraInfoAlertEvent object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNeedWobble) name:kNotificationCellNeedWobble object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCameraGridImage:) name:KNotificationDownCameraGridImage object:nil];
        
//        320, 221
        CGSize size = self.contentView.frame.size;
        self.contentView.backgroundColor = [UIColor colorWithRed:34/255.0 green:30/255.0 blue:31/255.0 alpha:1.0];
        UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake((size.width - 294)/2, 6, 294, 169)];
        imageV.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:84/255.0 green:96/255.0 blue:110/255.0 alpha:1.0];
        [self.contentView addSubview:imageV];
        [imageV release];
        
        imageV = [[UIImageView alloc] initWithFrame:CGRectMake((size.width - 286)/2, 10, 286, 161)];
        imageV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:imageV];
        self.imageView = imageV;
        [imageV release];
        
        imageV = [[UIImageView alloc] initWithFrame:CGRectMake(6, 0, 30, 30)];
        imageV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:imageV];
        self.deleteImageView = imageV;
        self.deleteImageView.hidden = YES;
        self.deleteImageView.userInteractionEnabled = YES;
        imageV.image = [UIImage imageNamed:@"deleteCell.png"];
        [imageV release];
        
        imageV = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 40), frame.size.height - 60, 25, 25)];
        imageV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:imageV];
        self.upgradeImageView = imageV;
        self.upgradeImageView.hidden = YES;
        imageV.image = [UIImage imageNamed:@"升级icon.png"];
        [imageV release];
        
        self.selectionGlowColor = [UIColor clearColor];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
        self.imageView.image = [UIImage imageNamed:@"img5.png"];
        
//        imageV = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 320)/2, 199, 320, 35)];
//        imageV.backgroundColor = [UIColor clearColor];
//        imageV.image = [UIImage imageNamed:@"名称栏s.png"];
//        [self.contentView addSubview:imageV];
//        [imageV release];
        
        //摄像头名字
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake((size.width - 286)/2, frame.size.height-34, 100, 20)];
        [self.contentView addSubview:label];
        label.textAlignment = UITextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];
        [label setFont:[UIFont systemFontOfSize:14]];//24 115 207
        label.textColor = [UIColor whiteColor];//[UIColor colorWithRed:24/255.0 green:115/255.0 blue:207/255.0 alpha:1.0];//83 168 219
        self.nameLabel = label;
        self.nameLabel.font =  [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [label release];
        
        //在线 离线 状态
        imageV = [[UIImageView alloc] initWithFrame:CGRectMake(165, frame.size.height-36, 24, 24)];
        imageV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:imageV];
        imageV.image = [UIImage imageNamed:@"icon2.png"];
        self.cameraStateImageView = imageV;
        [imageV release];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(192, frame.size.height-34, 50, 20)];
        [self.contentView addSubview:label];
        label.textAlignment = UITextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];
        [label setFont:[UIFont systemFontOfSize:14]];
        self.cameraStateLabel = label;
        self.cameraStateLabel.textColor = [UIColor whiteColor];
        self.cameraStateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [label release];
        
        MKNumberBadgeView * badgeView = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(frame.size.width - 40, 0, 40, 40)];
        self.eventNumberView = badgeView;
        [self.contentView addSubview:badgeView];
        [badgeView release];
        self.eventNumberView.hideWhenZero = YES;
        
        //查看
        imageV = [[UIImageView alloc] initWithFrame:CGRectMake(240, frame.size.height-36, 24, 24)];
        imageV.backgroundColor = [UIColor clearColor];
        imageV.image = [UIImage imageNamed:@"icon1.png"];
        self.hadwatched = imageV;
        [self.contentView addSubview:imageV];
        [imageV release];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(266, frame.size.height-34, 50, 20)];
        label.textAlignment = UITextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        label.text = NSLocalizedString(@"Watch", nil);
        label.textColor = [UIColor whiteColor];
        [self.contentView addSubview:label];
        [label release];
        
        //底线
        imageV = [[UIImageView alloc] initWithFrame:CGRectMake((size.width - 294)/2, size.height-1, 294, 1)];
        imageV.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        [self.contentView addSubview:imageV];
        [imageV release];
        
    }
    
    return self;
}

- (void)addAlertEventNumberView{

    if (self.cameraData.status == -1) {
        return;
    }
    
    NSNumber * cameraID = [NSNumber numberWithInt:self.cameraData.cameraId];
    NSInteger alarmCount = [[[MYDataManager shareManager].alertNumberDict objectForKey:cameraID] intValue];
    self.eventNumberView.value = alarmCount;
}

- (void)checkNeedWobble{
    
    if ([MYDataManager shareManager].flagNeedToWobble) {
        
        [self BeginWobble];
    }
    else
    {
        [self EndWobble];
    }
}

-(void)BeginWobble
{
    self.deleteImageView.hidden = NO;
    
//    NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
//
//    srand([[NSDate date] timeIntervalSince1970]);
//
//    float rand=(float)random();
//    
//    CFTimeInterval t = rand*0.0000000001;
//    
//    [UIView animateWithDuration:0.1 delay:t options:0  animations:^
//     {
//         self.transform=CGAffineTransformMakeRotation(-0.05);
//     }
//    completion:^(BOOL finished)
//     {
//         [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^ {
//              self.transform=CGAffineTransformMakeRotation(0.05);
//          }
//            completion:^(BOOL finished){
//          
//          }];
//     }];
//    
//    [pool release];
    
}

-(void)EndWobble
{
//    NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
//    
//        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^
//         {
//             self.transform=CGAffineTransformIdentity;
//             
//         } completion:^(BOOL finished) {
//             
//         }];
//    
//    [pool release];
    
    self.deleteImageView.hidden = YES;
}

- (void)setCameraData:(CameraInfoData *)cameraData{
    
    if (_cameraData != cameraData) {
        
//        [_cameraData removeObserver:self forKeyPath:@"status"];
         [_cameraData removeObserver:self forKeyPath:@"cameraName"];
        
        [_cameraData release];
        _cameraData = [cameraData retain];
    }
    if (cameraData) {
        
        self.upgradeImageView.hidden = YES;
        self.nameLabel.text = self.cameraData.cameraName;
        self.hadwatched.image  = [UIImage imageNamed:@"icon1.png"];
        
        
        NSString * fileName = [[MYDataManager shareManager] getFilePathAtUserIDPath:KCameraGridImagePath];
        fileName = [fileName stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg",self.cameraData.cameraId]];
        UIImage * image = [UIImage imageWithContentsOfFile:fileName];
        if (image) {
            
            self.imageView.image = image;
        }
        else
        {
            self.imageView.image = [UIImage imageNamed:@"img5.png"];
        }
        
        
        self.upgradeImageView.hidden = YES;
        self.cameraStateLabel.hidden = NO;
        
        if (self.cameraData.status == CameraStateOnline) {
            
            NSNumber * cameraID = [NSNumber numberWithInt:self.cameraData.cameraId];
            NSInteger alarmCount = [[[MYDataManager shareManager].alertNumberDict objectForKey:cameraID] intValue];
            self.eventNumberView.value = alarmCount;
            self.cameraStateLabel.text = NSLocalizedString(@"Online", nil);
//            self.cameraStateLabel.textColor = [UIColor colorWithRed:24/255.0 green:115/255.0 blue:207/255.0 alpha:1.0];//20  122   182
            self.cameraStateImageView.image = [UIImage imageNamed:@"icon2.png"];
            
        }
        else{
            
            self.cameraStateLabel.text = NSLocalizedString(@"Offline", nil);
//            self.cameraStateLabel.textColor = [UIColor colorWithRed:157/255.0 green:158/255.0 blue:158/255.0 alpha:1.0];//157 158  158
            self.cameraStateImageView.image = [UIImage imageNamed:@"icon3.png"];
        }
        
        if (cameraData.status == CameraStateHadWatch) {
            
            self.cameraStateLabel.text = NSLocalizedString(@"Online", nil);
            self.cameraStateImageView.image = [UIImage imageNamed:@"icon2.png"];
//            self.cameraStateLabel.textColor = [UIColor colorWithRed:24/255.0 green:115/255.0 blue:207/255.0 alpha:1.0];//83 168 219
            self.hadwatched.image  = [UIImage imageNamed:@"icon1_1.png"];
            
        }
        
        if (cameraData.status == CameraStateUpdate) {
            
            self.cameraStateLabel.text = NSLocalizedString(@"Updating", nil);
            self.cameraStateLabel.textColor = [UIColor redColor];
            self.upgradeImageView.hidden = NO;
        }
        
        if (self.cameraData.status == -1)
        {
            
            self.imageView.image = [UIImage imageNamed:@"添加图标.png"];
            self.nameLabel.text = @"Add";
            self.hadwatched.image  = [UIImage imageNamed:@"icon1.png"];
            self.cameraStateLabel.hidden = YES;
        }
        
        NSNumber * cameraID = [NSNumber numberWithInt:self.cameraData.cameraId];
        self.eventNumberView.value = [[[MYDataManager shareManager].alertNumberDict objectForKey:cameraID] intValue];
        [cameraData addObserver:self forKeyPath:@"cameraName" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];        
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"cameraName"]) {
        
        self.nameLabel.text = self.cameraData.cameraName;
    }
}


@end
