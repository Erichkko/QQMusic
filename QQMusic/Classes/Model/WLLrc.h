//
//  WLLrc.h
//  QQMusic
//
//  Created by wanglong on 16/8/5.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLLrc : NSObject

/**lrcText*/
@property(nonatomic,copy)NSString *lrcText;
/**lrcTime*/
@property(nonatomic,assign)NSTimeInterval lrcTime;


+(instancetype)lrcWithLrcLine:(NSString *)lrcLine;

-(instancetype)initlrcWithLrcLine:(NSString *)lrcLine;


@end
