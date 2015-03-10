//
//  TestViewController.h
//  gamyt
//
//  Created by yons on 15-3-5.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+PullLoad.h"

@interface InfoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,PullDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *opttype;

@end
