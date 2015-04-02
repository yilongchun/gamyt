//
//  MainViewController.h
//  gamyt
//  我的上报
//  Created by yons on 15-3-3.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SlideNavigationController.h"
#import "UIScrollView+PullLoad.h"

@interface MyReportViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,PullDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end
