//
//  PlayerView.m
//  TestVideo
//
//  Created by BryanLi on 15/12/9.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "PlayerView.h"

@interface PlayerView ()

@property (nonatomic, strong) UIImageView *imageView;

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
    [self imageView];
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
    [self.player removeObserver:self forKeyPath:@"status"];
    self.status = self.player.status;
    [player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

#pragma mark - 播放标识
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            imageView.image = [UIImage imageNamed:@"btn_play_large@2X"];
            imageView.center = CGPointMake(CGRectGetWidth(self.bounds)/2.f, CGRectGetHeight(self.bounds)/2.f);
            imageView.hidden = YES;
            [self addSubview:imageView];
            imageView;
        });
    }
    return _imageView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        self.status = [(AVPlayer *)object status];
        NSLog(@"%ld", self.status);
        if (self.status == AVPlayerStatusReadyToPlay) {
            self.imageView.hidden = NO;
            [self.player pause];
        }
    }
}

- (void)dealloc
{
    [self.player removeObserver:self forKeyPath:@"status"];
}

@end


























