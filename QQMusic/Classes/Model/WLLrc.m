//
//  WLLrc.m
//  QQMusic
//
//  Created by wanglong on 16/8/5.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import "WLLrc.h"
//#import "WLTimeTool.h"
@implementation WLLrc

+(instancetype)lrcWithLrcLine:(NSString *)lrcLine
{
    WLLrc *lrc = [[self alloc] init];
    NSArray *array = [lrcLine componentsSeparatedByString:@"]"];
    lrc.lrcText = [array lastObject] ;
//    lrc.lrcTime = [WLTimeTool timeWithStr:[[array firstObject] substringFromIndex:1]];
    lrc.lrcTime = [lrc timeFromStr:[[array firstObject] substringFromIndex:1]];
    return lrc;
}

//- (instancetype)initlrcWithLrcLine:(NSString *)lrcLine
//{
//    if (self = [super ini]) {
//        self.lrcText = lrcLine;
//        self.lrcTime = 0;
//    }
//    return self;
//    
//}

- (NSTimeInterval) timeFromStr:(NSString *)str
{
    NSLog(@"str == %@",str);
    NSArray *array = [str componentsSeparatedByString:@":"];
    NSInteger min = [[array firstObject] integerValue] ;
    NSInteger sec  = [[[[array lastObject] componentsSeparatedByString:@"."] firstObject] integerValue];
    NSInteger mil = [[[[array lastObject] componentsSeparatedByString:@"."] lastObject] integerValue];
    
    NSTimeInterval time = min * 60 + sec + mil * 0.01;
        NSLog(@"time == %.2lf",time);
    return time;
}
@end
