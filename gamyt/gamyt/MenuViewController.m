//
//  MenuViewController.m
//  gamyt
//
//  Created by yons on 15-3-31.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "MenuViewController.h"
/*左侧菜单*/
#import "LeftMenuViewController.h"
/*下级上报*/
#import "HomeViewController.h"
#import "InfoViewController.h"
/*我的上报*/
#import "MyReportViewController.h"
/*我的公告*/
#import "MyNoticeViewController.h"
#import "NoticeViewController.h"
/*审阅信息*/
#import "CheckInfoViewController.h"
#import "SignReportTableViewController.h"
/*个人设置*/
#import "SettingViewController.h"

@interface MenuViewController ()<XDKAirMenuDelegate>{
    UINavigationController *nc1;
    UINavigationController *nc2;
    UINavigationController *nc3;
    UINavigationController *nc4;
    UINavigationController *nc5;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    XDKAirMenuController *menuCtr  = [XDKAirMenuController sharedInstance];
    menuCtr.airDelegate = self;
    self.airMenuController = menuCtr;
    self.airMenuController.isMenuOnRight = NO;
    [self.view addSubview:menuCtr.view];
    [self addChildViewController:menuCtr];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XDKAirMenuDelegate

- (UIViewController*)airMenu:(XDKAirMenuController*)airMenu viewControllerAtIndexPath:(NSIndexPath*)indexPath
{
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSArray *menus = [userdefaults objectForKey:@"menus"];
    
    UIViewController *vc ;
    NSDictionary *info = [menus objectAtIndex:indexPath.row];
    NSString *vcname = [info objectForKey:@"vcname"];
    

    if ([vcname isEqualToString:@"HomeViewController"]) {//下级上报
        if (nc1 == nil) {
            InfoViewController *info1 = [[self storyboard] instantiateViewControllerWithIdentifier: @"InfoViewController"];
            info1.title = @"全部";
            
            InfoViewController *info2 = [[self storyboard] instantiateViewControllerWithIdentifier: @"InfoViewController"];
            info2.title = @"未处理";
            info2.opttype = @"-1";
            
            InfoViewController *info3 = [[self storyboard] instantiateViewControllerWithIdentifier: @"InfoViewController"];
            info3.title = @"已归档";
            info3.opttype = @"1";
            
            InfoViewController *info4 = [[self storyboard] instantiateViewControllerWithIdentifier: @"InfoViewController"];
            info4.title = @"已上报";
            info4.opttype = @"3";
            
            InfoViewController *info5 = [[self storyboard] instantiateViewControllerWithIdentifier: @"InfoViewController"];
            info5.title = @"已录用";
            info5.opttype = @"5";
            
            NSMutableArray *vcs = [NSMutableArray array];
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            NSNumber *type = [userdefaults objectForKey:@"type"];
            switch ([type integerValue]) {
                case MANAGER://管理员(全部.未处理,已归档,已上报)
                    [vcs addObjectsFromArray:@[info1,info2,info3,info4]];
                    break;
                case COUNTY_MANAGER://省管理员
                case CITY_MANAGER://市管理员
                case SHENG_MANAGER://县管理员
                    //(全部,未处理,已归档,已上报,已录用)
                    [vcs addObjectsFromArray:@[info1,info2,info3,info4,info5]];
                    break;
                case SMANAGER:
                    //超级管理员(全部,未处理,已归档)
                    [vcs addObjectsFromArray:@[info1,info2,info3]];
                    break;
                default:
                    break;
            }
            HomeViewController *vc = [[HomeViewController alloc] initWithViewControllers:vcs];
            vc.view.backgroundColor = BACKGROUND_COLOR;
            vc.title = @"下级上报";
            vc.indicatorInsets = UIEdgeInsetsMake(0, 0, 8, 0);
            vc.indicator.backgroundColor = [UIColor colorWithRed:72/255.0 green:147/255.0 blue:219/255.0 alpha:1];
            nc1 = [[UINavigationController alloc] initWithRootViewController:vc];
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                nc1.navigationBar.tintColor = [UIColor whiteColor];
            }
            [nc1.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        }
        
        return nc1;
    }else if([vcname isEqualToString:@"MyNoticeViewController"]){//我的公告
        if (nc2 == nil) {
            NoticeViewController *notice1 = [[self storyboard] instantiateViewControllerWithIdentifier: @"NoticeViewController"];
            notice1.title = @"发送的公告";
            notice1.url = @"/mobile/notice/getNoticeHistory";
            notice1.type = @"1";
            NoticeViewController *notice2 = [[self storyboard] instantiateViewControllerWithIdentifier: @"NoticeViewController"];
            notice2.title = @"接受的公告";
            notice2.url = @"/mobile/notice/getReceiveNotice";
            notice2.type = @"2";
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            NSNumber *type = [userdefaults objectForKey:@"type"];
            NSMutableArray *arr = [NSMutableArray array];
            switch ([type integerValue]) {
                case MANAGER:
                case COUNTY_MANAGER:
                case CITY_MANAGER:
                case SHENG_MANAGER:
                case SMANAGER:
                    [arr addObjectsFromArray:@[notice1,notice2]];
                    break;
                default:
                    [arr addObjectsFromArray:@[notice2]];
                    break;
            }
            MyNoticeViewController *mynotice = [[MyNoticeViewController alloc] initWithViewControllers:arr];
            mynotice.view.backgroundColor = BACKGROUND_COLOR;
            mynotice.title = @"我的公告";
            mynotice.indicatorInsets = UIEdgeInsetsMake(0, 0, 8, 0);
            mynotice.indicator.backgroundColor = [UIColor colorWithRed:72/255.0 green:147/255.0 blue:219/255.0 alpha:1];
            nc2 = [[UINavigationController alloc] initWithRootViewController:mynotice];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                nc2.navigationBar.tintColor = [UIColor whiteColor];
            }
            [nc2.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        }
        return nc2;
    }else if([vcname isEqualToString:@"CheckInfoViewController"]){//审阅信息
        if (nc3 == nil) {
            SignReportTableViewController *vc1 = [[self storyboard] instantiateViewControllerWithIdentifier: @"SignReportTableViewController"];
            vc1.title = @"待审阅信息";
            vc1.type = @"1";
            SignReportTableViewController *vc2 = [[self storyboard] instantiateViewControllerWithIdentifier: @"SignReportTableViewController"];
            vc2.title = @"已审阅信息";
            vc2.type = @"2";
            CheckInfoViewController *vc = [[CheckInfoViewController alloc] initWithViewControllers:@[vc1,vc2]];
            vc.view.backgroundColor = BACKGROUND_COLOR;
            vc.title = @"审阅信息";
            vc.indicatorInsets = UIEdgeInsetsMake(0, 0, 8, 0);
            vc.indicator.backgroundColor = [UIColor colorWithRed:72/255.0 green:147/255.0 blue:219/255.0 alpha:1];
            nc3 = [[UINavigationController alloc] initWithRootViewController:vc];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                nc3.navigationBar.tintColor = [UIColor whiteColor];
            }
            [nc3.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        }
        return nc3;
    }else if ([vcname isEqualToString:@"MyReportViewController"]) {//我的上报
        if (nc4 == nil) {
            vc = [self.storyboard instantiateViewControllerWithIdentifier: vcname];
            nc4 = [[UINavigationController alloc] initWithRootViewController:vc];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                nc4.navigationBar.tintColor = [UIColor whiteColor];
            }
            [nc4.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        }
        return nc4;
    }else if([vcname isEqualToString:@"SettingViewController"]){//个人设置
        if (nc5 == nil) {
            vc = [self.storyboard instantiateViewControllerWithIdentifier: vcname];
            nc5 = [[UINavigationController alloc] initWithRootViewController:vc];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                nc5.navigationBar.tintColor = [UIColor whiteColor];
            }
            [nc5.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        }
        return nc5;
    }
    return vc;
}

- (UITableView*)tableViewForAirMenu:(XDKAirMenuController*)airMenu
{
    return self.tableView;
}

- (CGFloat)widthControllerForAirMenu:(XDKAirMenuController*)airMenu{
    return 120;
}

- (CGFloat)minScaleControllerForAirMenu:(XDKAirMenuController*)airMenu{
    return 1;
}

- (CGFloat)minScaleTableViewForAirMenu:(XDKAirMenuController*)airMenu{
    return 1;
}

- (CGFloat)minAlphaTableViewForAirMenu:(XDKAirMenuController*)airMenu{
    return 1;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TableViewSegue"])
    {
        self.tableView = ((UITableViewController*)segue.destinationViewController).tableView;
    }
}


@end
