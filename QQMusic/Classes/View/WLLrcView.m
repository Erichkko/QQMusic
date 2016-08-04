//
//  WLLrcView.m
//  QQMusic
//
//  Created by wanglong on 16/8/4.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import "WLLrcView.h"

#import "WLLrcCell.h"
@interface WLLrcView ()<UITableViewDataSource,UITableViewDelegate>
/** tableView */
@property(nonatomic,weak) UITableView *tableView ;

@end
@implementation WLLrcView


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupView];
    NSLog(@"%s",__func__);
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self= [super initWithCoder:aDecoder]) {
        [self setupView];
         NSLog(@"%s",__func__);
    }
    return self;
}
-  (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
         NSLog(@"%s",__func__);
    }
    return self;
}


- (void)setupView
{
    //创建歌词显示的tableView
    UITableView *tableView = [[UITableView alloc] init];
    [self addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 30;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    #warning  在这里添加约束获得的 frame 是不准确的
   
}

- (void)layoutSubviews
{
    //设置歌词显示的位置
    [super layoutSubviews];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(self.mas_height);
        make.left.equalTo(self.mas_left).offset (self.frame.size.width);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(self.mas_width);
    }];
    
    //设置从中间显示
    self.tableView.contentOffset =CGPointMake(0,-self.bounds.size.height * 0.5);

    self.tableView.contentInset  = UIEdgeInsetsMake(self.bounds.size.height * 0.5, 0, self.bounds.size.height * 0.5,0);
    
    
}

#pragma mark - UITableViewDataSource数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WLLrcCell *cell = [WLLrcCell lrcCellWithTableView:tableView];
    cell.textLabel.text = [NSString stringWithFormat:@"第 %zd 个 Cell",indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate代理方法
@end
