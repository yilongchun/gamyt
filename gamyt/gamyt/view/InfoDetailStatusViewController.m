//
//  InfoDetailStatusViewController.m
//  gamyt
//
//  Created by yons on 15-3-13.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "InfoDetailStatusViewController.h"
#import "TimeLineViewControl.h"
#import "AFNetworking.h"

@implementation InfoDetailStatusViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //单位名称可能过长
    [self loadData];
}



-(void)loadData{
    [self showHudInView:self.view hint:@"加载中"];
    NSString *str = [NSString stringWithFormat:@"%@%@",[Utils getHostname],@"/mobile/report/getMobileNewsOptProcessByNewsid"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:10.0];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [request setValue:[numberFormatter stringFromNumber:[Utils getUserId]] forHTTPHeaderField:USERID];
    [request setValue:[Utils getToken] forHTTPHeaderField:TOKEN];
    NSString* str2 = [NSString stringWithFormat:@"newsid=%d", [self.newsid intValue]];
    [request setHTTPBody:[str2 dataUsingEncoding:NSUTF8StringEncoding]];
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
            [self showHintInCenter:@"加载失败"];
        }else if([code intValue] == 4){
            [self hideHud];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:self];
        }else if([code intValue] == 0){
            [self hideHud];
            NSArray *data = [resultDict objectForKey:@"data"];
            if (data != nil && ![data isKindOfClass:[NSString class]]) {
                
                
                NSMutableArray *times = [NSMutableArray array];
                NSMutableArray *descriptions = [NSMutableArray array];
                
                for (int i = 0 ; i < [data count]; i++) {
                    NSDictionary *info = [data objectAtIndex:i];
                    info = [NSDictionary cleanNullForDic:info];
                    NSString *addtime = [info objectForKey:@"addtime"];
//                    NSNumber *opttype = [info objectForKey:@"opttype"];
                    NSString *notename = [info objectForKey:@"notename"];
                    NSString *peoplename = [info objectForKey:@"peoplename"];
                    NSString *opttypename = [info objectForKey:@"opttypename"];
                    [times addObject:addtime];
                    [descriptions addObject:[NSString stringWithFormat:@"%@\n%@\n%@",notename,peoplename,opttypename]];
                }
                
                TimeLineViewControl *timeline = [[TimeLineViewControl alloc] initWithTimeArray:times
                                                                       andTimeDescriptionArray:descriptions
                                                                              andCurrentStatus:[data count]
                                                                                      andFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height)];
                timeline.progressViewContainerLeft = [NSNumber numberWithFloat:([UIScreen mainScreen].bounds.size.width - 26) / 2] ;
                //    timeline.backgroundColor = [UIColor grayColor];
                
                //    CGPoint point = self.view.center;
                //    point.y = (self.view.frame.size.height - 64)/2 + 64;
                //    timeline.center = point;
                [self.myscrollview addSubview:timeline];
                [self.myscrollview setContentSize:CGSizeMake(self.view.frame.size.width, 1000)];
            }
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self hideHud];
        [self showHintInCenter:@"连接失败"];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
