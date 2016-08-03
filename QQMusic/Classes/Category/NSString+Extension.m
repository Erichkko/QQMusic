//
//  NSString+Extension.m
//  QQMusic
//
//  Created by wanglong on 16/8/3.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
+ (NSString *)convertTime:(NSTimeInterval)time
{
    NSInteger min = time/60;
    NSInteger sec = (NSInteger)time%60;
    return [NSString stringWithFormat:@"%02zd:%02zd",min,sec];
}
@end
