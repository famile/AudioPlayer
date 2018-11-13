//
//  MainViewController.h
//  AudioStudyDemo
//
//  Created by 李涛 on 2018/10/26.
//  Copyright © 2018年 Tao_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainViewController : UIViewController

+ (instancetype)sharePlayVC;

- (void)play;
- (void)pause;
- (void)playOrPause;
- (void)playNext;
- (void)playLast;


@end

NS_ASSUME_NONNULL_END
