//
//  ViewController.m
//  gamyt
//
//  Created by yons on 15-3-3.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "InfoViewController.h"
#import "MyNoticeViewController.h"
#import "NoticeViewController.h"
#import "SignReportTableViewController.h"
#import "CheckInfoViewController.h"
#import "BPush.h"

#import "MenuViewController.h"

@interface LoginViewController (){
    NSString *channelid;
    NSString *pushuserid;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(loginStateChange:)
//                                                 name:KNOTIFICATION_LOGINCHANGE
//                                               object:nil];
    
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
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        [self.account setTintColor:[UIColor whiteColor]];
        [self.password setTintColor:[UIColor whiteColor]];
    }
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"返回";
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
//    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
    
    
//    self.account.text = @"18972590049";//超级管理员:18972590049 111111
//    self.account.text = @"15171873787";//省级管理员:15171873787 111111
//    self.account.text = @"18972590038";//市级管理员:18972590038 111111
//    self.account.text = @"18972592846";//县级管理员:18972592846 111111
//    self.account.text = @"18972593062";//管理员:18972593062 111111
//    self.account.text = @"18972593000";//审阅员:18972593057 111111
//    self.account.text = @"11111111111";
//    self.account.text = @"15671055205";//会员:15671055205 111111
//    self.password.text = @"111111";
    
    
    
}



- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField setBackgroundColor:[UIColor colorWithRed:26/255.0 green:73/255.0 blue:130/255.0 alpha:1.0]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField setBackgroundColor:[UIColor colorWithRed:36/255.0 green:102/255.0 blue:171/255.0 alpha:1.0]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSNumber *isLogin = [ud objectForKey:@"isLogin"];
//    if ([isLogin boolValue]) {
//        [self goToHome:NO];
//    }
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *) gen_uuid
{
    CFUUIDRef uuid_ref=CFUUIDCreate(nil);
    CFStringRef uuid_string_ref=CFUUIDCreateString(nil, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid=[NSString stringWithString:(__bridge NSString *)(uuid_string_ref)];
    CFRelease(uuid_string_ref);
    return uuid;
}

//登录
- (IBAction)login:(id)sender {
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    if (self.account.text.length == 0) {
        [self showHintInCenter:@"请输入账号"];
        return;
    }
    if (self.password.text.length == 0) {
        [self showHintInCenter:@"请输入密码"];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[self gen_uuid] forKey:@"deviceid"];
    [parameters setValue:@"4" forKey:@"devicetype"];
    [parameters setValue:self.password.text forKey:@"pwd"];
    [parameters setValue:self.account.text forKey:@"username"];
    
    
    
    [self showHudInView:self.view hint:@"加载中"];
    NSString *str = [NSString stringWithFormat:@"%@%@",[Utils getHostname],@"/mobile/user/login"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30.0];
    //JSON格式
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"content-type"];
    NSString *post=[NSString jsonStringWithDictionary:parameters];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [request setHTTPBody:postData];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        NSLog(@"获取到的数据为：%@",dict);
        NSDictionary *resultDict = [NSDictionary cleanNullForDic:dict];
        if (resultDict == nil) {
            NSLog(@"json parse failed \r\n");
        }else{
            NSLog(@"%@",resultDict);
        }
        NSNumber *code = [resultDict objectForKey:@"code"];
        [self hideHud];
        if ([code intValue] == 1) {
            
            [self showHintInCenter:@"用户名或密码错误"];
        }else if([code intValue] == 0){
            NSDictionary *data = [resultDict objectForKey:@"data"];
            NSString *token = [data objectForKey:@"token"];
            NSDictionary *users = [NSDictionary cleanNullForDic:[data objectForKey:@"users"]];
            NSDictionary *notes = [NSDictionary cleanNullForDic:[data objectForKey:@"notes"]];
            NSNumber *userid = [users objectForKey:@"id"];
            NSNumber *type = [users objectForKey:@"type"];
            
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            [userdefaults setObject:users forKey:@"users"];
            [userdefaults setObject:notes forKey:@"notes"];
            [userdefaults setObject:type forKey:@"type"];
            [userdefaults setValue:token forKey:@"token"];
            [userdefaults setValue:userid forKey:@"userid"];
            [userdefaults setObject:[NSNumber numberWithInt:1] forKey:@"isLogin"];
            [self bindChannel];
            [self goToHome:YES];
            
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self hideHud];
        [self showHint:@"连接失败"];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

-(void)bindChannel{
    if (!SIMULATOR) {
        [BPush bindChannel];
        
        NSString *str = [NSString stringWithFormat:@"%@%@",[Utils getHostname],@"/mobile/user/updatePushInfo"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setTimeoutInterval:30.0];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        if ([BPush getChannelId] && [BPush getChannelId].length != 0) {
            channelid = [BPush getChannelId];
            [ud setObject:channelid forKey:@"channelid"];
        }else{
            channelid = [ud objectForKey:@"channelid"];
        }
        if ([BPush getUserId] && [BPush getUserId].length != 0) {
            pushuserid = [BPush getUserId];
            [ud setObject:pushuserid forKey:@"pushUserId"];
        }else{
            pushuserid = [ud objectForKey:@"pushUserId"];
        }
        
        //非JSON格式
        NSString *param = [NSString stringWithFormat:@"channelId=%@&pushUserId=%@",channelid,pushuserid];
        [request setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        [request setValue:[numberFormatter stringFromNumber:[Utils getUserId]] forHTTPHeaderField:USERID];
        [request setValue:[Utils getToken] forHTTPHeaderField:TOKEN];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            NSLog(@"获取到的数据为：bindChannel:%@",dict);
            NSDictionary *resultDict = [NSDictionary cleanNullForDic:dict];
            if (resultDict == nil) {
                NSLog(@"json parse failed \r\n");
            }else{
                NSLog(@"%@",resultDict);
            }
            NSNumber *code = [resultDict objectForKey:@"code"];
            if ([code intValue] == 1) {
                NSLog(@"注册失败!");
                
            }else if([code intValue] == 0){
                NSLog(@"注册成功!");
            }
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"注册错误！%@",error);
            
            
        }];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperation:operation];
    }
}


//进入第一个菜单，同时控制左侧菜单
-(void)goToHome:(BOOL)animated{

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *type = [ud objectForKey:@"type"];
    
    NSMutableArray *menus = [NSMutableArray array];
    
    NSMutableDictionary *menu1 = [NSMutableDictionary dictionary];
    [menu1 setValue:@"menu_item_myreport_icon" forKey:@"imagename"];
    [menu1 setValue:@"我的上报" forKey:@"menuname"];
    [menu1 setValue:@"MyReportViewController" forKey:@"vcname"];
    
    NSMutableDictionary *menu2 = [NSMutableDictionary dictionary];
    [menu2 setValue:@"menu_item_formyreport_icon1" forKey:@"imagename"];
    [menu2 setValue:@"下级上报" forKey:@"menuname"];
    [menu2 setValue:@"HomeViewController" forKey:@"vcname"];
    
    NSMutableDictionary *menu3 = [NSMutableDictionary dictionary];
    [menu3 setValue:@"menu_item_notice_icon" forKey:@"imagename"];
    [menu3 setValue:@"我的公告" forKey:@"menuname"];
    [menu3 setValue:@"MyNoticeViewController" forKey:@"vcname"];
    
    NSMutableDictionary *menu4 = [NSMutableDictionary dictionary];
    [menu4 setValue:@"menu_item_unitmanage_icon" forKey:@"imagename"];
    [menu4 setValue:@"单位管理" forKey:@"menuname"];
    [menu4 setValue:@"DwglViewController" forKey:@"vcname"];
    
    NSMutableDictionary *menu5 = [NSMutableDictionary dictionary];
    [menu5 setValue:@"menu_item_review_icon" forKey:@"imagename"];
    [menu5 setValue:@"审阅信息" forKey:@"menuname"];
    [menu5 setValue:@"CheckInfoViewController" forKey:@"vcname"];
    
    NSMutableDictionary *menu6 = [NSMutableDictionary dictionary];
    [menu6 setValue:@"menu_item_setting_icon" forKey:@"imagename"];
    [menu6 setValue:@"个人设置" forKey:@"menuname"];
    [menu6 setValue:@"SettingViewController" forKey:@"vcname"];
    
    switch ([type integerValue]) {
        case MANAGER:
        case COUNTY_MANAGER:
        case CITY_MANAGER:
        case SHENG_MANAGER:
            //5个菜单 省 市 县 管理员
            [menus addObjectsFromArray:@[menu1,menu2,menu3,menu6]];
            //[menus addObjectsFromArray:@[menu1,menu2,menu3,menu4,menu6]];
            break;
        case SMANAGER:
            //4个菜单 超级管理员
            [menus addObjectsFromArray:@[menu2,menu3,menu6]];
            //[menus addObjectsFromArray:@[menu2,menu3,menu4,menu6]];
            break;
        case GENERAL://普通会员
            [menus addObjectsFromArray:@[menu1,menu3,menu6]];
            break;
        case TASTER://审阅会员
            [menus addObjectsFromArray:@[menu5,menu3,menu6]];
            break;
        default:
            break;
    }
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:menus forKey:@"menus"];
//    NSDictionary *firstmenu = [menus objectAtIndex:0];
//    NSString *vcname = [firstmenu objectForKey:@"vcname"];
//    
//    if ([vcname isEqualToString:@"HomeViewController"]) {//下级上报
//        InfoViewController *info1 = [[self storyboard] instantiateViewControllerWithIdentifier: @"InfoViewController"];
//        info1.title = @"全部";
//        
//        InfoViewController *info2 = [[self storyboard] instantiateViewControllerWithIdentifier: @"InfoViewController"];
//        info2.title = @"未处理";
//        info2.opttype = @"-1";
//        
//        InfoViewController *info3 = [[self storyboard] instantiateViewControllerWithIdentifier: @"InfoViewController"];
//        info3.title = @"已归档";
//        info3.opttype = @"1";
//        
//        InfoViewController *info4 = [[self storyboard] instantiateViewControllerWithIdentifier: @"InfoViewController"];
//        info4.title = @"已上报";
//        info4.opttype = @"3";
//        
//        InfoViewController *info5 = [[self storyboard] instantiateViewControllerWithIdentifier: @"InfoViewController"];
//        info5.title = @"已录用";
//        info5.opttype = @"5";
//        
//        NSMutableArray *vcs = [NSMutableArray array];
//        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
//        NSNumber *type = [userdefaults objectForKey:@"type"];
//        switch ([type integerValue]) {
//            case MANAGER://管理员(全部.未处理,已归档,已上报)
//                [vcs addObjectsFromArray:@[info1,info2,info3,info4]];
//                break;
//            case COUNTY_MANAGER://省管理员
//            case CITY_MANAGER://市管理员
//            case SHENG_MANAGER://县管理员
//                //(全部,未处理,已归档,已上报,已录用)
//                [vcs addObjectsFromArray:@[info1,info2,info3,info4,info5]];
//                break;
//            case SMANAGER:
//                //超级管理员(全部,未处理,已归档)
//                [vcs addObjectsFromArray:@[info1,info2,info3]];
//                break;
//            default:
//                break;
//        }
//        
//        HomeViewController *vc2 = [[HomeViewController alloc] initWithViewControllers:vcs];
//        vc2.title = @"下级上报";
//        vc2.indicatorInsets = UIEdgeInsetsMake(0, 0, 8, 0);
//        vc2.indicator.backgroundColor = [UIColor colorWithRed:72/255.0 green:147/255.0 blue:219/255.0 alpha:1];
//        
//        [self.navigationController pushViewController:vc2 animated:animated];
//    }else if([vcname isEqualToString:@"MyNoticeViewController"]){//我的公告
//        
//            NoticeViewController *notice1 = [[self storyboard] instantiateViewControllerWithIdentifier: @"NoticeViewController"];
//            notice1.title = @"发送的公告";
//            notice1.url = @"/mobile/notice/getNoticeHistory";
//            
//            NoticeViewController *notice2 = [[self storyboard] instantiateViewControllerWithIdentifier: @"NoticeViewController"];
//            notice2.title = @"接受的公告";
//            notice2.url = @"/mobile/notice/getReceiveNotice";
//            
//            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
//            NSNumber *type = [userdefaults objectForKey:@"type"];
//            NSMutableArray *arr = [NSMutableArray array];
//            switch ([type integerValue]) {
//                case MANAGER:
//                case COUNTY_MANAGER:
//                case CITY_MANAGER:
//                case SHENG_MANAGER:
//                    [arr addObjectsFromArray:@[notice1,notice2]];
//                    break;
//                case SMANAGER:
//                    [arr addObjectsFromArray:@[notice1]];
//                    break;
//                default:
//                    [arr addObjectsFromArray:@[notice2]];
//                    break;
//            }
//            MyNoticeViewController *mynotice = [[MyNoticeViewController alloc] initWithViewControllers:arr];
//            mynotice.title = @"我的公告";
//            mynotice.indicatorInsets = UIEdgeInsetsMake(0, 0, 8, 0);
//            mynotice.indicator.backgroundColor = [UIColor colorWithRed:72/255.0 green:147/255.0 blue:219/255.0 alpha:1];
//        [self.navigationController pushViewController:mynotice animated:animated];
//    }else if([vcname isEqualToString:@"CheckInfoViewController"]){//审阅信息
//        SignReportTableViewController *vc1 = [[self storyboard] instantiateViewControllerWithIdentifier: @"SignReportTableViewController"];
//        vc1.title = @"待审阅信息";
//        vc1.type = @"1";
//        SignReportTableViewController *vc2 = [[self storyboard] instantiateViewControllerWithIdentifier: @"SignReportTableViewController"];
//        vc2.title = @"已审阅信息";
//        vc2.type = @"2";
//        CheckInfoViewController *vc = [[CheckInfoViewController alloc] initWithViewControllers:@[vc1,vc2]];
//        vc.title = @"审阅信息";
//        vc.indicatorInsets = UIEdgeInsetsMake(0, 0, 8, 0);
//        vc.indicator.backgroundColor = [UIColor colorWithRed:72/255.0 green:147/255.0 blue:219/255.0 alpha:1];
//        [self.navigationController pushViewController:vc animated:animated];
//    }else{
//        UIViewController *firstvc = [[self storyboard]
//                                     instantiateViewControllerWithIdentifier:vcname];
//        [self.navigationController pushViewController:firstvc animated:animated];
//    }
//    
//    
//    [self.navigationController setNavigationBarHidden:NO];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLeftMenu" object:nil];
    MenuViewController *menu = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
//    [XDKAirMenuController attemptDealloc];
    //UIModalTransitionStyleCoverVertical   底部滑入
    //UIModalTransitionStyleFlipHorizontal  水平翻转
    //UIModalTransitionStyleCrossDissolve   交叉溶解
    //UIModalTransitionStylePartialCurl     翻页
//    [menu setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//    [self presentViewController:menu animated:animated completion:nil];
    [self.navigationController pushViewController:menu animated:YES];
}

//-(void)loginStateChange:(NSNotification *)notification{
//    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1){
//        UIViewController *s = [notification object];
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"用户状态出现错误,可能原因如下:" message:@"1.登录状态过期.\n2.账号用其他手机登陆." preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
//                                                  style:UIAlertActionStyleDestructive
//                                                handler:^(UIAlertAction *action) {
//                                                    [BPush unbindChannel];
//                                                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//                                                    [ud removeObjectForKey:@"isLogin"];
//                                                    
//                                                    
//                                                    
//                                                    
////                                                    [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:NO];
//                                                }]];
//        [s.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
//    }else{
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"用户状态出现错误,可能原因如下:" message:@"1.登录状态过期.\n2.账号用其他手机登陆." delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//    }
//}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    [BPush unbindChannel];
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    [ud removeObjectForKey:@"isLogin"];
//    [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:NO];
//}

@end
