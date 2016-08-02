//
//  WLTool.h
//  QQMusic
//
//  Created by wanglong on 16/8/2.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Music;
@interface WLTool : NSObject

+ (NSArray *)loadAllMusic;

+ (Music *)playingMusic;

+ (Music *)nextMusic;

+ (Music *)preMusic;

+ (void)setPlayMusic:(Music *)music;

@end
