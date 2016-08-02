//
//  WLMusicTool.h
//  QQMusic
//
//  Created by wanglong on 16/8/2.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AVAudioPlayer;
@interface WLMusicTool : NSObject
+ (AVAudioPlayer *)playMusicWithName:(NSString *)name;

+ (void)pauseMusicWithName:(NSString *)name;

+ (void)stopMusicWithName:(NSString *)name;
@end
