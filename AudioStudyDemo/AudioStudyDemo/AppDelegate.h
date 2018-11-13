//
//  AppDelegate.h
//  AudioStudyDemo
//
//  Created by 李涛 on 2018/10/26.
//  Copyright © 2018年 Tao_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackgroundSessionCompletionHandler)();

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, copy) BackgroundSessionCompletionHandler backgroundSessionCompletionHandler;

@end

