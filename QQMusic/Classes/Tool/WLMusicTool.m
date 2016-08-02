//
//  WLMusicTool.m
//  QQMusic
//
//  Created by wanglong on 16/8/2.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import "WLMusicTool.h"
#import <AVFoundation/AVFoundation.h>
@implementation WLMusicTool
static NSMutableDictionary *_musics;
+ (void)initialize
{
    
    _musics = [NSMutableDictionary dictionary];

}

+ (AVAudioPlayer *)playMusicWithName:(NSString *)name
{
    AVAudioPlayer *player = _musics[name];
    if (player == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
        NSURL *musicUrl = [NSURL URLWithString:path];
        NSError *error = nil;
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:&error];
        if (error ) {
            NSLog(@"音乐对象创建出错 %@",[error localizedDescription]);
        }
        [player prepareToPlay];
        
        [_musics setObject:player forKey:name];
    }
    [player play];
    return player;
    
}

+ (void)pauseMusicWithName:(NSString *)name
{
    
    AVAudioPlayer *player = _musics[name];
    if (player) {
        [player pause];
    }
}

+(void)stopMusicWithName:(NSString *)name
{
    AVAudioPlayer *player = _musics[name];
    if (player) {
        [player stop];
        [_musics removeObjectForKey:name];
        player = nil;
    }
}
@end
