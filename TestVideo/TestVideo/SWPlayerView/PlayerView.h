//
//  PlayerView.h
//  TestVideo
//
//  Created by BryanLi on 15/12/9.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayerView : UIControl

@property (nonatomic, strong) AVPlayer *player;
@property (assign, nonatomic) AVPlayerStatus status;

@property (nonatomic, copy) void(^clickedBlock)(AVPlayer *player, PlayerView *playerView);

@end
