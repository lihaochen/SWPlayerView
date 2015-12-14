//
//  TableViewCell.h
//  TestVideo
//
//  Created by BryanLi on 15/12/9.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWPlayerView.h"

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet SWPlayerView *playerView;

@end
