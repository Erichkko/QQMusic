//
//  WLTool.h
//  QQMusic
//
//  Created by wanglong on 16/8/2.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WLMusic;
@interface WLControllMusicTool : NSObject

+ (NSArray *)loadAllMusic;

+ (WLMusic *)playingMusic;

+ (WLMusic *)nextMusic;

+ (WLMusic *)preMusic;

+ (void)setPlayMusic:(WLMusic *)music;

@end
