//
//  PlayerView.m
//  TestVideo
//
//  Created by BryanLi on 15/12/9.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "PlayerView.h"

@interface PlayerView ()
{
    BOOL isFirst;
}

@property (nonatomic, strong) UIImageView *playIdentityView;


@end

@implementation PlayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor blackColor];
    [self playIdentityView];
    AVPlayerLayer *layer = (AVPlayerLayer *)self.layer;
    layer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clicked
{
    if (self.status == AVPlayerStatusReadyToPlay) {
        if (self.clickedBlock) {
            self.clickedBlock(self.player, self);
        }
    }
}

#pragma mark - 基础设置
+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (AVPlayer *)player
{
    return [(AVPlayerLayer *)self.layer player];
}

- (void)setPlayer:(AVPlayer *)player {
    isFirst = YES;
    
    [self.player removeObserver:self forKeyPath:@"status"];
    [self.player removeObserver:self forKeyPath:@"playState"];
//    NSDictionary *observerInfo = self.player.observationInfo;
    
    self.status = self.player.status;
    self.playState = self.player.playState;
    
    // 改变player后
    [player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [player addObserver:self forKeyPath:@"playState" options:NSKeyValueObservingOptionNew context:nil];
    [player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
    
    // 设置新player
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

- (void)setPlayState:(SWPlayerControlState)playState
{
    _playState = playState;
    if (playState == SWPlayerControlStatePlay) {
        self.playIdentityView.hidden = YES;
    } else {
        self.playIdentityView.hidden = NO;
    }
}

#pragma mark - 播放标识
- (UIImageView *)playIdentityView
{
    if (!_playIdentityView) {
        _playIdentityView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            imageView.image = [UIImage imageNamed:@"btn_play_large@2X"];
            imageView.center = CGPointMake(CGRectGetWidth(self.bounds)/2.f, CGRectGetHeight(self.bounds)/2.f);
            imageView.hidden = YES;
            imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            [self addSubview:imageView];
            imageView;
        });
    }
    return _playIdentityView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        self.status = [(AVPlayer *)object status];
        if (isFirst) {
            self.playIdentityView.hidden = NO;
            [self.player sw_pause];
        }
    } else if ([keyPath isEqualToString:@"playState"]) {
        self.playState = self.player.playState;
    } else if ([keyPath isEqualToString:@"rate"]) {
        if (self.player.rate == 0 && self.player.playState == SWPlayerControlStatePlay) {
            // loading
            
        }
    }
}


    
- (void)dealloc
{
    [self.player removeObserver:self forKeyPath:@"status"];
    [self.player removeObserver:self forKeyPath:@"playState"];
//    [self.player removeTimeObserver:self];
}

@end


























