//
//  MainViewController.m
//  AudioStudyDemo
//
//  Created by 李涛 on 2018/10/26.
//  Copyright © 2018年 Tao_Lee. All rights reserved.
//

#import "MainViewController.h"
#import "LTAudioPlayer.h"
#import "ASValueTrackingSlider.h"
#import <MediaPlayer/MediaPlayer.h>
@interface MainViewController ()<LTAudioPlayerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (nonatomic, assign) NSInteger audioIndex;
@property (nonatomic, strong) LTAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *audioSlider;
@property (assign, nonatomic) BOOL touchSliderStatus;
@property (assign, nonatomic) CGFloat targetProgress;

@end

@implementation MainViewController

+ (instancetype)sharePlayVC{
    static MainViewController *vc = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vc = [[MainViewController alloc] init];
    });
    return vc;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createRemoteCommandCenter];
    
    _targetProgress = NAN;
    [self.dataArr addObjectsFromArray:@[
                                        @"http://2016.tingshijie.com/2015-12-07/TZBZDS/0001.mp3",
                                        @"http://2016.tingshijie.com/2015-12-07/TZBZDS/0002.mp3",
                                        @"http://2016.tingshijie.com/2015-12-07/TZBZDS/0003.mp3",
                                        @"http://2016.tingshijie.com/2015-12-07/TZBZDS/0004.mp3"
                                        ]];
    
    _audioSlider.popUpViewCornerRadius = 0.0;
    _audioSlider.popUpViewColor = RGBA(19, 19, 9, 1);
    _audioSlider.popUpViewArrowLength = 8;
    _audioSlider.value           = 0;
    _audioSlider.popUpView.hidden = YES;
    [_audioSlider setThumbImage:[UIImage imageNamed:@"audio_slider"] forState:UIControlStateNormal];
    _audioSlider.maximumValue          = 1;
    _audioSlider.minimumTrackTintColor = [UIColor whiteColor];
    _audioSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    
//    // slider开始滑动事件
//    [_audioSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
//    // slider滑动中事件
//    [_audioSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
//    // slider结束滑动事件
//    [_audioSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
//
    [_audioSlider addTarget:self action:@selector(sliderValueTouchBegin:) forControlEvents:(UIControlEventTouchDown)];
    [_audioSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
    [_audioSlider addTarget:self action:@selector(sliderValueTouchCancel:) forControlEvents:(UIControlEventTouchCancel)];
    
    UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
    [_audioSlider addGestureRecognizer:sliderTap];

//    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecognizer:)];
//    panRecognizer.delegate = self;
//    [panRecognizer setMaximumNumberOfTouches:1];
//    [panRecognizer setDelaysTouchesBegan:YES];
//    [panRecognizer setDelaysTouchesEnded:YES];
//    [panRecognizer setCancelsTouchesInView:YES];
//    [_audioSlider addGestureRecognizer:panRecognizer];
    
    LTAudioPlayer *player = [LTAudioPlayer defaultPlayer];
    player.delegate = self;
    _player = player;
    player.urlStr = self.dataArr[0];
    _audioIndex = 0;
    if (player.playerStatus == LTAudioPlayerStatusPlay) {
        [_playBtn setImage:[UIImage imageNamed:@"audio_icon_play"] forState:(UIControlStateNormal)];
    }else{
        [_playBtn setImage:[UIImage imageNamed:@"audio_icon_pause"] forState:(UIControlStateNormal)];
    }
}

#pragma mark - LTAudioPlayerDelegate

- (void)l_audioPlayerPlay{
    [_playBtn setImage:[UIImage imageNamed:@"audio_icon_play"] forState:(UIControlStateNormal)];
}

- (void)l_audioPlayerPause{
    if (_touchSliderStatus) {
        return;
    }
    if (!isnan(_targetProgress)) {
        return;
    }
    [_playBtn setImage:[UIImage imageNamed:@"audio_icon_pause"] forState:(UIControlStateNormal)];
}
- (void)l_seekPlayFinish{
    _targetProgress = NAN;
}

- (void)l_audioPlayerPlayFinish{
    [self clickNextBtn:nil];
}

- (void)l_audioPlayerLoadedProgress:(CGFloat)progress{
    _progressView.progress = progress;
    NSLog(@"%@",@(progress));
}

- (void)l_audioPlayerUpdateProgress:(CGFloat)progress total:(CGFloat)total{
    if (_touchSliderStatus) {
        return;
    }
    if (!isnan(_targetProgress)) {
        return;
    }
    _audioSlider.maximumValue = total;
    _audioSlider.value = progress;
    [self updateLockScreenAudio];
}
#pragma mark - httpRequest

#pragma mark - click

- (IBAction)clickPlayBtn:(id)sender {
    
    if (_player.playerStatus == LTAudioPlayerStatusPlay) {
        [_player l_pause];
        [_playBtn setImage:[UIImage imageNamed:@"audio_icon_pause"] forState:(UIControlStateNormal)];
    }else{
        [_player l_play];
        [_playBtn setImage:[UIImage imageNamed:@"audio_icon_play"] forState:(UIControlStateNormal)];
    }
    
}
- (IBAction)clickLastBtn:(id)sender {
    _audioIndex -= 1;
    if (_audioIndex < 0) {
        _audioIndex = _dataArr.count - 1;
    }
    _player.urlStr = self.dataArr[_audioIndex];
}
- (IBAction)clickNextBtn:(id)sender {
    _audioIndex += 1;
    if (_audioIndex > _dataArr.count-1) {
        _audioIndex = 0;
    }
    _player.urlStr = self.dataArr[_audioIndex];
}

- (void)tapSliderAction:(UITapGestureRecognizer *)tap{
//    if (tap) {
//        
//    }
    if ([tap.view isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)tap.view;
        CGPoint point = [tap locationInView:slider];
        CGFloat length = slider.frame.size.width;
        CGFloat tapValue = point.x / length;
        [self.player l_seekToTime:tapValue];
    }
}
- (void)sliderValueTouchBegin:(UISlider *)slider{
    _touchSliderStatus = YES;
}
- (void)sliderValueChange:(UISlider *)slider{
    _targetProgress = slider.value;
    [self.player l_seekToTime:slider.value/slider.maximumValue];
    _touchSliderStatus = NO;
}
- (void)sliderValueTouchCancel:(UISlider *)slider{
    _targetProgress = slider.value;
    [self.player l_seekToTime:slider.value/slider.maximumValue];
    _touchSliderStatus = NO;
}

#pragma mark - private method
- (void)play{
    [self.player l_play];
}
- (void)pause{
    [self.player l_pause];
}
- (void)playOrPause{
    if (self.player.playerStatus == LTAudioPlayerStatusPlay) {
        [self.player l_pause];
    }else{
        [self.player l_play];
    }
}
- (void)playNext{
    [self clickNextBtn:nil];
}
- (void)playLast{
    [self clickLastBtn:nil];
}

- (void)createRemoteCommandCenter{
    WS(ws)
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    //   MPFeedbackCommand对象反映了当前App所播放的反馈状态. MPRemoteCommandCenter对象提供feedback对象用于对媒体文件进行喜欢, 不喜欢, 标记的操作. 效果类似于网易云音乐锁屏时的效果
    
    //添加喜欢按钮
//    MPFeedbackCommand *likeCommand = commandCenter.likeCommand;
//    likeCommand.enabled = YES;
//    likeCommand.localizedTitle = @"喜欢";
//    [likeCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//        NSLog(@"喜欢");
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//    //添加不喜欢按钮，假装是“上一首”
//    MPFeedbackCommand *dislikeCommand = commandCenter.dislikeCommand;
//    dislikeCommand.enabled = YES;
//    dislikeCommand.localizedTitle = @"上一首";
//    [dislikeCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//        NSLog(@"上一首");
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
    //标记
//    MPFeedbackCommand *bookmarkCommand = commandCenter.bookmarkCommand;
//    bookmarkCommand.enabled = YES;
//    bookmarkCommand.localizedTitle = @"标记";
//    [bookmarkCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//        NSLog(@"标记");
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
    
    //    commandCenter.togglePlayPauseCommand 耳机线控的暂停/播放
    
    [commandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [self.player l_pause];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [commandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [self.player l_play];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [commandCenter.previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"上一首");
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [commandCenter.nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"下一首");
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    
    if (@available(iOS 9.1, *)) {
        [commandCenter.changePlaybackPositionCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
            MPChangePlaybackPositionCommandEvent *e = (MPChangePlaybackPositionCommandEvent *)event;
            [ws.player l_seekToAppointedTime:e.positionTime];
            return MPRemoteCommandHandlerStatusSuccess;
        }];
    } else {
        // Fallback on earlier versions
    }
    
}

- (void)updateLockScreenAudio{
    WS(ws)
    
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    //音乐专辑标题
    info[MPMediaItemPropertyAlbumTitle] = @"专辑标题";
    //音乐艺术家 (作者)
    info[MPMediaItemPropertyArtist] = @"作者";
    //音乐标题
    info[MPMediaItemPropertyTitle] = @"音乐标题";
    //音乐封面
    info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"cover"]];
    //音乐的总时间
    [info setObject:[NSNumber numberWithFloat:_audioSlider.maximumValue] forKey:MPMediaItemPropertyPlaybackDuration];
    //音乐的播放时间
    [info setObject:[NSNumber numberWithFloat:(float)_audioSlider.value] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    //音乐的播放速度
    [info setObject:@(1) forKey:MPNowPlayingInfoPropertyPlaybackRate];
    center.nowPlayingInfo = info;
                                        
}

#pragma mark - setter

#pragma mark - init


- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
