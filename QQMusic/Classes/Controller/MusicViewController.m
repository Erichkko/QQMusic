//
//  MusicControllerViewController.m
//  QQMusic
//
//  Created by wanglong on 16/8/1.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import "MusicViewController.h"

#import "Music.h"
#import "WLTool.h"
#import "WLMusicTool.h"

#import "Masonry.h"

#import <AVFoundation/AVFoundation.h>

#define WlColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(g)/255.0 alpha:1.0]
@interface MusicViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *alumView;
@property (weak, nonatomic) IBOutlet UIImageView *icoView;
@property (weak, nonatomic) IBOutlet UISlider *progress;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UILabel *seekTimer;
@property (weak, nonatomic) IBOutlet UILabel *musicTimer;

@end

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addFrostedGlass];
  
    [self setupProgressStyle];
    [self playOrPauseMusic:nil];
    [self setupView];
   
}


- (void)setupView
{
    Music *music = [WLTool playingMusic];
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

        make.top.mas_equalTo(self.alumView.mas_top);
        make.bottom.mas_equalTo(self.alumView.mas_bottom);
        make.left.mas_equalTo(self.alumView.mas_left);
        make.right.mas_equalTo(self.alumView.mas_right);
    }];

    
}
- (IBAction)playOrPauseMusic:(id)sender {
    [self playMusic];
}
- (IBAction)nextMusic:(id)sender {
    [WLTool nextMusic];
    [self playMusic];
   
    
}
- (IBAction)preMusic:(id)sender {
    [WLTool preMusic];
    [self playMusic];
   
}

- (void)playMusic
{
    Music *music = [WLTool playingMusic];
    AVAudioPlayer *player= [WLMusicTool playMusicWithName:music.filename];
    
    self.seekTimer.text = [self convertTime:player.currentTime];
    self.musicTimer.text = [self convertTime:player.duration];
    
     [self setupView];
}
/**
 *  view完全加载完成时更新子view的尺寸 此时获得的尺寸才是最正确的
 */
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self addIconStyle];

}

- (NSString *)convertTime:(NSTimeInterval)time
{
    NSInteger min = time/60;
    NSInteger sec = (NSInteger)time%60;
    return [NSString stringWithFormat:@"%02zd:%02zd",min,sec];
}
@end
