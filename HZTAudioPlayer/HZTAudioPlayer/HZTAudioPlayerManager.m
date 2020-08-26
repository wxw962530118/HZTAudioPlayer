//
//  HZTAudioPlayerManager.m
//  HZTAudioPlayer
//
//  Created by wangxw on 2020/8/26.
//  Copyright © 2020 wangxw. All rights reserved.
//

#import "HZTAudioPlayerManager.h"
@interface HZTAudioPlayerManager ()
/***/
@property (nonatomic, strong) FSAudioController * audioController;
/***/
@property (nonatomic, assign) BOOL isStop;
@end

@implementation HZTAudioPlayerManager

+(instancetype)instance{
    HZTAudioPlayerManager * manager = [[HZTAudioPlayerManager alloc] init];
    return manager;
}

-(instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)playFromURL:(NSURL *)url{
    [self.audioController playFromURL:url];
}

-(void)stop{
    [self.audioController stop];
    self.audioController = nil;
    self.isStop = YES;
}

-(void)play{
    [self.audioController pause];
    self.isStop = NO;
}

-(void)pause{
    [self.audioController pause];
}

-(BOOL)isPlaying{
    return [self.audioController isPlaying];
}

-(BOOL)isStoped{
    return self.isStop;
}

-(void)playNextItem{
    [self.audioController playNextItem];
}

-(void)playPreviousItem{
    [self.audioController playPreviousItem];
}

-(FSAudioController *)audioController{
    if (!_audioController) {
        __weak typeof(self) weakSelf = self;
        _audioController = [[FSAudioController alloc] init];
        [_audioController setOnStateChange:^(FSAudioStreamState state) {
            NSLog(@"cur state is %ld",state);
            PlayState playState = PlayState_Buffering;
            if (state == kFsAudioStreamPlaying) {
                playState = PlayState_Playing;
            }else if (state == kFsAudioStreamPaused){
                playState = PlayState_PlayPaused;
            }else if (state == kFsAudioStreamStopped){
                playState = PlayState_PlayStopped;
            }else if (state == kFsAudioStreamFailed){
                playState = PlayState_PlayFailed;
            }else if (state == kFsAudioStreamPlaybackCompleted){
                playState = PlayState_PlayCompleted;
            }else if (state == kFSAudioStreamEndOfFile){
                playState = PlayState_EndOfFile;
            }else if (state == kFsAudioStreamUnknownState){
                playState = PlayState_UnknownState;
            }
            if(weakSelf.stateChangeBlock) weakSelf.stateChangeBlock(playState);
        }];
    }
    return _audioController;
}

@end
