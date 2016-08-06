//
//  WLLrcCell.h
//  QQMusic
//
//  Created by wanglong on 16/8/4.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WLLrc,WLLrcLabel;
@interface WLLrcCell : UITableViewCell

+ (instancetype)lrcCellWithTableView:(UITableView *)tableView;
/** lrc */
@property(nonatomic,strong)WLLrc *lrc;
/** lrcLabel */
@property(nonatomic,weak)WLLrcLabel *lrcLabel;
@end
