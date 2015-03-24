//
//  FindPasswordViewController.h
//  gamyt
//
//  Created by yons on 15-3-3.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindPasswordViewController : UITableViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *idcard;
- (IBAction)find:(id)sender;
@end
