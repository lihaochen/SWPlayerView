//
//  PlayerView.h
//  TestVideo
//
//  Created by BryanLi on 15/12/9.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AVPlayer+SWPlayerControl.h"

@interface PlayerView : UIControl

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, assign) AVPlayerStatus status;
@property (nonatomic, assign) SWPlayerControlState playState;

@property (nonatomic, copy) void(^clickedBlock)(AVPlayer *player, PlayerView *playerView);

@end
