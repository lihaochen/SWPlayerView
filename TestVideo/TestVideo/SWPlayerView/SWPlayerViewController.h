//
//  PlayerViewController.h
//  TestVideo
//
//  Created by BryanLi on 15/12/9.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWPlayerView.h"

@interface SWPlayerViewController : UIViewController

@property (weak, nonatomic) IBOutlet SWPlayerView *playerView;
@property (nonatomic, strong) AVPlayer *player;

// 共享playerViewController-也可用alloc init，但之前的avPlyaer不会停止
+ (instancetype)sharePlayerViewController;
/**
 *  显示PlayerViewController,视频由原有palyerView扩大到屏幕大小
 *  PS: 也可用[self presentViewController:animate:]来调用
 *  PS2: 不可用push来弹出视图，会导致navigationbar在顶部
 *  @param viewController 弹出的viewController
 *  @param playerView     弹出的playerView
 */
- (void)showInViewController:(UIViewController *)viewController playerView:(SWPlayerView *)playerView;

@end
