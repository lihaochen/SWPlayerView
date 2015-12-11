//
//  AVPlayer+SWPlayerControl.h
//  TestVideo
//
//  Created by BryanLi on 15/12/11.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

typedef enum {
    SWPlayerControlStatePause,
    SWPlayerControlStatePlay,
    SWPlayerControlStatestop
} SWPlayerControlState;

@interface AVPlayer (SWPlayerControl)

@property (nonatomic, assign) SWPlayerControlState playState;
@property (nonatomic, copy) void(^timeObserverBlock)(CMTime time);

- (void)sw_play;
- (void)sw_pause;
- (void)sw_stop;

// 改变音量
- (void)changeAudioWithFloat:(CGFloat)sound;

@end
