//
//  InfoToUpViewController.m
//  gamyt
//
//  Created by yons on 15-3-16.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "InfoToUpViewController.h"

@implementation InfoToUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancel:(id)sender{
    NSString *title = @"确定退出?";
    NSString *message = @"离开后,您操作后的信息将不再保存!";
    if ([[UIDevice currentDevice] systemVersion].floatValue < 8.0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1;
        [alert show];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSLog(@"确定");
            [self cancelAndBack];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
    
}

- (IBAction)save:(id)sender {
    NSLog(@"上报");
}

-(void)cancelAndBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {//确定
            NSLog(@"确定");
            [self cancelAndBack];
        }
    }
}


@end
