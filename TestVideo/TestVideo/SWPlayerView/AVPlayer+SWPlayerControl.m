//
//  AVPlayer+SWPlayerControl.m
//  TestVideo
//
//  Created by BryanLi on 15/12/11.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "AVPlayer+SWPlayerControl.h"
#import <objc/runtime.h>

@implementation AVPlayer (SWPlayerControl)

- (SWPlayerControlState)playState
{
    return (int)[objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setPlayState:(SWPlayerControlState)playState
{
    SEL key = @selector(playState);
    objc_setAssociatedObject(self, key, @(playState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(CMTime))timeObserverBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTimeObserverBlock:(void (^)(CMTime))timeObserverBlock
{
    SEL key = @selector(timeObserverBlock);
    objc_setAssociatedObject(self, key, timeObserverBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)sw_play
{
    [self play];
    self.playState = SWPlayerControlStatePlay;
    __weak typeof(self) weakSelf = self;
    [self addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
//         NSLog(@"value: %lf, timescale: %lf, current : %lf", time.value, time.timescale, time.value/time.timescale);
        if (weakSelf.timeObserverBlock) {
            weakSelf.timeObserverBlock(time);
        }
    }];
}

- (void)sw_pause
{
    [self pause];
//    [self removeTimeObserver:self];
    
    self.playState = SWPlayerControlStatePause;
}

- (void)sw_stop
{
    [self pause];
//    [self removeTimeObserver:self];
    
    self.playState = SWPlayerControlStateStop;
    [self.currentItem.asset cancelLoading];
}


- (void)changeAudioWithFloat:(CGFloat)sound
{
    NSArray *audioTracks = [self.currentItem.asset tracksWithMediaType:AVMediaTypeAudio];
    NSMutableArray *allAudioParams = [NSMutableArray array];
    for (AVAssetTrack *track in audioTracks) {
        AVMutableAudioMixInputParameters *audioInputParams =
        [AVMutableAudioMixInputParameters audioMixInputParameters];
        [audioInputParams setVolume:sound atTime:kCMTimeZero];
        [audioInputParams setTrackID:[track trackID]];
        [allAudioParams addObject:audioInputParams];
    }
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    [audioMix setInputParameters:allAudioParams];
    [self.currentItem setAudioMix:audioMix];
}

@end













