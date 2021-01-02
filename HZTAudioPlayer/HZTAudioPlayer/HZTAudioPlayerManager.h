//
//  HZTAudioPlayerManager.h
//  HZTAudioPlayer
//
//  Created by wangxw on 2020/8/26.
//  Copyright © 2020 wangxw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FreeStreamer/FSAudioController.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,PlayState){
    PlayState_Buffering=0,  /**缓冲中...*/
    PlayState_Playing,      /**开始播放*/
    PlayState_EndOfFile,    /**缓冲结束*/
    PlayState_UnknownState, /**未知状态*/
    PlayState_PlayCompleted,/**播放完成*/
    PlayState_PlayFailed,   /**播放失败*/
    PlayState_PlayStopped,  /**播放停止*/
    PlayState_PlayPaused,   /**暂停播放*/
};

typedef NS_ENUM(NSInteger,PlayLoopMode){
    PlayLoopMode_OnceLoop=0,  /**单曲循环*/
    PlayLoopMode_ForeverLoop, /**重复循环*/
    PlayLoopMode_RandomLoop,  /**随机播放*/
};

@interface HZTAudioPlayerManager : NSObject
/***/
+(instancetype)instance;
/**播放循环模式*/
@property (nonatomic, assign) PlayLoopMode loopMode;
/**播放状态回调*/
@property (nonatomic, copy) void (^stateChangeBlock)(PlayState state);
/**播放实例*/
@property (nonatomic, strong,readonly) FSAudioController * audioController;
/**音量值大小*/
@property (nonatomic,assign) float volume;
/**根据url播放<本地/网络>*/
- (void)playFromURL:(NSURL *)url;
/**停止播放*/
-(void)stop;
/**播放*/
-(void)play; 
/**暂停*/
-(void)pause;
/**上一首*/
-(void)playPreviousItem;
/**下一首*/
-(void)playNextItem;
/**是否正在播放*/
- (BOOL)isPlaying;
/**是否停止播放*/
- (BOOL)isStoped;
@end

NS_ASSUME_NONNULL_END
