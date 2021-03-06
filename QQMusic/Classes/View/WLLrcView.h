//
//  WLLrcView.h
//  QQMusic
//
//  Created by wanglong on 16/8/4.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WLLrcLabel;
@interface WLLrcView : UIScrollView

/**lrcName*/
@property(nonatomic,copy)NSString *lrcName;

/**设置当前播放歌词的显示时间*/
@property(nonatomic,assign)NSTimeInterval currentTime;

/** 外边歌词的 lrcLabel */
@property(nonatomic,weak)WLLrcLabel *lrcLabel;
@end
