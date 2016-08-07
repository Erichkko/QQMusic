//
//  MusicControllerViewController.m
//  QQMusic
//
//  Created by wanglong on 16/8/1.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import "MusicViewController.h"

#import "WLMusic.h"
#import "WLControllMusicTool.h"
#import "WLMusicTool.h"
#import "WLLrcView.h"
#import "WLLrcLabel.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#define WlColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(g)/255.0 alpha:1.0]
@interface MusicViewController ()<AVAudioPlayerDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *alumView;
@property (weak, nonatomic) IBOutlet UIImageView *icoView;
@property (weak, nonatomic) IBOutlet UISlider *progress;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UILabel *seekTimer;
@property (weak, nonatomic) IBOutlet UILabel *musicTimer;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
@property (weak, nonatomic) IBOutlet WLLrcView *lrcView;
@property (weak, nonatomic) IBOutlet WLLrcLabel *lrcLabel;

/** player */
@property(nonatomic,strong)AVAudioPlayer *player;
/** 进度值timer */
@property(nonatomic,strong)NSTimer *timer;


/**lrcLink*/
@property(nonatomic,strong)CADisplayLink *lrcDisplayLink;
@end

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addFrostedGlass];
  
    [self setupProgressStyle];
    [self playOrPauseMusic:nil];
    [self setupView];
    [self playMusic];
    [self setupNoteLockLrcChange];
   
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//设置通知 监听 歌词的刷新 在后台显示对应的歌词
- (void)setupNoteLockLrcChange
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLockScreenInfo:) name:@"LOCKIMAGE_CHANGE_NOTE" object:nil];
    
}

//设置滑动的显示歌词
- (void)setupLrc
{
    CGFloat width = self.lrcView.frame.size.width;
    CGFloat height = self.lrcView.frame.size.height;
    self.lrcView.contentSize = CGSizeMake(width * 2, height);
    self.lrcView.pagingEnabled = YES;
    self.lrcView.delegate = self;
    
    self.lrcView.lrcLabel = self.lrcLabel;

}
- (void)setupView
{
    WLMusic *music = [WLControllMusicTool playingMusic];
    self.nameLabel.text = music.name;
    self.singerLabel.text = music.singer;
//    NSString *musicIcon = [music.icon stringByReplacingOccurrencesOfString:@"." withString:@"@2x."];
//    NSString *path = [[NSBundle mainBundle] pathForResource:musicIcon ofType:nil];
//    NSLog(@"path == %@",path);
//    NSLog(@"music.icon == %@",music.icon);
//    self.alumView.image = [UIImage imageWithContentsOfFile:path];
//    self.icoView.image = [UIImage imageWithContentsOfFile:path];
    
    self.alumView.image = [UIImage imageNamed:music.icon];
    self.icoView.image = [UIImage imageNamed:music.singerIcon];
    [self.progress addTarget:self action:@selector(progessSliderValueChage:) forControlEvents:UIControlEventValueChanged];
   [self.progress addTarget:self action:@selector(progessBegin) forControlEvents:UIControlEventTouchDown];
   [self.progress addTarget:self action:@selector(progessEnd) forControlEvents:UIControlEventTouchUpInside];
    //添加进度条的点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSlider:)];
    [self.progress addGestureRecognizer:tapGesture];
}
#pragma mark - slider 的事件处理 开始 值改变 结束
- (void)progessBegin
{
    [self cancelTimer];
  
}

- (void)progessSliderValueChage:(UISlider *)slider
{
//    NSLog(@"slider value == %f",slider.value);
    self.seekTimer.text = [NSString convertTime:self.progress.value * (self.player.duration)];
}

- (void)progessEnd
{
    //设置指定的播放位置
    self.player.currentTime =self.progress.value * (self.player.duration);
    //添加定时器 更新进度条
    [self setupTimer];
}

#pragma mark - 点击的进度条的监听

-(void)tapSlider:(UITapGestureRecognizer *)tap
{

    CGPoint point = [tap locationInView:self.progress];
    CGFloat width = self.progress.frame.size.width;
    
    CGFloat ratio = (point.x / width);
    
    self.progress.value =ratio;
    
//    self.seekTimer.text = [NSString convertTime:ratio *self.player.duration];
    //设置指定的播放位置
    self.player.currentTime = ratio * (self.player.duration);
    [self updatePlayProgess];

}

/**
 *  设置滑块样式
 */
- (void)setupProgressStyle
{
   [ self.progress setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
}

/**
 *  设置中间icon的样式
 */
- (void)addIconStyle
{
    CALayer *layer= self.icoView.layer;
    layer.borderWidth = 8;
//    layer.borderColor = [[UIColor blackColor] CGColor];
    layer.borderColor = [WlColor(36, 36, 36) CGColor];
    layer.cornerRadius = layer.frame.size.width * 0.5;
    
    #warning  把超出的部分裁剪掉
    layer.masksToBounds = YES;
//    self.icoView.clipsToBounds = YES;
    
}
/**
 *  添加毛玻璃效果
 */
- (void)addFrostedGlass
{
    
    //添加毛玻璃主要有4种方式
    UIToolbar *frostedGlass = [[UIToolbar alloc] init];
    //设置toolbar的颜色样式
    [frostedGlass setBarStyle:UIBarStyleBlack];
//    frostedGlass.alpha = 0.8;
    [self.alumView addSubview:frostedGlass];
    //社会模糊图片的frame
    #warning  从XIB加载默认的view的宽度和高度不准确
//    frostedGlass.frame = self.view.frame;
    //通过masonry框架约束frame
    frostedGlass.translatesAutoresizingMaskIntoConstraints = NO;
    [frostedGlass mas_makeConstraints:^(MASConstraintMaker *make) {
        /*
        make.top.mas_equalTo(self.alumView.mas_top);
        make.bottom.mas_equalTo(self.alumView.mas_bottom);
        make.left.mas_equalTo(self.alumView.mas_left);
        make.right.mas_equalTo(self.alumView.mas_right);
         */
        
        make.edges.equalTo(self.alumView);
    }];

    
}
- (IBAction)playOrPauseMusic:(id)sender {
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.selected;
    if ([self.player isPlaying]) {
        
        //暂停播放
        [self.player pause];
        //取消进度定时器
        [self cancelTimer];
        //歌词定时器的启动
        [self cancelLrcTimer];
        //暂定icon动画
        [self.icoView.layer pauseAnimate];
    }else{
        //开始播放
        [self.player play];
        //启动进度定时器
        [self setupTimer];
        //启动歌词定时器
        [self setLrcTimer];
        //启动icon动画
        [self.icoView.layer resumeAnimate];
    }
}
- (IBAction)nextMusic:(id)sender {
    WLMusic *music = [WLControllMusicTool playingMusic];
    
    [WLMusicTool stopMusicWithName:music.filename];
    
    music = [WLControllMusicTool nextMusic];
    [self playMusic];
   
    
}
- (IBAction)preMusic:(id)sender {
    WLMusic *music = [WLControllMusicTool playingMusic];
    
    [WLMusicTool stopMusicWithName:music.filename];
    
    music = [WLControllMusicTool preMusic];
    [self playMusic];
   
}

- (void)playMusic
{
    WLMusic *music = [WLControllMusicTool playingMusic];
    AVAudioPlayer *player= [WLMusicTool playMusicWithName:music.filename];
    player.delegate  = self;
    self.player = player;
    self.musicTimer.text = [NSString convertTime:player.duration];
    //设置播放按钮图标
    self.playOrPauseBtn.selected = self.player.isPlaying;
    
    //设置view的基本数据
    [self setupView];
    //跟新进度条
    [self cancelTimer];
    [self setupTimer];
    //开始icon的动画
    [self startIconAnim];
    
    //更新 对应的 歌词
    [self.lrcView setLrcName:music.lrcname];
    //取消上一首歌的歌词定时器
    [self cancelLrcTimer];
    //歌词定时器的启动
    [self setLrcTimer];
    
    #warning  为了显示歌词不在此处理
    //锁屏状态信息
    //    [self setLockScreenInfo];
}
#pragma mark - 启动动画
- (void)startIconAnim
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anim.repeatCount = NSIntegerMax;
    anim.fromValue = @(0);
    anim.toValue = @(M_PI * 2) ;
    anim.duration = 25;
    [self.icoView.layer addAnimation:anim forKey:nil];
}
/**
 *  view完全加载完成时更新子view的尺寸 此时获得的尺寸才是最正确的
 */
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self addIconStyle];
    [self setupLrc];

}
- (void)updatePlayProgess
{
    self.seekTimer.text = [NSString convertTime:self.player.currentTime];
//    NSLog(@"progess == %f",self.player.currentTime/self.player.duration);
    self.progress.value = self.player.currentTime/self.player.duration;

}

#pragma mark - 启动计时器
- (void)setupTimer
{
    [self updatePlayProgess];
   self.timer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updatePlayProgess) userInfo:nil repeats:YES];
    
//    [timer fire];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 取消计时器
- (void)cancelTimer
{
    [self.timer invalidate];
     self.timer = nil;
}

#pragma mark - 启动歌词定时器
- (void)setLrcTimer
{
    self.lrcDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrcDisplay)];
    [self.lrcDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
#pragma mark - 取消歌词定时器
- (void)cancelLrcTimer
{
    [self.lrcDisplayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [self.lrcDisplayLink invalidate];
    self.lrcDisplayLink = nil;
    
}

- (void)updateLrcDisplay
{
    [self.lrcView setCurrentTime:self.player.currentTime];
}
#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
//    [self.icoView.layer addAnimation:nil forKey:nil];
    NSLog(@"一首歌播放完成...");
    [self cancelTimer];
    [self.icoView.layer pauseAnimate];
    [self nextMusic:nil];
    [self.icoView.layer resumeAnimate];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //1.或得scrollview的左上角偏移位置
    CGPoint point = scrollView.contentOffset;
 
    //2.计算滑动比例
    CGFloat ratio = point.x / scrollView.frame.size.width;
    
    self.icoView.alpha = 1 - ratio;
    self.lrcLabel.alpha = 1 - ratio;
}


// MPMediaItemPropertyAlbumTitle
// MPMediaItemPropertyAlbumTrackCount
// MPMediaItemPropertyAlbumTrackNumber
// MPMediaItemPropertyArtist
// MPMediaItemPropertyArtwork
// MPMediaItemPropertyComposer
// MPMediaItemPropertyDiscCount
// MPMediaItemPropertyDiscNumber
// MPMediaItemPropertyGenre
// MPMediaItemPropertyPersistentID
// MPMediaItemPropertyPlaybackDuration
// MPMediaItemPropertyTitle

#pragma mark - 设置锁屏状态下屏幕显示对应的歌曲图片
- (void)setLockScreenInfo:(NSNotification *)note
{
    
    //0.0获得当前正在播放的音乐
    WLMusic *music = [WLControllMusicTool playingMusic];
    //1.0获得锁屏界面中心
    MPNowPlayingInfoCenter *playCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    //2.设置展示的信息
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    [dictM setObject:music.name forKey:MPMediaItemPropertyAlbumTitle];
    [dictM setObject:music.singer forKey:MPMediaItemPropertyArtist];
    [dictM setObject:@(self.player.duration) forKey:MPMediaItemPropertyPlaybackDuration];
    
    //设置展示的背景图片
    
    UIImage *lockLrcImage = (UIImage *)note.userInfo[@"lockImage"];
    NSLog(@"lockLrcImage == %@",lockLrcImage);
//    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:music.icon]];
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:lockLrcImage];
    [dictM setObject:artwork forKey:MPMediaItemPropertyArtwork];
    
    playCenter.nowPlayingInfo = dictM;
    
    //3.让应用程序可以接受远程事件处理
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}
/**
 *    UIEventSubtypeRemoteControlTogglePlayPause      = 103,
 UIEventSubtypeRemoteControlNextTrack            = 104,
 UIEventSubtypeRemoteControlPreviousTrack
 */
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlNextTrack:
            NSLog(@"next...");
            [self nextMusic:nil];
            break;
        case UIEventSubtypeRemoteControlTogglePlayPause:
            [self playOrPauseMusic:nil];
            NSLog(@"PlayPause...");
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            NSLog(@"pre...");
            [self preMusic:nil];
            break;
        default:
            break;
    }
}
@end
