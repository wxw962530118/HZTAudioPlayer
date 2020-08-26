//
//  HomeViewController.m
//  HZTAudioPlayer
//
//  Created by wangxw on 2020/8/26.
//  Copyright © 2020 wangxw. All rights reserved.
//

#import "HomeViewController.h"
#import "HZTAudioPlayerManager.h"
#import "HZTAudioPlayerManager.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *poegressView;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (nonatomic, strong) HZTAudioPlayerManager * audioPlayer;
@property (nonatomic, strong) NSTimer *updateTimer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressWConstraint;
@property (nonatomic, assign) BOOL isPalying;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"HZTAudioPlayer";
    [self.audioPlayer playFromURL:[NSURL URLWithString:@"https://mv-cdn1.ylyk.com/course/audio-402-1481534785-64k44100.mp3"]];
}

-(HZTAudioPlayerManager *)audioPlayer{
    if (!_audioPlayer) {
        __weak typeof(self) weakSelf = self;
        _audioPlayer = [HZTAudioPlayerManager instance];
        [_audioPlayer setStateChangeBlock:^(PlayState state) {
            if (state==PlayState_Playing) {
                [weakSelf checkAudioProgressTimer];
            }else if (state == PlayState_Buffering){
                MBProgressHUD * hud = [MBProgressHUD HUDForView:weakSelf.view];
                if (!hud) {
                    hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
                    hud.mode = MBProgressHUDModeIndeterminate;
                    hud.label.text = @"缓冲中...";
                }
            }else if (state == PlayState_EndOfFile){
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            }else if (state == PlayState_PlayCompleted){
                [weakSelf invalidateTimer];
            }else if (state == PlayState_PlayStopped){
                [weakSelf invalidateTimer];
                weakSelf.progressWConstraint.constant = 0;
                weakSelf.currentTimeLabel.text = @"00:00";
            }
        }];
    }
    return _audioPlayer;
}

- (void)invalidateTimer {
    if (_updateTimer) {
        [_updateTimer invalidate];
        _updateTimer = nil;
    }
}

- (void)checkAudioProgressTimer {
    [self invalidateTimer];
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/24 target:self selector:@selector(changeAudioProgress) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_updateTimer forMode:NSRunLoopCommonModes];
}

- (void)changeAudioProgress {
    if (!_audioPlayer.audioController || !_audioPlayer.audioController.activeStream) return;
    FSAudioStream * stream = _audioPlayer.audioController.activeStream;
    self.progressWConstraint.constant = stream.currentTimePlayed.position * ([UIScreen mainScreen].bounds.size.width-2*65);
    NSString * playStr = [NSString stringWithFormat:@"%02d:%02d",stream.currentTimePlayed.minute,stream.currentTimePlayed.second];
    self.currentTimeLabel.text = playStr;
    if (stream.duration.minute == 0 && stream.duration.second == 0) {
        self.currentTimeLabel.text = @"00:00";
    }
}

- (IBAction)clickStopBtn:(id)sender {
    [self.audioPlayer stop];
}

- (IBAction)clickPlayBtn:(id)sender {
    self.isPalying = YES;
    if ([self.audioPlayer isStoped]) {
        [self.audioPlayer playFromURL:[NSURL URLWithString:@"https://mv-cdn1.ylyk.com/course/audio-402-1481534785-64k44100.mp3"]];
    }else{
        [self.audioPlayer play];
        [self.updateTimer setFireDate:[NSDate date]];
    }
}

- (IBAction)clickPauseBtn:(id)sender {
    self.isPalying = NO;
    [self.audioPlayer pause];
    [self.updateTimer setFireDate:[NSDate distantFuture]];
}

-(void)dealloc{
    if (self.audioPlayer){
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
    [self invalidateTimer];
}

@end
