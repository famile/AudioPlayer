//
//  LTAudioPlayer.h
//  AudioStudyDemo
//
//  Created by 李涛 on 2018/10/26.
//  Copyright © 2018年 Tao_Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN
@class LTAudioPlayer;

typedef NS_ENUM(NSUInteger, LTAudioPlayerStatus) {
    LTAudioPlayerStatusPlay,
    LTAudioPlayerStatusPause,
};

@protocol LTAudioPlayerDelegate <NSObject>

@optional

- (void)l_audioPlayerPlay;
- (void)l_audioPlayerPause;
- (void)l_seekPlayFinish;
- (void)l_audioPlayerPlayFinish;
- (void)l_audioPlayerLoadedProgress:(CGFloat)progress;
- (void)l_audioPlayerUpdateProgress:(CGFloat)progress total:(CGFloat)total;

@end

@interface LTAudioPlayer : NSObject



@property (nonatomic, weak) id<LTAudioPlayerDelegate> delegate;


@property (nonatomic, strong) AVPlayer *player;

/** 本地地址或者线上地址 */
@property (nonatomic, copy) NSString *urlStr;
/** 播放器状态 */
@property (nonatomic, assign, readonly) LTAudioPlayerStatus playerStatus;


+ (instancetype)defaultPlayer;

/**
 跳转到指定进度

 @param progress <#progress description#>
 */
- (void)l_seekToTime:(CGFloat)progress;

/**
 跳转到指定时间

 @param time <#time description#>
 */
- (void)l_seekToAppointedTime:(CGFloat)time;
- (void)l_play;
- (void)l_pause;


@end

NS_ASSUME_NONNULL_END
