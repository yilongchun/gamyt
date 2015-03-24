//
//  UpdatePasswordTableViewController.m
//  gamyt
//
//  Created by yons on 15-3-23.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "UpdatePasswordTableViewController.h"


@implementation UpdatePasswordTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (IBAction)save:(id)sender {
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    
    if(self.oldpwdLabel.text.length == 0){
        [self showHint:@"请输入旧密码"];
        return;
    }
    if(self.newpwdLabel.text.length == 0){
        [self showHint:@"请输入新密码"];
        return;
    }
    if(self.newpwd2Label.text.length == 0){
        [self showHint:@"请再次输入新密码"];
        return;
    }
    if([self.newpwdLabel.text isEqualToString:self.newpwd2Label.text]){
        [self showHudInView:self.view hint:@"加载中"];
        NSString *str = [NSString stringWithFormat:@"%@%@",[Utils getHostname],@"/mobile/user/updateUserLoginInfo"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setTimeoutInterval:30.0];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        [request setValue:[numberFormatter stringFromNumber:[Utils getUserId]] forHTTPHeaderField:USERID];
        [request setValue:[Utils getToken] forHTTPHeaderField:TOKEN];
        
        //JSON格式
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"content-type"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:self.newpwdLabel.text forKey:@"newpwd"];
        [parameters setObject:self.oldpwdLabel.text forKey:@"oldpwd"];
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
            if ([code intValue] == 1) {
                [self hideHud];
                [self showHint:@"修改失败"];
            }else if([code intValue] == 4){
                [self hideHud];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:self];
            }else if([code intValue] == 0){
                [self hideHud];
                [self showHint:@"修改成功"];
                [self performSelector:@selector(back) withObject:nil afterDelay:1.5f];
            }
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"发生错误！%@",error);
            [self hideHud];
            [self showHint:@"连接失败"];
        }];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperation:operation];
    }else{
        [self showHint:@"两次的密码不一致,请重新输入"];
    }
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
