//
//  WLLrcTool.m
//  QQMusic
//
//  Created by wanglong on 16/8/5.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import "WLLrcTool.h"
#import "WLLrc.h"
@implementation WLLrcTool

+ (NSArray *)lrcWithLrcName:(NSString *)lrcName
{
    //1.获得文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:lrcName ofType:nil];
    
    #warning  y眼瞎呀
//    NSLog(@"path == %@",path);
//    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@" formate path == %@",path);//2.加载歌词内容
    NSError *error = nil;
    NSString *lrcStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        NSLog(@"error == %@",[error localizedDescription]);
    }
    
    //3.解析歌词
//    NSLog(@"lrcStr == %@",lrcStr);
    NSArray *array = [lrcStr componentsSeparatedByString:@"\n"];
    NSLog(@"array == %@",array);
    /**
     *     "[ti:\U6708\U534a\U5c0f\U591c\U66f2]",
     "[ar:\U674e\U514b\U52e4]",
     "[al:Purple dream]",
     */
    NSMutableArray *lrcArray = [NSMutableArray array];
    for (NSString *line in array) {
        if ([line hasPrefix:@"[ti:"]||[line hasPrefix:@"[ar:"]||[line hasPrefix:@"[al:"]||![line hasPrefix:@"["]) {
            continue ;
        }
     WLLrc *lrc = [WLLrc lrcWithLrcLine:line];
     [lrcArray addObject:lrc];
    }
    return lrcArray;
}
@end
