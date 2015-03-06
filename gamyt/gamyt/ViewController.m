//
//  ViewController.m
//  gamyt
//
//  Created by yons on 15-3-3.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"



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
    
    self.account.text = @"18972590038";
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
    
//    UIViewController *next = [[self storyboard] instantiateViewControllerWithIdentifier:@"MainViewController"];
//    [self.navigationController pushViewController:next animated:YES];
//    [self showHint:@"aaa"];
    
//    [self showHudInView:self.view hint:@"加载中"];
//    [self goToHome];
    
}

- (void)httpAsynchronousRequest:(NSString *)params{
    
    
    
    
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.111:8080/myt/mobile/user/login"];
    NSString *post=params;
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:10.0];
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
//                                           NSString *token = [data objectForKey:@"token"];
                                           NSDictionary *users = [data objectForKey:@"users"];
                                           NSNumber *type = [users objectForKey:@"type"];
                                           
                                           NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
                                           [userdefaults setObject:type forKey:@"type"];
                                           
                                           [self goToHome:type];
                                       }
                                   }
                               });
                           }];
}


-(void)goToHome:(NSNumber *)type{
    
    NSMutableArray *menus = [NSMutableArray array];
    
    NSMutableDictionary *menu1 = [NSMutableDictionary dictionary];
    [menu1 setValue:@"menu_item_myreport_icon" forKey:@"imagename"];
    [menu1 setValue:@"我的上报" forKey:@"menuname"];
    [menu1 setValue:@"MainViewController" forKey:@"vcname"];
    
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
        case 2:
        case 21:
        case 22:
        case 23:
            //5个菜单
            [menus addObjectsFromArray:@[menu1,menu2,menu3,menu4,menu6]];
            break;
        case 3:
            //4个菜单
            [menus addObjectsFromArray:@[menu2,menu3,menu4,menu6]];
            break;
        case 0:
            [menus addObjectsFromArray:@[menu1,menu3,menu6]];
            break;
        case 1:
            [menus addObjectsFromArray:@[menu5,menu3,menu6]];
            break;
        default:
            break;
    }
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:menus forKey:@"menus"];
    
    NSDictionary *firstmenu = [menus objectAtIndex:0];
    NSString *vcname = [firstmenu objectForKey:@"vcname"];
    
    UIViewController *firstvc = [[self storyboard]
                               instantiateViewControllerWithIdentifier:vcname];
    [self.navigationController pushViewController:firstvc animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

@end
