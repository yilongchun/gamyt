//
//  SettingViewController.h
//  gamyt
//
//  Created by yons on 15-3-4.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import <StoreKit/StoreKit.h>

@interface SettingViewController : UIViewController<SlideNavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate,SKStoreProductViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong) UIAlertController *alert;
@property (nonatomic, strong) UIAlertView *alert2;

@end
