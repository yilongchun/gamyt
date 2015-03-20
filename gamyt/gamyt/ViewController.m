//
//  ViewController.m
//  gamyt
//
//  Created by yons on 15-3-3.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"
#import "InfoViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
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
    self.account.text = @"18972590038";//市级管理员:18972590038 111111
//    self.account.text = @"18972592846";//县级管理员:18972592846 111111
//    self.account.text = @"18972593062";//管理员:18972593062 111111
//    self.account.text = @"18972593057";//审阅员:18972593057 111111
//    self.account.text = @"15671055205";//会员:15671055205 111111
    self.password.text = @"111111";
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField setBackgroundColor:[UIColor colorWithRed:26/255.0 green:73/255.0 blue:130/255.0 alpha:1.0]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField setBackgroundColor:[UIColor colorWithRed:36/255.0 green:102/255.0 blue:171/255.0 alpha:1.0]];
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
    
    if (self.account.text.length == 0) {
        [self showHintInCenter:@"请输入账号"];
        return;
    }
    if (self.password.text.length == 0) {
        [self showHintInCenter:@"请输入密码"];
        return;
    }
    
    [self showHudInView:self.view hint:@"加载中"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[self gen_uuid] forKey:@"deviceid"];
    [parameters setValue:@"4" forKey:@"devicetype"];
    [parameters setValue:self.password.text forKey:@"pwd"];
    [parameters setValue:self.account.text forKey:@"username"];
    
    [self httpAsynchronousRequest:[NSString jsonStringWithDictionary:parameters]];
}

- (void)httpAsynchronousRequest:(NSString *)params{
    NSString *urlstring = [NSString stringWithFormat:@"%@%@",[Utils getHostname],@"/mobile/user/login"];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSString *post=params;
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:30.0];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"content-type"];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   if (error) {
                                       [self hideHud];
                                       [self showHintInCenter:@"连接失败"];
                                       NSLog(@"Httperror:%@%ld", error.localizedDescription,(long)error.code);
                                   }else{
//                                       NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
//                                       NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                       
//                                       
//                                       
//                                       responseString = [responseString stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                       
                                       NSError *error;
                                       NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                       if (resultDict == nil) {
                                           NSLog(@"json parse failed \r\n");
                                       }else{
                                           NSLog(@"%@",resultDict);
                                       }
                                       NSNumber *code = [resultDict objectForKey:@"code"];
                                       if ([code intValue] == 1) {
                                           [self hideHud];
                                           [self showHintInCenter:@"用户名或密码错误"];
                                       }else if([code intValue] == 0){
                                           [self hideHud];
                                           
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
                                           
                                           [self goToHome:type];
                                       }
                                   }
                               });
                           }];
}


//进入第一个菜单，同时控制左侧菜单
-(void)goToHome:(NSNumber *)type{
    
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
            [menus addObjectsFromArray:@[menu1,menu2,menu3,menu4,menu6]];
            break;
        case SMANAGER:
            //4个菜单 超级管理员
            [menus addObjectsFromArray:@[menu2,menu3,menu4,menu6]];
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
    NSDictionary *firstmenu = [menus objectAtIndex:0];
    NSString *vcname = [firstmenu objectForKey:@"vcname"];
    
    if ([vcname isEqualToString:@"HomeViewController"]) {//下级上报
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
        
        HomeViewController *vc2 = [[HomeViewController alloc] initWithViewControllers:vcs];
        vc2.title = @"下级上报";
        vc2.indicatorInsets = UIEdgeInsetsMake(0, 0, 8, 0);
        vc2.indicator.backgroundColor = [UIColor colorWithRed:72/255.0 green:147/255.0 blue:219/255.0 alpha:1];
        
        [self.navigationController pushViewController:vc2 animated:YES];
    }else{
        UIViewController *firstvc = [[self storyboard]
                                     instantiateViewControllerWithIdentifier:vcname];
        [self.navigationController pushViewController:firstvc animated:YES];
    }
    
    
    [self.navigationController setNavigationBarHidden:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLeftMenu" object:nil];
}

-(void)loginStateChange:(NSNotification *)notification{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1){
        UIViewController *s = [notification object];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"用户状态出现错误,可能原因如下:" message:@"1.登录状态过期.\n2.账号用其他手机登陆." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction *action) {
                                                    [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
                                                }]];
        [s presentViewController:alert animated:YES completion:nil];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"用户状态出现错误,可能原因如下:" message:@"1.登录状态过期.\n2.账号用其他手机登陆." delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
}

@end
