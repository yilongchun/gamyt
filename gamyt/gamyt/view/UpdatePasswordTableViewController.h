//
//  UpdatePasswordTableViewController.h
//  gamyt
//
//  Created by yons on 15-3-23.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatePasswordTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *oldpwdLabel;
@property (weak, nonatomic) IBOutlet UITextField *newpwdLabel;
@property (weak, nonatomic) IBOutlet UITextField *newpwd2Label;
- (IBAction)save:(id)sender;
@end
