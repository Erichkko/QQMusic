//
//  WLTool.m
//  QQMusic
//
//  Created by wanglong on 16/8/5.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import "WLTimeTool.h"

@implementation WLTimeTool

+(NSTimeInterval)timeWithStr:(NSString *)str
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"mm:ss.00";
    NSDate *newDate = [formatter dateFromString:str];
                 
    NSLog(@"date == %@",[self getNowDateFromatAnDate:newDate]);

//
   NSTimeInterval deltimer = [newDate timeIntervalSinceReferenceDate];
//   NSLog(@"deltimer == %lf",deltimer);
    return 0;

}

/**
 *  把日期转化为本地时区的日期
 */
 + (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
                    
    {
        
        //设置源日期时区
        
        NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
        
        //设置转换后的目标日期时区
        
        NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
        
        //得到源日期与世界标准时间的偏移量
        
        NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
        
        //目标日期与本地时区的偏移量
        
        NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
        
        //得到时间偏移量的差值
        
        NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
        
        //转为现在时间
        
        NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
        
        return destinationDateNow;
        
    }
@end
