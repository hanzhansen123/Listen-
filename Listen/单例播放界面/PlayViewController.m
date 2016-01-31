//
//  PlayViewController.m
//  Listen
//
//  Created by laouhn on 15/11/16.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#import "PlayViewController.h"
#import "UIColor+BackgroundColor.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"
#import "ZhuanJiModel.h"

@interface PlayViewController ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playItem;
@property (nonatomic, assign) BOOL isPlay;//是否正在播放
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bofangcishuLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//保存该视频资源的总时长， 快进或快退的时候要用
@property (nonatomic, assign) CGFloat totalSoundDuration;
//播放、暂停
@property (weak, nonatomic) IBOutlet UIButton *PlayBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *lastBtn;
//播放的slider
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
//控制音量的slider
@property (weak, nonatomic) IBOutlet UISlider *voiceSlider;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *voiceImage;
//缓冲条
@property (weak, nonatomic) IBOutlet UIProgressView *huanChongProgress;

@property (nonatomic , retain) id playbackObersver;

//当前播放的URL
@property (nonatomic, strong) NSString *nowURL;
//
////用于保存当前正在播放的Model
@property (nonatomic, strong) ZhuanJiModel *nowModel;
//记录是否轻拍
@property (nonatomic, assign) NSInteger isTap;

@end

@implementation PlayViewController

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static PlayViewController *playVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playVC = [super allocWithZone:zone];
    });
    return playVC;
}

+ (instancetype)sharePlayVC;
{
    return [[self alloc] init];
}

//返回上个界面按钮
- (IBAction)FanHui:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//隐藏状态条
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)setModel:(ZhuanJiModel *)model
{
    _model = model;
    [self setSubviewValue];
    
    [self removeObserver];
    
    if (self.playbackObersver) {
        [self.player removeTimeObserver:self.playbackObersver];
    }
    
    self.playItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:model.playUrl64]];
    [self.player replaceCurrentItemWithPlayerItem:self.playItem];
    [self addObserVerAction];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //设置一些默认值
    [self setValue];
    
    //添加播放器
    [self setAVPlayer];
    
    //添加手势隐藏音量滑杆
    [self addGestureRecongnizer];
}

- (void)addGestureRecongnizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissVoiceSlider:)];
    [self.imageView addGestureRecognizer:tap];
}

- (void)dismissVoiceSlider:(UITapGestureRecognizer *)tap
{
    if (!self.isTap) {
        
        [UIView animateWithDuration:0.2f animations:^{
            [self appearVoiceSlider];
        }];
    }else
    {
        [UIView animateWithDuration:0.2 animations:^{
            [self hideVoiceSlider];
        }];
    }
}

//隐藏音量滑杆
- (void)hideVoiceSlider
{
    self.voiceImage.transform = CGAffineTransformMakeTranslation(0, 0);
    self.voiceSlider.transform = CGAffineTransformMakeTranslation(0, 0);
    //设置音量滑杆为竖直方向
    self.voiceSlider.transform = CGAffineTransformRotate(self.voiceSlider.transform, -M_PI_2);
    self.voiceSlider.hidden = NO;
    self.voiceImage.hidden = NO;
    self.isTap = NO;
}

//显示音量滑杆
- (void)appearVoiceSlider
{
    //设置音量滑杆为竖直方向
    self.voiceSlider.transform = CGAffineTransformRotate(self.voiceSlider.transform, -M_PI_2);
    self.voiceImage.transform = CGAffineTransformMakeTranslation(-100, 0);
    self.voiceSlider.transform = CGAffineTransformMakeTranslation(-100, 0);
    self.voiceSlider.hidden = YES;
    self.voiceImage.hidden = YES;
    self.isTap = YES;
}

- (void)setValue
{
    //显示音量滑杆
    [self appearVoiceSlider];
    
    //设置背景为透明色， 以便露出底层模糊视图
    self.view.backgroundColor = [UIColor clearColor];
    
    //默认音量为 %50
    self.player.volume = 0.5;
    self.voiceSlider.value = 0.5;
    //设置音量滑杆为竖直方向
    self.voiceSlider.transform = CGAffineTransformRotate(self.voiceSlider.transform, -M_PI_2);
    
    //设置音量滑杆上的图片
    [self.voiceSlider setThumbImage:[UIImage imageNamed:@"playbar_slider_thumb@2x"] forState:UIControlStateNormal];
    
    //给图片设置圆角
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = self.imageView.bounds.size.width/2.0;
    
    //默认进入界面就开始播放
    self.PlayBtn.selected = YES;
    
    //设置进度条上的图片
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"playbar_slider_thumb@2x"] forState:UIControlStateNormal];
}

//设置进入界面时是否可以点击
- (void)securityDeal
{
    if (!self.model) {
        self.progressSlider.userInteractionEnabled = NO;
        self.lastBtn.userInteractionEnabled = NO;
        self.nextBtn.userInteractionEnabled = NO;
    }
    if (self.indexNum == 0) {
        self.lastBtn.enabled = NO;
    }else
    {
       self.lastBtn.enabled = YES;
    }
    
    if (self.indexNum == self.dataSource.count) {
        self.nextBtn.enabled = NO;
    }else
    {
        self.nextBtn.enabled = YES;
    }
}

- (void)setAVPlayer
{
    self.playItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.model.playUrl64]];
    [self.playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.playItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    //在通知中心添加观察者， 观察是否播放完毕
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SoundPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    self.player = [[AVPlayer alloc] init];
    [self.player replaceCurrentItemWithPlayerItem:self.playItem];
}

#pragma mark - KVO -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    //观察状态。是否可以播放
    if ([keyPath isEqualToString:@"status"]) {
        if (_playItem.status == AVPlayerItemStatusReadyToPlay) {
            [self.player play];
            self.PlayBtn.selected = YES;
            self.imageView.userInteractionEnabled = YES;
            
            CGFloat totalSeconds = [self getTotalSeconds];
            if (isnan(totalSeconds)) {
                self.progressSlider.userInteractionEnabled = NO;
                self.lastBtn.userInteractionEnabled = NO;
                self.nextBtn.userInteractionEnabled = NO;
            }else
            {
                self.progressSlider.maximumValue = totalSeconds;
                self.progressSlider.userInteractionEnabled = YES;
                self.lastBtn.userInteractionEnabled = YES;
                self.nextBtn.userInteractionEnabled = YES;
                
            }
            [self monitoringPlayback:self.playItem];
        } else  {
            NSLog(@"AVPlayerStatusFailed");
        }
    }
    
    //缓存
    if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSTimeInterval timeInterval = [self availableDuration];
        
        CGFloat totalDuration = CMTimeGetSeconds(self.playItem.duration);
    
        //设置缓冲条的已缓冲部分的颜色
        self.huanChongProgress.progressTintColor = [UIColor blueColor];
        //把比例赋给缓冲条
        [self.huanChongProgress setProgress: timeInterval / totalDuration animated:YES];
    }
}

//设置时间Label和滑动条
- (void)monitoringPlayback:(AVPlayerItem *)playItem
{
    __block PlayViewController *vc = self;
    __block UILabel *label = self.TimeLabel;
    __block UISlider *slider = self.progressSlider;
    
    self.playbackObersver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:nil usingBlock:^(CMTime time) {
        
        CGFloat currentSecond = CMTimeGetSeconds(time);
        [slider setValue:currentSecond animated:YES];
        label.text = [vc getTimeStr:currentSecond];
    }];
}

//计算缓冲
- (NSTimeInterval)availableDuration{
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    
    CMTimeRange  timeRange = [[loadedTimeRanges firstObject] CMTimeRangeValue];
    
    NSTimeInterval result = CMTimeGetSeconds(timeRange.duration) + CMTimeGetSeconds(timeRange.start);
    
    
    return result;
}

//获得总时长
- (CGFloat)getTotalSeconds{
    
    return CMTimeGetSeconds(_playItem.duration);
    
}

//转换时间
- (NSString *)getTimeStr:(CGFloat)time{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time - 8 * 3600];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    if (time / 3600 > 1) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    }else{
        [dateFormatter setDateFormat:@"mm:ss"];
    }
    NSString *timeStr = [dateFormatter stringFromDate:date];
    
    return timeStr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Play:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        [self.player play];
    }else
    {
        sender.selected = NO;
        [self.player pause];
    }
}
- (IBAction)nextBtn:(UIButton *)sender {
    _indexNum++;
    if (self.indexNum == self.dataSource.count) {
        self.nextBtn.enabled = NO;
        [self.nextBtn setImage:[UIImage imageNamed:@"NoNext"] forState:UIControlStateNormal];
    }else {
        self.model = self.dataSource[self.indexNum];
    }
    self.lastBtn.enabled = YES;
    [self.lastBtn setImage:[UIImage imageNamed:@"Last"] forState:UIControlStateNormal];
}

- (IBAction)lastBtn:(UIButton *)sender {
    if (self.indexNum!=0) {
        self.indexNum--;
    }
    if (self.indexNum == 0) {
        self.lastBtn.enabled = NO;
        [self.lastBtn setImage:[UIImage imageNamed:@"NoLast"] forState:UIControlStateNormal];
    }
    self.model = self.dataSource[self.indexNum];
    self.nextBtn.enabled = YES;
    [self.nextBtn setImage:[UIImage imageNamed:@"Next"] forState:UIControlStateNormal];
}

//调整音量
- (IBAction)voiceSlider:(UISlider *)sender {
    
    [self.player setVolume:sender.value];
    
    if (sender.value == 0) {
        self.voiceImage.image = [UIImage imageNamed:@"播放器_静音"];
    }else{
        self.voiceImage.image = [UIImage imageNamed:@"播放器_音量"];
    }
}

//播放完毕
- (void)SoundPlayDidEnd:(NSNotification *)notify
{
    if (_indexNum < _dataSource.count) {
        [self nextBtn:nil];
        [self.player play];
    }else{
        self.PlayBtn.selected = NO;
    }
}

//当拖拽slider时
- (IBAction)dragToMove:(UISlider *)sender {
    //当滑动滑杆时先暂停
    [self.player pause];
    //设置Button为暂停
    self.PlayBtn.selected = NO;
    [self.playItem seekToTime:CMTimeMultiplyByFloat64(self.self.playItem.duration, self.progressSlider.value / self.progressSlider.maximumValue)];
}

//当结束拖拽 并松开手指的时候
- (IBAction)loosenSlider:(UISlider *)sender {
    
    [self.player play];
    self.PlayBtn.selected = YES;
}

- (void)removeObserver
{
    [self.playItem
     removeObserver:self forKeyPath:@"status"];
    [self.playItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//添加观察者
- (void)addObserVerAction
{
    [self.playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.playItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SoundPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setSubviewValue];
    
    [self securityDeal];
}

- (void)setSubviewValue
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_model.coverMiddle] placeholderImage:nil];
    self.titleLabel.text = _model.title;
    self.bofangcishuLabel.text = [NSString stringWithFormat:@"▷播放%ld次", _model.playtimes];
    
    _lastBtn.enabled = YES;
    _nextBtn.enabled = YES;
    if (self.indexNum == 0) {
        
        _lastBtn.enabled = NO;
    }
    if (self.indexNum == _dataSource.count - 1) {
        _nextBtn.enabled = NO;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
