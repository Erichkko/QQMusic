//
//  WLLrc.m
//  QQMusic
//
//  Created by wanglong on 16/8/5.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import "WLLrc.h"
#import "WLTimeTool.h"
@implementation WLLrc

+(instancetype)lrcWithLrcLine:(NSString *)lrcLine
{
    WLLrc *lrc = [[self alloc] init];
    NSArray *array = [lrcLine componentsSeparatedByString:@"]"];
    lrc.lrcText = [array lastObject] ;
    lrc.lrcTime = [WLTimeTool timeWithStr:[[array firstObject] substringFromIndex:1]];
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
@end
