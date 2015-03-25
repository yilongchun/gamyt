//
//  SignReportTableViewController.h
//  gamyt
//
//  Created by yons on 15-3-24.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+PullLoad.h"

@interface SignReportTableViewController : UITableViewController<PullDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *type;

@end
