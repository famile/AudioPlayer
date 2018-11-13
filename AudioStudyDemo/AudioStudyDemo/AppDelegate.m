//
//  AppDelegate.m
//  AudioStudyDemo
//
//  Created by 李涛 on 2018/10/26.
//  Copyright © 2018年 Tao_Lee. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LTAudioPlayer.h"
@interface AppDelegate ()



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    self.window.rootViewController = [MainViewController sharePlayVC];
    [self playBackground];
    return YES;
}


#pragma mark - 后台控制
- (void)playBackground{
    //添加后台会话模式
    AVAudioSession *session = [AVAudioSession sharedInstance];
    //设置会话模式
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //激活音频会话
    [session setActive:YES error:nil];
    
    //开启监听远程控制事件 在允许远程控制事件时，UI控件必须成为第一响应者，所以需要在beginReceivingRemoteControlEvents方法后面增加一个becomeFirstResponder方法。
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)  name:AVAudioSessionRouteChangeNotification object:nil];
    
}
//
- (BOOL)canBecomeFirstResponder{
    return YES;
}



- (void)handleInterruption:(NSNotification *)notification{
    NSDictionary *interruptionDictionary = [notification userInfo];
    AVAudioSessionInterruptionType type = [interruptionDictionary [AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    AVAudioSessionInterruptionOptions options =
    [interruptionDictionary[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        [[LTAudioPlayer defaultPlayer] l_pause];
    }else if (type == AVAudioSessionInterruptionTypeEnded){
        UIBackgroundTaskIdentifier bgTask = 0;
        if([UIApplication sharedApplication].applicationState== UIApplicationStateBackground) {
            if (options == AVAudioSessionInterruptionOptionShouldResume){
                [[LTAudioPlayer defaultPlayer] l_play];
            }
            UIApplication *application = [UIApplication sharedApplication];
            UIBackgroundTaskIdentifier newTask = [application beginBackgroundTaskWithExpirationHandler:nil];
            if (bgTask != UIBackgroundTaskInvalid) {
                [application endBackgroundTask:bgTask];
            }
            bgTask = newTask;
        }else{
            if (options == AVAudioSessionInterruptionOptionShouldResume) {
                [[LTAudioPlayer defaultPlayer] l_play];
            }
        }
    }else{
        NSLog(@"Something else happened");
    }
}

- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:{
            
            NSLog(@"耳机插入");
            
            break;
        }
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:{
            
            //耳机拔出
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //做操作,用主线程调用,如果不用主线程会报黄,提示,从一个线程跳到另一个线程容易产生崩溃,所以这里要用主线程去做操作
                [[MainViewController sharePlayVC] pause];
            });
            
            break;
        }
        default:{
            
            break;
        }
            
    }
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    NSLog(@"event type:%ld  subtype:%ld",event.type,event.subtype);
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeNone:
            {
                break;
            }
            case UIEventSubtypeMotionShake:{
                
                break;
            }
            case UIEventSubtypeRemoteControlPlay:{
                [[LTAudioPlayer defaultPlayer] l_play];
                break;
            }
            case UIEventSubtypeRemoteControlStop:{
                [[LTAudioPlayer defaultPlayer] l_pause];
                break;
            }
            case UIEventSubtypeRemoteControlPause:{
                [[LTAudioPlayer defaultPlayer] l_pause];
                break;
            }
            case UIEventSubtypeRemoteControlTogglePlayPause:{
                //播放和暂停切换 （单击暂停/播放）
                [[MainViewController sharePlayVC] playOrPause];
                break;
            }
            case UIEventSubtypeRemoteControlNextTrack:{
                //下一首 (双击)
                [[MainViewController sharePlayVC] playNext];
                break;
            }
            case UIEventSubtypeRemoteControlPreviousTrack:{
                //上一首 （三击）
                [[MainViewController sharePlayVC] playLast];
                break;
            }
            case UIEventSubtypeRemoteControlBeginSeekingBackward:{
                //开始后退
                
                break;
            }
            case UIEventSubtypeRemoteControlEndSeekingBackward:{
                //结束后退
                
                break;
            }
            case UIEventSubtypeRemoteControlBeginSeekingForward:{
                //开始前进
                
                break;
            }
            case UIEventSubtypeRemoteControlEndSeekingForward:{
                //结束前进
                
                break;
            }
            default:
                break;
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
//    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
//    [self resignFirstResponder];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
