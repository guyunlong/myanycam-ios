//
//  MusicPlayEngine.m
//  Myanycam
//
//  Created by myanycam on 13/10/28.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "MusicPlayEngine.h"
#import "MYDataManager.h"

static MusicPlayEngine *sharedMusicPlayerEngine = nil;


@implementation MusicPlayEngine

@synthesize repeatPlayer = _repeatPlayer;

- (void)dealloc {
    self.soundName = nil;
    [self.request clearDelegatesAndCancel];
    self.request = nil;
    for (AVAudioPlayer *player in self.players) {
        [player stop];
        [player setDelegate:nil];
    }
    self.players = nil;
    [self.repeatPlayer stop];
    [self.repeatPlayer setDelegate:nil];
    self.repeatPlayer = nil;
    [super dealloc];
}


+ (void)initialize
{
    if (sharedMusicPlayerEngine == nil)
        sharedMusicPlayerEngine = [[self alloc] init];
}


+ (id)sharedMusicPlayerEngine
{
    //Already set by +initialize.
    return sharedMusicPlayerEngine;
}

+ (id)allocWithZone:(NSZone*)zone
{
    //Usually already set by +initialize.
    @synchronized(self) {
        if (sharedMusicPlayerEngine) {
            //The caller expects to receive a new object, so implicitly retain it
            //to balance out the eventual release message.
            return [sharedMusicPlayerEngine retain];
        } else {
            //When not already set, +initialize is our caller.
            //It's creating the shared instance, let this go through.
            return [super allocWithZone:zone];
        }
    }
}


- (id)init
{
    //If sharedInstance is nil, +initialize is our caller, so initialize the instance.
    //If it is not nil, simply return the instance without re-initializing it.
    if (sharedMusicPlayerEngine == nil) {
        if ((self = [super init])) {
            //Initialize the instance here.
            AVAudioSession *session = [AVAudioSession sharedInstance];
            NSError *error = nil;
            [session setCategory:AVAudioSessionCategoryAmbient error:&error];
            self.players = [NSMutableArray array];
        }
    }
    return self;
}

- (id)copyWithZone:(NSZone*)zone
{
    return self;
}
- (id)retain
{
    return self;
}
- (unsigned)retainCount
{
    return UINT_MAX; // denotes an object that cannot be released
}
- (oneway void)release
{
    // do nothing
}

- (id)autorelease
{
    return self;
}


- (NSString *)filePathForImageInDocumentsNamed:(NSString *)imageName {
    
    NSString *docPath = [ToolClass documentDirectoryPath];
    NSString *imageFolder = [docPath stringByAppendingPathComponent:@"images"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:imageFolder]) {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:imageFolder withIntermediateDirectories:YES attributes:nil error:&error];
    }
    NSString *filePath = [imageFolder stringByAppendingPathComponent:imageName];
    return filePath;
}

//
//- (NSString *)urlForSoundName:(NSString *)soundName {
//    
//    return [NSString stringWithFormat:@"%@/%@", RES_SOUND_ROOT,soundName];
//}

- (void)loadSoundWithName:(NSString *)soundName {
    if (!soundName || [soundName length]<=0) {
        return;
    }
    
    if (self.request && !self.request.complete) {
        return;
    }
    
    self.soundName = soundName;
//    NSString *soundURL = [self urlForSoundName:soundName];
//    self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:soundURL]];
//    self.request.delegate = self;
//    [self.request setTimeOutSeconds:60];
//    [self.request setDidFinishSelector:@selector(requestFinished:)];
//    [self.request startAsynchronous];
    
}

- (void)playSoundEffect:(SoundEffect)type {
    
    if (![self silenced]) {
        
        if (SoundEffectNone != type) {
            NSDictionary *effectDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SoundEffect" ofType:@"plist"]];
            NSString *name = [effectDict objectForKey:[NSString stringWithFormat:@"%d", type]];
            if (!name) {
                return;
            }
            NSURL *url = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:name ofType:@"m4a"]];
            NSError *error = nil;
            
            AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            if (player) {
                [self.players addObject:player];
            }
            [player setDelegate:self];
            [player play];
            [player release];
        }
    }
}

- (void)playSoundEffect:(SoundEffect)type repeat:(BOOL)repeat{
    
    if (![self silenced]) {
        
        if (SoundEffectNone != type) {
            NSDictionary *effectDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SoundEffect" ofType:@"plist"]];
            NSString *name = [effectDict objectForKey:[NSString stringWithFormat:@"%d", type]];
            
            NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:@"mp3"]];
            NSError *error = nil;
            
            AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            if (player) {
                
                if (repeat == YES) {
                    [player setNumberOfLoops:-1];
                    self.repeatPlayer = player;
                }
                else {
                    [self.players addObject:player];
                }
            }
            
            [player setDelegate:self];
            BOOL flag = [player play];
            DebugLog(@"flag %d",flag?1:0);
            [player release];
        }
    }
}

- (void)playSoundEffectWithName:(NSString *)soundName {
    
    if (![self silenced]) {
        
        if (!soundName || [soundName length]<=0) {
            return;
        }
        
        NSArray *names = [soundName componentsSeparatedByString:@"."];
        NSString *newSound = nil;
        if ([names count] > 1) {
            newSound = [NSString stringWithFormat:@"%@.m4a", [names objectAtIndex:0]];
        }
        
        NSString *path = [[NSBundle mainBundle] pathForResource:newSound ofType:nil];
        if (!path) {
            path = [self filePathForImageInDocumentsNamed:newSound];
        }
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSURL *url = [NSURL URLWithString:path];
            NSError *error = nil;
            AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            if (player) {
                [self.players addObject:player];
            }
            [player setDelegate:self];
            [player play];
            [player release];
        }
        else {
            [self loadSoundWithName:newSound];
        }
    }
}

- (void)removePlayersDelay:(AVAudioPlayer *)player {
    
    if ([self.players containsObject:player]) {
        [player setDelegate:nil];
        [self.players removeObject:player];
    }
}

#pragma mark - AudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    [self performSelector:@selector(removePlayersDelay:) withObject:player afterDelay:0.1f];
}

#pragma makr - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    if (request.responseStatusCode == 200) {
        if (request.contentLength == [request.responseData length]) {
            if (request.responseData) {
                [request.responseData writeToFile:[self filePathForImageInDocumentsNamed:self.soundName] atomically:YES];
            }
        }
    }
}
- (void)stopRepeatPlay{
    
    [self.repeatPlayer stop];
    [self.repeatPlayer setDelegate:nil];
    self.repeatPlayer = nil;
}

-(BOOL)silenced
{
    
#if TARGET_IPHONE_SIMULATOR
    // return NO in simulator. Code causes crashes for some reason.
    return NO;
#endif
    
    CFStringRef state;
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &state);
    if(CFStringGetLength(state) > 0)
        return NO;
    else
        return YES;
}

@end
