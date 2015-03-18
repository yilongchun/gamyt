//
//  UserinfoViewController.m
//  gamyt
//
//  Created by yons on 15-3-17.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "UserinfoViewController.h"

@implementation UserinfoViewController{
    NSDictionary *users;
    NSDictionary *notes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
    [self.phone addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.bank addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.bankcard addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.bankaddress addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    users = [userdefaults objectForKey:@"users"];
    notes = [userdefaults objectForKey:@"notes"];
    
    NSString *picpath = [users objectForKey:@"picpath"];//头像
    NSString *username = [users objectForKey:@"name"];//姓名
    NSString *notename = [notes objectForKey:@"name"];//单位
    NSString *phone = [users objectForKey:@"phone"];//电话
    NSString *idcard = [users objectForKey:@"idcard"];//身份证
    
    //积分
    //积分等级
    NSString *bank = [users objectForKey:@"bank"];//开户银行
    NSString *bankcard = [users objectForKey:@"bankcard"];//银行卡号
    NSString *bankaddress = [users objectForKey:@"bankaddress"];//汇款地址
    
    NSString *imagePath = [NSString stringWithFormat:@"%@%@%@",[Utils getHostname],IMAGE_PATH,picpath];
    [self.img setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"defalut_photo"]];
    self.username.text = username;
    self.unitname.text = notename;
    self.phone.text = phone;
    self.idcard.text = idcard;
    self.bank.text = bank;
    self.bankcard.text = bankcard;
    self.bankaddress.text = bankaddress;
    
    [self loadData];
    [self loadUserProperty];
}

-(void)loadData{
    [self showHudInView:self.view hint:@"加载中"];
    NSString *str = [NSString stringWithFormat:@"%@%@?uid=%d",[Utils getHostname],@"/mobile/user/getUserBaseInfo",[[Utils getUserId] intValue]];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:30.0];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        NSDictionary *resultDict = [NSDictionary cleanNullForDic:dict];
        if (resultDict == nil) {
            NSLog(@"json parse failed \r\n");
        }else{
            NSLog(@"%@",resultDict);
        }
        NSNumber *code = [resultDict objectForKey:@"code"];
        if ([code intValue] == 1) {
            [self hideHud];
            [self showHint:@"加载失败"];
        }else if([code intValue] == 4){
            [self hideHud];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:self];
        }else if([code intValue] == 0){
            [self hideHud];
            NSDictionary *dic = [NSDictionary cleanNullForDic:[resultDict objectForKey:@"data"]];
            NSNumber *points = [dic objectForKey:@"points"];//积分
            NSNumber *pointslevel = [dic objectForKey:@"pointslevel"];//积分等级
            self.point.text = [NSString stringWithFormat:@"%d",[points intValue]];
            self.pointlevel.text = [NSString stringWithFormat:@"%d",[pointslevel intValue]];;
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self hideHud];
        [self showHint:@"连接失败"];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

-(void)loadUserProperty{
    
    NSString *str = [NSString stringWithFormat:@"%@%@",[Utils getHostname],@"/mobile/user/getMemberProp"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30.0];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [request setValue:[numberFormatter stringFromNumber:[Utils getUserId]] forHTTPHeaderField:USERID];
    [request setValue:[Utils getToken] forHTTPHeaderField:TOKEN];
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
        if ([code intValue] == 1) {
            [self hideHud];
            [self showHint:@"获取人员属性失败"];
        }else if([code intValue] == 4){
            [self hideHud];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:self];
        }else if([code intValue] == 0){
            [self hideHud];
            
            NSNumber *propid = [users objectForKey:@"propid"];//人员属性 访问接口
            NSArray *userPropertyArr = [resultDict objectForKey:@"data"];
            BOOL flag = NO;
            for (int i = 0; i < userPropertyArr.count; i++) {
                NSDictionary *dic = [NSDictionary cleanNullForDic:[userPropertyArr objectAtIndex:i]];
                NSNumber *proid = [dic objectForKey:@"id"];
                NSString *proname = [dic objectForKey:@"name"];
                if ([proid intValue] == [propid intValue]) {
                    self.property.text = proname;
                    flag = YES;
                    break;
                }
            }
            if (!flag) {
                self.property.text = @"未设置";
            }
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self hideHud];
        [self showHint:@"获取人员失败"];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField{
    switch (textField.tag) {
        case 1:
            if (textField.text.length > 11) {
                textField.text = [textField.text substringToIndex:11];
            }
            break;
        case 2:
        case 3:
        case 4:
            if (textField.text.length > 30) {
                textField.text = [textField.text substringToIndex:30];
            }
            break;
        default:
            break;
    }
}

@end
