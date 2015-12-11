//
//  PlayerViewController.m
//  TestVideo
//
//  Created by BryanLi on 15/12/9.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "PlayerViewController.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"
#import "UIViewController+StatusBarForPlayerViewController.h"

#define WINDOW ((AppDelegate *)([UIApplication sharedApplication].delegate)).window
#define DURATION 0.5
@interface PlayerViewController ()
{
    BOOL scrollEnable;  // if originViewController is scrollView need.
}

@property (weak, nonatomic) IBOutlet UIView *playControlView;
@property (weak, nonatomic) IBOutlet UIButton *playbackButton;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, weak) UIViewController *originViewController;
@property (nonatomic, weak) UIViewController *real_parentViewController;
@property (nonatomic, weak) PlayerView *originPlayerView;

@property (nonatomic, weak) void(^ timeObserverBlock)(CMTime time);

@end

@implementation PlayerViewController

+ (instancetype)sharePlayerViewController
{
    static PlayerViewController *playerViewController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerViewController = [[PlayerViewController alloc] init];
    });
    return playerViewController;
}

- (void)loadView
{
    self.view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.timeSlider setThumbImage:[UIImage imageNamed:@"RECORD@3X"] forState:UIControlStateNormal];
    [self.timeSlider setMinimumTrackTintColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5]];
    [self.timeSlider setMaximumTrackTintColor:[[UIColor whiteColor] colorWithAlphaComponent:0.1]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [self.view addGestureRecognizer:self.tapGesture];
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:self.panGesture];
    UITapGestureRecognizer *barTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(barTapGesture:)];
    [self.playControlView addGestureRecognizer:barTapGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.playerView.player = self.player;
    // 通过设置timeObserverBlock来设置每时每刻的事件
    self.playerView.player.timeObserverBlock = self.timeObserverBlock;
    [self.playerView.player sw_play];
    self.playbackButton.selected = NO;
    
    // bar隐藏
    self.playControlView.alpha = 0;
    // bar显示
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [weakSelf showPlayerControlView];
            [weakSelf hiddenPlayerControlView];
        } completion:nil];
    });
    
    [self.playerView.player changeAudioWithFloat:1];
}

- (void (^)(CMTime))timeObserverBlock
{
//    self.player.currentItem.currentTime
    __weak typeof(self) weakSelf = self;
    return ^(CMTime time) {
//        NSLog(@"value: %l, timescale: %l, current : %lf", time.value, time.timescale, (CGFloat)time.value/time.timescale);
        //获取总时长
        CGFloat totalTime = CMTimeGetSeconds(weakSelf.playerView.player.currentItem.duration);
        // 获取当前时长
        CGFloat nowTime = (CGFloat)time.value/time.timescale;
        
        // 事件格式转换
        weakSelf.startLabel.text = [self transformTimerWithInterval:nowTime];
        weakSelf.endLabel.text = [self transformTimerWithInterval:totalTime];
        weakSelf.timeSlider.value = nowTime/totalTime;
        if (nowTime == totalTime) {
            [weakSelf.player sw_pause];
        }
    };
}

// 时间转换
- (NSString *)transformTimerWithInterval:(NSTimeInterval)seconds
{
    // 转换时间
    NSString *string = @"00:00";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm:ss"];
    NSDate *date = [formatter dateFromString:string];
    NSDate *resultDate = [date dateByAddingTimeInterval:seconds];
    NSString *resultString = [formatter stringFromDate:resultDate];
    // 更新界面
    return resultString;
}

- (void)setPlayer:(AVPlayer *)player
{
    [_player sw_pause];
    _player = nil;
    _player = player;
}

- (void)panGesture:(UIPanGestureRecognizer *)gesture
{
//    CGPoint locationPoint = [gesture locationInView:self.view];
    CGPoint translationPoint = [gesture translationInView:self.view];
//    BOOL isVolume;
    
    NSLog(@"%@", NSStringFromCGPoint(translationPoint));
}

- (void)barTapGesture:(UITapGestureRecognizer *)gesture
{
    [self showPlayerControlView];
    [self hiddenPlayerControlView];
}

- (IBAction)playButtonClicked:(UIButton *)sender {
    // 播放按钮点击
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.playerView.player sw_pause];
    } else {
        [self.playerView.player sw_play];
    }
    [self showPlayerControlView];
    [self hiddenPlayerControlView];
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    // 滑条滑动
    [self.playerView.player pause];
    CGFloat totalTime = CMTimeGetSeconds(self.playerView.player.currentItem.duration);
    [self.playerView.player seekToTime:CMTimeMake(sender.value*totalTime, 1) toleranceBefore:CMTimeMake(1, 1) toleranceAfter:CMTimeMake(1, 1)];
}

- (IBAction)sliderTouchDown:(UISlider *)sender {
    [self showPlayerControlView];
}

- (IBAction)sliderTouchUpInside:(UISlider *)sender {
    [self.playerView.player play];
    [self hiddenPlayerControlView];
}

- (void)showPlayerControlView
{
    self.playControlView.alpha = 1;
}

- (void)hiddenPlayerControlView
{
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakSelf.playControlView.alpha = 0.5;
        } completion:nil];
    });
}

- (void)back
{
    [self.playerView.player changeAudioWithFloat:0];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:DURATION delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        weakSelf.sw_isHiddenStatusBar = NO;
        weakSelf.real_parentViewController.sw_isHiddenStatusBar = NO;
        [weakSelf.real_parentViewController setNeedsStatusBarAppearanceUpdate];
        self.playerView.transform = CGAffineTransformMakeRotation(0);
        self.playerView.frame = [self.originPlayerView convertRect:self.originPlayerView.bounds toView:WINDOW];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        if ([self.originViewController.view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)self.originViewController.view;
            scrollView.scrollEnabled = scrollEnable;
        }
    }];
}

- (void)showInViewController:(UIViewController *)viewController playerView:(PlayerView *)playerView
{
    self.originPlayerView = playerView;
    self.real_parentViewController = viewController;
    self.originViewController = viewController.navigationController ? viewController.navigationController : viewController;
    
    // 添加视图
    [self.originViewController addChildViewController:self];
    [self.originViewController.view addSubview:self.view];
    
    
    if ([self.originViewController.view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.originViewController.view;
        scrollEnable = scrollView.scrollEnabled;
        scrollView.scrollEnabled = NO;
        self.view.frame = CGRectMake(0, scrollView.contentOffset.y, CGRectGetWidth(self.originViewController.view.bounds), CGRectGetHeight(self.originViewController.view.bounds));
    }
    
    self.playerView.frame = [playerView convertRect:playerView.bounds toView:WINDOW];
    
    __weak typeof(viewController) blockVC = viewController;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:DURATION delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        blockVC.sw_isHiddenStatusBar = YES;
        [blockVC setNeedsStatusBarAppearanceUpdate];
        weakSelf.sw_isHiddenStatusBar = YES;
        [weakSelf setNeedsStatusBarAppearanceUpdate];
        
        NSNotification *notif = [[NSNotification alloc] initWithName:@"first" object:nil userInfo:nil];
        [self orientChange:notif];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)orientChange:(NSNotification *)notif
{
    UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGRect frame;
    CGFloat angle;
    switch (orient)
    {
        case UIDeviceOrientationPortrait:
            frame = CGRectMake(0, 0, size.width, size.height);
            angle = 0;
            break;
        case UIDeviceOrientationLandscapeLeft:
            frame = CGRectMake(0, 0, size.height, size.width);
            angle = M_PI/2.f;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            frame = CGRectMake(0, 0, size.width, size.height);
            angle = M_PI;
            break;
        case UIDeviceOrientationLandscapeRight:
            frame = CGRectMake(0, 0, size.height, size.width);
            angle = -M_PI/2.f;
            break;
        default:
            if ([notif.name isEqualToString:@"first"]) {
                frame = CGRectMake(0, 0, size.width, size.height);
                angle = 0;
            } else {
                return;
            }
            
            break;
    }
    
    self.playerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    [UIView animateWithDuration:DURATION delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.playerView.transform = CGAffineTransformMakeRotation(angle);
        self.playerView.bounds = frame;
        self.playerView.center = self.view.superview.center;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end























