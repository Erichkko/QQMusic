//
//  WLLrcCell.m
//  QQMusic
//
//  Created by wanglong on 16/8/4.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import "WLLrcCell.h"
#import "WLLrcLabel.h"
#import "WLLrc.h"

#import "Masonry.h"
@interface WLLrcCell ()


@end

@implementation WLLrcCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupChildView];
    }
    return self;
}
- (void)setupChildView
{
    WLLrcLabel *lrcLabel = [[WLLrcLabel alloc] init];
    self.lrcLabel = lrcLabel;
    [self.contentView addSubview:lrcLabel];
    
    //        cell.selectedBackgroundView = [[UIView alloc] init];设置没有背景颜色
    
    //设置label的基本样式
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.lrcLabel.textColor = [UIColor whiteColor];
    self.lrcLabel.font = [UIFont systemFontOfSize:14];
    self.lrcLabel.textAlignment = NSTextAlignmentCenter;
    
    
    //设置frame
    self.lrcLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.lrcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView.mas_top);
//        make.bottom.equalTo(self.contentView.mas_bottom);
//        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];

}
+ (instancetype)lrcCellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"CellID";
    WLLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WLLrcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];

    }
    return cell;
}

- (void)setLrc:(WLLrc *)lrc
{
    self.lrcLabel.text = lrc.lrcText;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    //设置自定义label的尺寸
//    self.lrcLabel.frame = CGRectMake(0, 0, self.frame.size.width, 40);
//    self.lrcLabel.backgroundColor = [UIColor blueColor];
}

@end
