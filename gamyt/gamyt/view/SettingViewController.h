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

@interface SettingViewController : UITableViewController<SlideNavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,SKStoreProductViewControllerDelegate>


@property (nonatomic, strong) UIAlertController *alert;
@property (nonatomic, strong) UIAlertView *alert2;

@end
