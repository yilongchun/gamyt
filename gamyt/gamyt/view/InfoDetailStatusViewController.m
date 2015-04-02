//
//  InfoDetailStatusViewController.m
//  gamyt
//
//  Created by yons on 15-3-13.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "InfoDetailStatusViewController.h"
#import "TimeLineViewControl.h"


@implementation InfoDetailStatusViewController{
    TimeLineViewControl *timeline;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    [self loadData];
}



-(void)loadData{
    [self.refreshBtn setEnabled:NO];
    [self showHudInView:self.view hint:@"加载中"];
    NSString *str = [NSString stringWithFormat:@"%@%@",[Utils getHostname],@"/mobile/report/getMobileNewsOptProcessByNewsid"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30.0];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [request setValue:[numberFormatter stringFromNumber:[Utils getUserId]] forHTTPHeaderField:USERID];
    [request setValue:[Utils getToken] forHTTPHeaderField:TOKEN];
    NSString* str2 = [NSString stringWithFormat:@"newsid=%d", [self.newsid intValue]];
    [request setHTTPBody:[str2 dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.refreshBtn setEnabled:YES];
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
            [self showHintInCenter:@"加载失败"];
        }else if([code intValue] == 4){
            [self hideHud];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:self];
        }else if([code intValue] == 0){
            [self hideHud];
            if (timeline) {
                [timeline removeFromSuperview];
            }
            NSArray *data = [resultDict objectForKey:@"data"];
            if (data != nil && ![data isKindOfClass:[NSString class]]) {
                
                
                NSMutableArray *times = [NSMutableArray array];
                NSMutableArray *descriptions = [NSMutableArray array];
                
                CGFloat descriptionHeight = 0;
                for (int i = 0 ; i < [data count]; i++) {
                    NSDictionary *info = [data objectAtIndex:i];
                    info = [NSDictionary cleanNullForDic:info];
                    NSString *addtime = [info objectForKey:@"addtime"];
//                    NSNumber *opttype = [info objectForKey:@"opttype"];
                    NSString *notename = [info objectForKey:@"notename"];
                    NSString *peoplename = [info objectForKey:@"peoplename"];
                    NSString *opttypename = [info objectForKey:@"opttypename"];
                    NSString *opinion = [info objectForKey:@"opinion"];
                    [times addObject:addtime];
                    
                    NSMutableString *description = [NSMutableString stringWithFormat:@"%@\n%@\n%@",notename,peoplename,opttypename];
                    if (opinion != nil && opinion.length != 0) {
                        [description appendFormat:@"\n%@",opinion];
                    }
                    
                    [descriptions addObject:description];
                    
                    
                    
                    
//                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:description];
//                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//                    [paragraphStyle setLineSpacing:5];//调整行间距
//                    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, strings.length)];
                    
//                    CGFloat contentWidth = self.view.frame.size.width - (([UIScreen mainScreen].bounds.size.width - 26) + 20 + 3 * 2)-40;
                    
                    CGFloat a = ([UIScreen mainScreen].bounds.size.width - 26) / 2;
                    CGFloat contentWidth = self.view.frame.size.width - (a + 20 + 3 * 2)-40;
                    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
                    CGSize textSize;
                    if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
                        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                        [paragraphStyle setLineSpacing:5];//调整行间距
//                        [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, description.length)];
                        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
                        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
                        textSize = [description boundingRectWithSize:CGSizeMake(contentWidth, MAXFLOAT)
                                                         options:options
                                                      attributes:attributes
                                                         context:nil].size;
                        descriptionHeight += textSize.height+20;
                    }
//                    else {
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//                        textSize = [strings sizeWithFont:font
//                                       constrainedToSize:CGSizeMake(contentWidth, MAXFLOAT)
//                                           lineBreakMode:NSLineBreakByWordWrapping];
//#pragma clang diagnostic pop
//                        
//                    }
                    
                    
                }
                
                
                
                
                int length = [[NSNumber numberWithLong:[data count]] intValue];
                timeline = [[TimeLineViewControl alloc] initWithTimeArray:times
                                                                       andTimeDescriptionArray:descriptions
                                                                              andCurrentStatus:length
                                                                                      andFrame:CGRectMake(0, 50, self.view.frame.size.width, descriptionHeight)];
                
//                timeline.progressViewContainerLeft = [NSNumber numberWithFloat:([UIScreen mainScreen].bounds.size.width - 26) / 2] ;
                //    timeline.backgroundColor = [UIColor grayColor];
                
                //    CGPoint point = self.view.center;
                //    point.y = (self.view.frame.size.height - 64)/2 + 64;
                //    timeline.center = point;
                [self.myscrollview addSubview:timeline];
                [self.myscrollview setContentSize:CGSizeMake(self.view.frame.size.width, descriptionHeight+100)];
                [self showHint:@"获取成功"];
            }
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.refreshBtn setEnabled:YES];
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


- (IBAction)refresh:(id)sender {
    [self loadData];
}
@end
