//
//  PlayerViewController.h
//  TestVideo
//
//  Created by BryanLi on 15/12/9.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerView.h"

@interface PlayerViewController : UIViewController

@property (weak, nonatomic) IBOutlet PlayerView *playerView;
@property (nonatomic, strong) AVPlayer *player;

+ (instancetype)sharePlayerViewController;
- (void)showInViewController:(UIViewController *)viewController playerView:(PlayerView *)playerView;

@end
