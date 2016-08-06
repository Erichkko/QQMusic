//
//  WLLrcView.m
//  QQMusic
//
//  Created by wanglong on 16/8/4.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import "WLLrcView.h"


#import "WLLrcTool.h"
#import "WLLrcCell.h"
#import "WLLrc.h"
@interface WLLrcView ()<UITableViewDataSource,UITableViewDelegate>
/** tableView */
@property(nonatomic,weak) UITableView *tableView ;
/** lrcs */
@property(nonatomic,strong)NSArray *lrcs;

/**currentIndex当前播放音乐歌词的下标值*/
@property(nonatomic,assign)NSInteger currentIndex;

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

/**
 *  加载歌词数组
 */
- (void)setLrcName:(NSString *)lrcName
{
    //1.获得歌词文件
    _lrcName = lrcName;
    
    //2.解析歌词
    self.lrcs = [WLLrcTool lrcWithLrcName:lrcName];
    
    //3.刷新表格
    [self.tableView reloadData];
//    self.lrcs = [NSBundle mainBundle];
}
/**
 *  获得当前歌词显示的时间
 */

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    _currentTime = currentTime;
    NSInteger count = self.lrcs.count;
    for (int i = 0; i < count; i++) {
        //1.获得i位置的歌词
        WLLrc *lrc = self.lrcs[i];
        
        
        //2.获得下一句歌词
        NSInteger nextIndex = i + 1;
        WLLrc *nextLrc = nil;
        if (nextIndex <count) {
          nextLrc  = self.lrcs[nextIndex];
        }
        
        //3.比较应该显示那一句歌词
        if (self.currentIndex != i && currentTime >= lrc.lrcTime && currentTime < nextLrc.lrcTime) {
            
            
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            NSIndexPath * preINdexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            self.currentIndex = i;

            //刷新正在播放的歌词的高亮状态
            [self.tableView reloadRowsAtIndexPaths:@[indexPath,preINdexPath] withRowAnimation:UITableViewRowAnimationNone];
            //滚动到指定播放位置
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
       
    }
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
    return self.lrcs.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.创建cell
    WLLrcCell *cell = [WLLrcCell lrcCellWithTableView:tableView];
    
    //special高亮显示当前正在播放的歌词
    if(self.currentIndex == indexPath.row){
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.textLabel.textColor = [UIColor redColor];
    }else{
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    
    //2.取出模型,给cell设置数据
    WLLrc *lrc = self.lrcs[indexPath.row];
    cell.textLabel.text = lrc.lrcText;
    
    return cell;
}
#pragma mark - UITableViewDelegate代理方法
@end
