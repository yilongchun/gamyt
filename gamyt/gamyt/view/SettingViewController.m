//
//  SettingViewController.m
//  gamyt
//
//  Created by yons on 15-3-4.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "SettingViewController.h"
#import "UserinfoViewController.h"
#import "UpdatePasswordTableViewController.h"
#import "QRcodeViewController.h"
#import "BPush.h"
#import "XDKAirMenuController.h"
#import "LoginViewController.h"


@implementation SettingViewController{
    NSString *trackViewUrl;
    UIActivityIndicatorView *indicatorView;
    UIAlertController *alert;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    UIImage *image = [UIImage imageNamed:@"menuchange_normal"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonPressed:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.tableView.rowHeight = 44.0f;
}

- (IBAction)menuButtonPressed:(id)sender
{
    XDKAirMenuController *menu = [XDKAirMenuController sharedInstance];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUnreadCount" object:self];
    if (menu.isMenuOpened)
        [menu closeMenuAnimated];
    else
        [menu openMenuAnimated];
}

#pragma mark - UITableView Delegate & Datasrouce -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //个人信息
            UserinfoViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"UserinfoViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1){
            //修改密码
            UpdatePasswordTableViewController * vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"UpdatePasswordTableViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 2){
            QRcodeViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"QRcodeViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
//        else if (indexPath.row == 3){
//            [self showStoreProductInApp:@"950217200"];
//        }
    }else{
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1){
            alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction actionWithTitle:@"退出登录"
                                                      style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction *action) {
                                                        //退出登陆
                                                        [self logout];
                                                    }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction *action) {
                                                    }]];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil];
            actionsheet.tag = 100;
            [actionsheet showInView:self.view];
        }
    }
    
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        if (buttonIndex == 0) {
            
            
            [self logout];
            
            
        }else{
            
        }
    }
}

-(void)logout{
    [XDKAirMenuController destroyDealloc];
    [BPush unbindChannel];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"isLogin"];
    NSArray *views = self.view.window.rootViewController.childViewControllers;
    LoginViewController *loginViewController = nil;
    NSMutableArray *deleteViews = [NSMutableArray array];
    for (UIViewController *view in views) {
        if ([view isKindOfClass:[LoginViewController class]]) {
            loginViewController = (LoginViewController *)view;
        }else{
            [deleteViews addObject:view];
//            [view removeFromParentViewController];
        }
    }
    if (loginViewController == nil) {
        loginViewController = [[UIStoryboard storyboardWithName:@"Main" bundle: nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    }
    loginViewController.account.text = @"";
    loginViewController.password.text = @"";
    UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:vc animated:YES completion:^{
        for (UIViewController *view in deleteViews) {
            [view removeFromParentViewController];
        }
        NSLog(@"1 %@",self.view.window.rootViewController);
        NSLog(@"2 %@",self.view.window.rootViewController.childViewControllers);
    }];
    
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==10000) {
        if (buttonIndex==1) {
            //进入应用商店
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
        }
    }
}

#pragma mark - private
//查看app商店信息
//- (void)showStoreProductInApp:(NSString *)appID{
//    Class isAllow = NSClassFromString(@"SKStoreProductViewController");
//    [self showIndicator];
//    if (isAllow != nil) {
//        SKStoreProductViewController *sKStoreProductViewController = [[SKStoreProductViewController alloc] init];
//        [sKStoreProductViewController.view setFrame:CGRectMake(0, 200, 320, 200)];
//        [sKStoreProductViewController setDelegate:self];
//        [sKStoreProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: appID}
//                                                completionBlock:^(BOOL result, NSError *error) {
//                                                    if (result) {
//                                                        [self hideIndicator];
//                                                        [self presentViewController:sKStoreProductViewController
//                                                                           animated:YES
//                                                                         completion:nil];
//                                                        
//                                                        
//                                                    }else{
//                                                        [self hideIndicator];
//                                                        NSLog(@"error:%@",error);
//                                                    }
//                                                }];
//    }else{
//        //低于iOS6的系统版本没有这个类,不支持这个功能
//        NSString *string = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/hui-min-jia-yuan-tong-jiao/id%@?mt=8&uo=4",appID];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
//    }
//}

-(void) productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//加载等待视图
- (void)showIndicator{
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
    | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:indicatorView];
    [indicatorView sizeToFit];
    [indicatorView startAnimating];
    indicatorView.center = self.view.center;
}

- (void)hideIndicator{
    [indicatorView stopAnimating];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    alert = nil;
    NSLog(@"viewDidDisappear");
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    alert = nil;
    NSLog(@"viewWillDisappear");
}

@end
