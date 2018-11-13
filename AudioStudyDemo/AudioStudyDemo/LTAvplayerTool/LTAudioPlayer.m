//
//  LTAudioPlayer.m
//  AudioStudyDemo
//
//  Created by 李涛 on 2018/10/26.
//  Copyright © 2018年 Tao_Lee. All rights reserved.
//

#import "LTAudioPlayer.h"


@interface LTAudioPlayer ()

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) LTAudioPlayerStatus playerStatus;
@property (nonatomic, strong) id timeObserver;
@property (nonatomic, strong) AVPlayerItem *playItem;
@property (nonatomic, assign) CGFloat duration;

@end

@implementation LTAudioPlayer

+ (instancetype)defaultPlayer{
    static LTAudioPlayer *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[LTAudioPlayer alloc] init];
    });
    return player;
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[@"new"] integerValue];
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:{
                CMTime duration = self.playItem.duration;
                self.duration = CMTimeGetSeconds(duration);
                [self l_play];
                break;
            }
            case AVPlayerItemStatusFailed:
            {
                NSLog(@"加载失败");
                break;
            }
             
            case AVPlayerItemStatusUnknown:
            {
                NSLog(@"未知资源");
                break;
            }
            default:
                break;
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array=playerItem.loadedTimeRanges;
        //本次缓冲时间范围
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        //缓冲总长度
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;
        CMTime duration = self.playItem.duration;
        self.duration = CMTimeGetSeconds(duration);
        
        CGFloat progress = totalBuffer/self.duration;
//        NSLog(@"共缓冲：%.2f 进度：%.2f",totalBuffer,progress);
        if (isnan(progress)) {
            return;
        }
        if (_delegate && [_delegate respondsToSelector:@selector(l_audioPlayerLoadedProgress:)]) {
            [self.delegate l_audioPlayerLoadedProgress:progress];
        }
        
        
    }
}

#pragma mark - httpRequest

#pragma mark - click
- (void)l_play{
    [self.player play];
    _playerStatus = LTAudioPlayerStatusPlay;
    if (_delegate && [_delegate respondsToSelector:@selector(l_audioPlayerPlay)]) {
        [_delegate l_audioPlayerPlay];
    }
}

- (void)l_pause{
    [self.player pause];
    _playerStatus = LTAudioPlayerStatusPause;
    if (_delegate && [_delegate respondsToSelector:@selector(l_audioPlayerPause)]) {
        [_delegate l_audioPlayerPause];
    }
}


#pragma mark - private method
- (void)l_audioPlayFinish{
    [self l_pause];
    if (_delegate && [_delegate respondsToSelector:@selector(l_audioPlayerPlayFinish)]) {
        [_delegate l_audioPlayerPlayFinish];
    }
}

- (void)l_seekToTime:(CGFloat)progress{
    
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        WS(ws)
        [self.player seekToTime:CMTimeMakeWithSeconds(progress * self.duration, self.player.currentTime.timescale) completionHandler:^(BOOL finished) {
            if (finished) {
                if (ws.delegate && [ws.delegate respondsToSelector:@selector(l_seekPlayFinish)]) {
                    [ws.delegate l_seekPlayFinish];
                }
            }
        }];
    }
}
- (void)l_seekToAppointedTime:(CGFloat)time{
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        WS(ws)
        [self.player seekToTime:(CMTimeMakeWithSeconds(time, self.player.currentTime.timescale)) completionHandler:^(BOOL finished) {
            if (finished) {
                if (ws.delegate && [ws.delegate respondsToSelector:@selector(l_seekPlayFinish)]) {
                    [ws.delegate l_seekPlayFinish];
                }
            }
        }];
    }
}

#pragma mark - setter
- (void)setUrlStr:(NSString *)urlStr{
    _urlStr = urlStr;
    [self l_currentItemRemoveObserver];
    NSURL *url = [NSURL URLWithString:urlStr];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    _playItem = item;
    [_player replaceCurrentItemWithPlayerItem:item];
    [self l_currentItemAddObserver];
}
#pragma mark - init
- (instancetype)init{
    self = [super init];
    if (self) {
        self.player = [[AVPlayer alloc] init];
        self.playerStatus = LTAudioPlayerStatusPause;
        
    }
    return self;
}


- (void)l_currentItemAddObserver{
    //监控状态属性
    WS(ws)
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil];
    //监控缓冲加载情况属性
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(l_audioPlayFinish) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    //监控时间进度
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:(CMTimeMake(1, 1)) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        if (ws.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
            CGFloat current = (CGFloat)time.value/time.timescale;
            if (isnan(ws.duration)) {
                return ;
            }
//            NSLog(@"%f",current);
            if (ws.delegate && [ws.delegate respondsToSelector:@selector(l_audioPlayerUpdateProgress:total:)]) {
                [ws.delegate l_audioPlayerUpdateProgress:current total:ws.duration];
            }
        }
        
    }];
}

- (void)l_currentItemRemoveObserver{
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self.player removeTimeObserver:self.timeObserver];
    
}



@end
