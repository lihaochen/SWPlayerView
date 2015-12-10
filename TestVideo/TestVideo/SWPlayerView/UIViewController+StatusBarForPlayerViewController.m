//
//  UIViewController+StatusBarForPlayerViewController.m
//  TestVideo
//
//  Created by BryanLi on 15/12/10.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "UIViewController+StatusBarForPlayerViewController.h"
#import <objc/runtime.h>

@implementation UIViewController (StatusBarForPlayerViewController)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (BOOL)prefersStatusBarHidden
{
    return self.sw_isHiddenStatusBar;
}
#pragma clang diagnostic pop

- (BOOL)sw_isHiddenStatusBar
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setSw_isHiddenStatusBar:(BOOL)sw_isHiddenStatusBar
{
    SEL key = @selector(sw_isHiddenStatusBar);
    objc_setAssociatedObject(self, key, @(sw_isHiddenStatusBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
