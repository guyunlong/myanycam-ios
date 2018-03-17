//
//  MusicPlayEngine.h
//  Myanycam
//
//  Created by myanycam on 13/10/28.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>



@interface MusicPlayEngine : NSObject<AVAudioPlayerDelegate>{

    NSMutableArray             *_players;
    NSString                    *_soundName;
    
    ASIHTTPRequest              *_request;
    AVAudioPlayer               *_repeatPlayer;
}

@property (nonatomic, retain) AVAudioPlayer                     *repeatPlayer;
@property (nonatomic, retain) NSMutableArray                   *players;
@property (nonatomic, retain) ASIHTTPRequest                    *request;
@property (nonatomic, retain) NSString                          *soundName;

+ (id)sharedMusicPlayerEngine;


- (void)playSoundEffect:(SoundEffect)type;
- (void)playSoundEffectWithName:(NSString *)soundName;
- (void)playSoundEffect:(SoundEffect)type repeat:(BOOL)repeat;
- (void)stopRepeatPlay;
- (BOOL)silenced;

@end
