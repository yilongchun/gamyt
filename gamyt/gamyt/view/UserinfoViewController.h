//
//  UserinfoViewController.h
//  gamyt
//
//  Created by yons on 15-3-17.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserinfoViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *unitname;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UILabel *idcard;
@property (weak, nonatomic) IBOutlet UILabel *property;
@property (weak, nonatomic) IBOutlet UILabel *point;
@property (weak, nonatomic) IBOutlet UILabel *pointlevel;
@property (weak, nonatomic) IBOutlet UITextField *bank;
@property (weak, nonatomic) IBOutlet UITextField *bankcard;
@property (weak, nonatomic) IBOutlet UITextField *bankaddress;
@end
