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
#import "WLLrcLabel.h"

#import "WLMusic.h"
#import "WLControllMusicTool.h"

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
    
    //0.重置currentIndex
    self.currentIndex = 0;
    
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
            
            //生成锁屏状态下歌词图片
            [self generateLockImage];
        }
        
        //4.显示当前播放的行歌词的进度
        if(self.currentIndex == i)
        {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            WLLrcCell *cell = (WLLrcCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            //计算进度值
            CGFloat lineAllProgess = nextLrc.lrcTime - lrc.lrcTime;
            CGFloat progress = (self.currentTime - lrc.lrcTime)/lineAllProgess;
            
            //设置内部歌词的进度显示
            cell.lrcLabel.lrcLineprogess = progress;
            
            
            //设置外边歌词的显示和进度
            self.lrcLabel.text = lrc.lrcText;
            self.lrcLabel.lrcLineprogess = progress;
        }
       
    }
}

#pragma mark - 生成锁屏状态下背景图片
- (void) generateLockImage
{
    //拿到正在播放歌曲的图片
    WLMusic *playingMusic = [WLControllMusicTool playingMusic];
    UIImage *lockImage = [UIImage imageNamed:playingMusic.icon];
    
    //拿到三局歌词
    //1,拿到正在播放的歌词
    WLLrc *lrc = self.lrcs[self.currentIndex];
    //2,拿到上一句歌词
    NSInteger preIndex = self.currentIndex - 1;
    WLLrc *preLrc = nil;
    if (preIndex >= 0) {
        preLrc = self.lrcs[preIndex];
    }
    
    //3,拿到下一句歌词
    NSInteger nextIndex = self.currentIndex + 1;
    WLLrc *nexLrc = nil;
    
    if (nextIndex < self.lrcs.count) {
        nexLrc = self.lrcs[nextIndex];
    }
    
    CGFloat rectW = lockImage.size.width;
    CGFloat rectH = lockImage.size.height;
    CGFloat lrcH  = 30;
    //绘制歌词到图片上
    UIGraphicsBeginImageContext(lockImage.size);
    
    //绘制图片
    [lockImage drawInRect:CGRectMake(0, 0, rectW, rectH)];
    
   //设置歌词属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    [attrs setObject:NSForegroundColorAttributeName forKey:[UIColor blueColor]];
    [attrs setObject:NSFontAttributeName  forKey:[UIFont systemFontOfSize:14]];
    //设置文字居中显示
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
    para.alignment = NSTextAlignmentCenter;
    [attrs setObject:NSParagraphStyleAttributeName forKey:para];
    
    //绘制第1句歌词
    [preLrc.lrcText drawInRect:CGRectMake(0, rectH - 3 * lrcH, rectW, lrcH) withAttributes:attrs];
    
    //绘制第3句歌词
    [preLrc.lrcText drawInRect:CGRectMake(0, rectH - 1 * lrcH, rectW, lrcH) withAttributes:attrs];
    
    [attrs setObject:NSForegroundColorAttributeName forKey:[UIColor redColor]];
    [attrs setObject:NSFontAttributeName  forKey:[UIFont systemFontOfSize:16]];
    //绘制第2句歌词
    [preLrc.lrcText drawInRect:CGRectMake(0, rectH - 2 * lrcH, rectW, lrcH) withAttributes:attrs];
    
   
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //发送通知 改编歌词
    NSDictionary *dict = @{@"lockImage":newImage};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LOCKIMAGE_CHANGE_NOTE" object:nil userInfo:dict];
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
        cell.lrcLabel.font = [UIFont systemFontOfSize:18];
//        cell.lrcLabel.textColor = [UIColor redColor];
    }else{
        cell.lrcLabel.font = [UIFont systemFontOfSize:14];
        cell.lrcLabel.lrcLineprogess = 0;
    }
    
    
    //2.取出模型,给cell设置数据
    WLLrc *lrc = self.lrcs[indexPath.row];
    cell.lrc =lrc;
    
    return cell;
}
#pragma mark - UITableViewDelegate代理方法
@end
