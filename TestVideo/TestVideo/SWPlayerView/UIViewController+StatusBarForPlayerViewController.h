//
//  UIViewController+StatusBarForPlayerViewController.h
//  TestVideo
//
//  Created by BryanLi on 15/12/10.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (StatusBarForPlayerViewController)

@property (nonatomic, assign) BOOL sw_isHiddenStatusBar;

- (BOOL)prefersStatusBarHidden;

@end
