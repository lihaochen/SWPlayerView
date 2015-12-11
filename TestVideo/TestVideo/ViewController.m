//
//  ViewController.m
//  TestVideo
//
//  Created by BryanLi on 15/12/8.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MainViewController.h"

@interface ViewController () <AVPlayerViewControllerDelegate>

@property (nonatomic, strong) AVPlayerViewController *playerViewController;
@property (nonatomic, strong) UIView *controlView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(push)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)push
{
    if (self.navigationController) {
        [self.navigationController pushViewController:[[MainViewController alloc] init] animated:YES];
    } else {
        [self presentViewController:[[MainViewController alloc] init] animated:YES completion:nil];
    }
    
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [self performSelector:@selector(pushVideo) withObject:nil afterDelay:0];
//    [self pushVideo];
//}

- (void)pushVideo
{
//    NSURL *videoURL = [NSURL URLWithString:@"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
//    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
//    _playerViewController = [AVPlayerViewController new];
//    _playerViewController.delegate = self;
//    _playerViewController.player = player;
//    // 上下的bar
//    _playerViewController.showsPlaybackControls = YES;
//    // 可添加customControl
//    [_playerViewController.contentOverlayView addSubview:self.controlView];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TimeJumped) name:AVPlayerItemTimeJumpedNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidPlayToEndTime) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FailedToPlayToEndTime) name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PlaybackStalled) name:AVPlayerItemPlaybackStalledNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NewAccessLogEntry) name:AVPlayerItemNewAccessLogEntryNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NewErrorLogEntry) name:AVPlayerItemNewErrorLogEntryNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AVPlayerItemFailedToPlayToEndTimeErrorKey) name:AVPlayerItemFailedToPlayToEndTimeErrorKey object:nil];
//    [self presentViewController:_playerViewController animated:YES completion:nil];
    self.view.backgroundColor = [UIColor redColor];
    
//    MPMoviePlayerViewController *playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:@"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"]];
//    playerController.moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
//    playerController.moviePlayer.shouldAutoplay = YES;
//    playerController.moviePlayer.repeatMode = MPMovieRepeatModeOne;
//    [playerController.moviePlayer setFullscreen:YES animated:YES];
//    playerController.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
//    [playerController.moviePlayer play];
////    [self presentViewController:playerController animated:YES completion:nil];
//    playerController.view.frame = CGRectMake(0, 0, 320, 200);
//    [self.view addSubview:playerController.view];
}

- (UIView *)controlView
{
    if (!_controlView) {
        _controlView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 100)];
            view.backgroundColor = [UIColor redColor];
            view;
        });
    }
    return _controlView;
}

#pragma mark -- notification method
- (void)TimeJumped
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}
- (void)DidPlayToEndTime
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}
- (void)FailedToPlayToEndTime
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}
- (void)PlaybackStalled
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}
- (void)NewAccessLogEntry
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}
- (void)NewErrorLogEntry
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}
- (void)AVPlayerItemFailedToPlayToEndTimeErrorKey
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

#pragma mark -- <AVPlayerViewControllerDelegate>

/*!
	@method		playerViewControllerWillStartPictureInPicture:
	@param		playerViewController
 The player view controller.
	@abstract	Delegate can implement this method to be notified when Picture in Picture will start.
 */
- (void)playerViewControllerWillStartPictureInPicture:(AVPlayerViewController *)playerViewController
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

/*!
	@method		playerViewControllerDidStartPictureInPicture:
	@param		playerViewController
 The player view controller.
	@abstract	Delegate can implement this method to be notified when Picture in Picture did start.
 */
- (void)playerViewControllerDidStartPictureInPicture:(AVPlayerViewController *)playerViewController
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

/*!
	@method		playerViewController:failedToStartPictureInPictureWithError:
	@param		playerViewController
 The player view controller.
	@param		error
 An error describing why it failed.
	@abstract	Delegate can implement this method to be notified when Picture in Picture failed to start.
 */
- (void)playerViewController:(AVPlayerViewController *)playerViewController failedToStartPictureInPictureWithError:(NSError *)error
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

/*!
	@method		playerViewControllerWillStopPictureInPicture:
	@param		playerViewController
 The player view controller.
	@abstract	Delegate can implement this method to be notified when Picture in Picture will stop.
 */
- (void)playerViewControllerWillStopPictureInPicture:(AVPlayerViewController *)playerViewController
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

/*!
	@method		playerViewControllerDidStopPictureInPicture:
	@param		playerViewController
 The player view controller.
	@abstract	Delegate can implement this method to be notified when Picture in Picture did stop.
 */
- (void)playerViewControllerDidStopPictureInPicture:(AVPlayerViewController *)playerViewController
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

/*!
	@method		playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart:
	@param		playerViewController
 The player view controller.
	@abstract	Delegate can implement this method and return NO to prevent player view controller from automatically being dismissed when Picture in Picture starts.
 */
- (BOOL)playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart:(AVPlayerViewController *)playerViewController
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return YES;
}

/*!
	@method		playerViewController:restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:
	@param		playerViewController
 The player view controller.
	@param		completionHandler
 The completion handler the delegate needs to call after restore.
	@abstract	Delegate can implement this method to restore the user interface before Picture in Picture stops.
 */
- (void)playerViewController:(AVPlayerViewController *)playerViewController restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL restored))completionHandler
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)viewDidAppear:(BOOL)animated
{
//    if (self.navigationController) {
//        [self.navigationController pushViewController:[[MainViewController alloc] init] animated:YES];
//    } else {
//        [self presentViewController:[[MainViewController alloc] init] animated:YES completion:nil];
//    }
}

@end



















