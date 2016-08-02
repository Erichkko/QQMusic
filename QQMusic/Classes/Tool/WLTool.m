//
//  WLTool.m
//  QQMusic
//
//  Created by wanglong on 16/8/2.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import "WLTool.h"

#import "MJExtension.h"


#import "Music.h"
@implementation WLTool


static NSArray *_allMusic;
static Music *_playingMusic;
+ (void)initialize
{
    
    _allMusic =  [Music objectArrayWithFilename:@"Musics.plist"];
    _playingMusic = _allMusic[0];
}

+ (NSArray *)loadAllMusic
{
    return _allMusic;
}

+ (Music *)playingMusic
{
    return _playingMusic;
}

+ (void)setPlayMusic:(Music *)music
{
    _playingMusic = music;
}

+ (Music *)nextMusic
{
    NSInteger index = [_allMusic indexOfObject:_playingMusic];
    NSInteger nextIndex = ++index;
    if (nextIndex >= _allMusic.count) {
        nextIndex = 0;
    }
    Music *music = _allMusic[nextIndex];
    return music;
}

+ (Music *)preMusic{
    NSInteger index = [_allMusic indexOfObject:_playingMusic];
    NSInteger preIndex = --index;
    if (preIndex < 0) {
        preIndex = _allMusic.count-1;
    }
    Music *music = _allMusic[preIndex];
    return music;
}


@end
