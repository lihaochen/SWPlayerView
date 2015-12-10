//
//  PlayerViewController.m
//  TestVideo
//
//  Created by BryanLi on 15/12/9.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "PlayerViewController.h"
#import "AppDelegate.h"

#define duration 0.5
@interface PlayerViewController ()
{
    CGRect rect;
}

@property (nonatomic, weak) PlayerView *originPlayerView;
@property (nonatomic, weak) UIViewController *originViewController;

@end

@implementation PlayerViewController

- (void)loadView
{
    self.view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playerView.player = self.player;
    [self.playerView.player play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [self.view addGestureRecognizer:tapGesture];
    
    
}

- (void)back
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.originViewController.sw_isHiddenStatusBar = NO;
        [weakSelf.originViewController setNeedsStatusBarAppearanceUpdate];
        self.playerView.transform = CGAffineTransformMakeRotation(0);
        self.playerView.frame = [self.originPlayerView convertRect:self.originPlayerView.bounds toView:WINDOW];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)showInViewController:(UIViewController *)viewController playerView:(PlayerView *)playerView
{
    self.originPlayerView = playerView;
    self.originViewController = viewController;
    
    [viewController addChildViewController:self];
    [viewController.view addSubview:self.view];
    
    self.playerView.frame = [playerView convertRect:playerView.bounds toView:WINDOW];
    
    __weak typeof(viewController) blockVC = viewController;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        /**
         *  隐藏状态栏
         */
        blockVC.sw_isHiddenStatusBar = YES;
        [blockVC setNeedsStatusBarAppearanceUpdate];
        /**
         *  放大和转向
         */
        self.playerView.frame = self.view.bounds;
        [self orientChange:nil];
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)orientChange:(NSNotification *)notif
{
    UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
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
            frame = CGRectMake(0, 0, size.width, size.height);
            angle = 0;
            break;
    }
    
    self.playerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.playerView.transform = CGAffineTransformMakeRotation(angle);
        self.playerView.bounds = frame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end























