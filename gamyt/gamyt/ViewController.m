//
//  ViewController.m
//  gamyt
//
//  Created by yons on 15-3-3.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "ViewController.h"
#import "MobileLoginParam.h"
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


- (NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

- (IBAction)login:(id)sender {
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"A000004886292F" forKey:@"deviceid"];
    [parameters setValue:@"3" forKey:@"devicetype"];
    [parameters setValue:@"111111" forKey:@"pwd"];
    [parameters setValue:@"18972590038" forKey:@"username"];
    
    
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    
//    NSData *data = [self toJSONData:parameters];
    
    
    
    NSString *jsonString = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonString);
    
    
    
//    MBJSONModel *m = [[MBJSONModel alloc] init];
//    [m setValuesForKeysWithDictionary:parameters];
//    NSData * params = [m JSONDataRepresentation];

    
//    NSString *s = @"{'deviceid':'A000004886292F','devicetype':3,'pwd':'111111','username':'18972590038'}";
  
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [[manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/plain"] setByAddingObject:@"text/html"];
    
    
//    MobileLoginParam *param = [[MobileLoginParam alloc] init];
//    param.deviceid = @"A000004886292F";
//    param.devicetype = 3;
//    param.pwd = @"111111";
//    param.username = @"18972590038";
//    
//    
//    NSData *other;
//    other=[NSKeyedArchiver archivedDataWithRootObject:param];
    
   
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",jsonString);
    
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    
//    NSLog(@"%@",[self DataTOjsonString:parameters]);
//    NSString *p = [self DataTOjsonString:parameters];
//    [manager POST:@"http://ycly.minyitong.cn/yc/mobile/user/login" parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
    
//    [manager POST:@"http://115.29.103.36/sma/purchase/purchasedetailallList.do" parameters:@{@"schoolId":@"8671eb9e-c834-41dd-8e37-62c1ac730c65",@"purchaseDate":@"2015-01-22",@"purchaseType":@"2621be22-c1d8-4630-8738-0f441692d011"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
    
    
    
//    UIViewController *next = [[self storyboard] instantiateViewControllerWithIdentifier:@"MainViewController"];
//    [self.navigationController pushViewController:next animated:YES];
    
    [self goToHome];
}

-(void)goToHome{
    
    
    HomeViewController *home = [[self storyboard]
                               instantiateViewControllerWithIdentifier: @"HomeViewController"];
    [self.navigationController pushViewController:home animated:YES];
}

@end
