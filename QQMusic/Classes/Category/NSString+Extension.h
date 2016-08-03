//
//  NSString+Extension.h
//  QQMusic
//
//  Created by wanglong on 16/8/3.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/**
 *  根据毫米数转成对应格式的时间字符串
 */
+ (NSString *)convertTime:(NSTimeInterval)time;
@end
