//
//  WLLrcLabel.m
//  QQMusic
//
//  Created by wanglong on 16/8/6.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import "WLLrcLabel.h"

@implementation WLLrcLabel


- (void)setLrcLineprogess:(CGFloat)lrcLineprogess
{
    _lrcLineprogess = lrcLineprogess;
    
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    //确定回执范围
    CGRect fillRect = CGRectMake(0, 0, self.bounds.size.width * self.lrcLineprogess, self.bounds.size.height);
    
    //绘制进度
    [[UIColor redColor] set];
//    UIRectFill(fillRect);
    UIRectFillUsingBlendMode(fillRect, kCGBlendModeSourceIn);
}

@end
