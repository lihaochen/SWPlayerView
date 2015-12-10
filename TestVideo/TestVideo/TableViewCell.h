//
//  TableViewCell.h
//  TestVideo
//
//  Created by BryanLi on 15/12/9.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerView.h"

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PlayerView *playerView;

@end
