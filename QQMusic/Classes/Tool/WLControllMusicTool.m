//
//  WLTool.m
//  QQMusic
//
//  Created by wanglong on 16/8/2.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import "WLControllMusicTool.h"

#import "MJExtension.h"


#import "WLMusic.h"
@implementation WLControllMusicTool


static NSArray *_allMusic;
static WLMusic *_playingMusic;
+ (void)initialize
{
    
    _allMusic =  [WLMusic objectArrayWithFilename:@"Musics.plist"];
    _playingMusic = _allMusic[0];
}

+ (NSArray *)loadAllMusic
{
    return _allMusic;
}

+ (WLMusic *)playingMusic
{
    return _playingMusic;
}

+ (void)setPlayMusic:(WLMusic *)music
{
    _playingMusic = music;
}

+ (WLMusic *)nextMusic
{
    NSInteger index = [_allMusic indexOfObject:_playingMusic];
    NSInteger nextIndex = ++index;
    if (nextIndex >= _allMusic.count) {
        nextIndex = 0;
    }
    WLMusic *music = _allMusic[nextIndex];
    _playingMusic = music;
    return music;
}

+ (WLMusic *)preMusic{
    NSInteger index = [_allMusic indexOfObject:_playingMusic];
    NSInteger preIndex = --index;
    if (preIndex < 0) {
        preIndex = _allMusic.count-1;
    }
    WLMusic *music = _allMusic[preIndex];
     _playingMusic = music;
    return music;
}


@end
