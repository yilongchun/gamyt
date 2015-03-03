//
//  ViewController.m
//  gamyt
//
//  Created by yons on 15-3-3.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
    UIImageView *usernameImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 20, 20)];
    [usernameImg setImage:[UIImage imageNamed:@"login_username_icon.png"]];
    [leftview addSubview:usernameImg];
    self.account.leftViewMode = UITextFieldViewModeAlways;
    self.account.leftView = leftview;
    
    UIView *leftview2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
    UIImageView *passwordImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 20, 20)];
    [passwordImg setImage:[UIImage imageNamed:@"login_password_icon.png"]];
    [leftview2 addSubview:passwordImg];
    self.password.leftViewMode = UITextFieldViewModeAlways;
    self.password.leftView = leftview2;
    
    [self.account setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.password setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.account setTintColor:[UIColor whiteColor]];
    [self.password setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"返回";
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil]];
    
//    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [textField setBackgroundColor:[UIColor colorWithRed:26/255.0 green:73/255.0 blue:130/255.0 alpha:1.0]];
    
    NSLog(@"textFieldDidBeginEditing");
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField setBackgroundColor:[UIColor colorWithRed:36/255.0 green:102/255.0 blue:171/255.0 alpha:1.0]];
    NSLog(@"textFieldDidEndEditing");
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
