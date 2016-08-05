//
//  Music.h
//  QQMusic
//
//  Created by wanglong on 16/8/2.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLMusic : NSObject
/**name*/
@property(nonatomic,copy)NSString *name;
/**filename*/
@property(nonatomic,copy)NSString *filename;
/**lrcname*/
@property(nonatomic,copy)NSString *lrcname;
/**singer*/
@property(nonatomic,copy)NSString *singer;
/**singerIcon*/
@property(nonatomic,copy)NSString *singerIcon;
/**icon*/
@property(nonatomic,copy)NSString *icon;
@end
