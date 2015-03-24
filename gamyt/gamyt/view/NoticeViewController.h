//
//  NoticeViewController.h
//  gamyt
//
//  Created by yons on 15-3-23.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+PullLoad.h"

@interface NoticeViewController : UITableViewController<PullDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *type;

@end
