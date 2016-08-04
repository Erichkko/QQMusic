//
//  WLLrcCell.m
//  QQMusic
//
//  Created by wanglong on 16/8/4.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import "WLLrcCell.h"

@implementation WLLrcCell


+ (instancetype)lrcCellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"CellID";
    WLLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WLLrcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
//        cell.selectedBackgroundView = [[UIView alloc] init];设置没有背景颜色
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return cell;
}
- (void)awakeFromNib {
    // Initialization code
}


@end
