//
//  SignReportViewController.m
//  gamyt
//
//  Created by yons on 15-3-25.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "SignReportViewController.h"

@implementation SignReportViewController{
    NSNumber *newsid;
    NSNumber *pingjiid;
}

-(void)viewDidLoad{
    self.mytextview.layer.borderColor = BORDER_COLOR.CGColor;
    self.mytextview.layer.borderWidth = 0.5f;
    
    pingjiid = [self.info objectForKey:@"id"];
    newsid = [self.info objectForKey:@"newsid"];
   
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)ok:(id)sender {
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (self.mytextview.text.length == 0) {
        [self showHint:@"请输入审阅信息"];
        return;
    }
    [self showHudInView:self.view hint:@"加载中"];
    NSString *str = [NSString stringWithFormat:@"%@%@",[Utils getHostname],@"/mobile/report/signReadReport"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    //    [request setTimeoutInterval:30.0];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [request setValue:[numberFormatter stringFromNumber:[Utils getUserId]] forHTTPHeaderField:USERID];
    [request setValue:[Utils getToken] forHTTPHeaderField:TOKEN];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"content-type"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:self.mytextview.text forKey:@"content"];
    [parameters setObject:pingjiid forKey:@"id"];
    [parameters setObject:newsid forKey:@"newsid"];
    
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
            [self showHint:@"加载失败"];
        }else if([code intValue] == 4){
            [self hideHud];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:self];
        }else if([code intValue] == 0){
            [self hideHud];
            [self showHint:@"签阅成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSignReport" object:self];
            [self performSelector:@selector(back) withObject:nil afterDelay:1.5f];
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self hideHud];
        [self showHint:@"连接失败"];
        
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:^{
        
        NSDictionary *userinfo = [NSDictionary dictionaryWithObjectsAndKeys:self.mytextview.text,@"signcontent", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSignReportDetail" object:nil userInfo:userinfo];
    }];
}
@end
