//
//  SignReportTableViewController.m
//  gamyt
//
//  Created by yons on 15-3-24.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "SignReportTableViewController.h"
#import "SignReportTableViewCell.h"
#import "SignReportDetailViewController.h"

@implementation SignReportTableViewController{
    NSNumber *count;
    NSNumber *totalpage;
    NSNumber *page;
    
    NSString *urlStr;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData)
                                                 name:@"refreshSignReport"
                                               object:nil];
    
    if ([self.type isEqualToString:@"1"]) {
        urlStr = @"/mobile/report/getNoSignreadReport";
    }else if([self.type isEqualToString:@"2"]){
        urlStr = @"/mobile/report/getSignreadReport";
    }
    
    self.tableView.pullDelegate = self;
    self.tableView.canPullDown = YES;
    self.tableView.canPullUp = YES;
    [self showHudInView:self.view hint:@"加载中"];
    [self loadData];
}

-(void)loadData{
    page = [NSNumber numberWithInt:0];
    NSString *str = [NSString stringWithFormat:@"%@%@",[Utils getHostname],urlStr];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    //    [request setTimeoutInterval:30.0];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [request setValue:[numberFormatter stringFromNumber:[Utils getUserId]] forHTTPHeaderField:USERID];
    [request setValue:[Utils getToken] forHTTPHeaderField:TOKEN];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"content-type"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%d",PAGE_COUNT] forKey:@"count"];
    [parameters setObject:[NSString stringWithFormat:@"%d",[page intValue]] forKey:@"page"];
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
            count = [resultDict objectForKey:@"count"];
            NSArray *data = [resultDict objectForKey:@"data"];
            if (data != nil && ![data isKindOfClass:[NSString class]]) {
                self.dataSource = [NSMutableArray arrayWithArray:data];
            }
            [self.tableView reloadData];
            int pagemax = [page intValue] + PAGE_COUNT;
            if (pagemax >= [count intValue]) {
                self.tableView.canPullUp = NO;
            }
        }
        [self.tableView stopLoadWithState:PullDownLoadState];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self hideHud];
        [self showHint:@"连接失败"];
        [self.tableView stopLoadWithState:PullDownLoadState];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

-(void)loadMore{
    NSString *str = [NSString stringWithFormat:@"%@%@",[Utils getHostname],urlStr];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    //    [request setTimeoutInterval:30.0];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [request setValue:[numberFormatter stringFromNumber:[Utils getUserId]] forHTTPHeaderField:USERID];
    [request setValue:[Utils getToken] forHTTPHeaderField:TOKEN];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"content-type"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%d",PAGE_COUNT] forKey:@"count"];
    [parameters setObject:[NSString stringWithFormat:@"%d",[page intValue]+1] forKey:@"page"];
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
            count = [resultDict objectForKey:@"count"];
            NSArray *data = [resultDict objectForKey:@"data"];
            if (data != nil && ![data isKindOfClass:[NSString class]]) {
                [self.dataSource addObjectsFromArray:data];
            }
            [self.tableView reloadData];
            int pagemax = [page intValue] + PAGE_COUNT;
            if (pagemax >= [count intValue]) {
                self.tableView.canPullUp = NO;
            }
        }
        [self.tableView stopLoadWithState:PullDownLoadState];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self hideHud];
        [self showHint:@"连接失败"];
        [self.tableView stopLoadWithState:PullDownLoadState];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

#pragma mark - UITableView Delegate & Datasrouce -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [NSDictionary cleanNullForDic:[self.dataSource objectAtIndex:indexPath.row]];
    NSString *newscontent = [dic objectForKey:@"newscontent"];
    CGFloat contentWidth = [UIScreen mainScreen].bounds.size.width;
    UIFont *font = [UIFont systemFontOfSize:16];
    CGSize textSize;
    if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        textSize = [newscontent boundingRectWithSize:CGSizeMake(contentWidth-26, MAXFLOAT)
                                             options:options
                                          attributes:attributes
                                             context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        textSize = [newscontent sizeWithFont:font
                           constrainedToSize:CGSizeMake(contentWidth-26, MAXFLOAT)
                               lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        
    }
    return 36 + textSize.height + 36;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SignReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"signcell"];
    
    CALayer *layer=[cell.backview layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1];
    [layer setBorderColor:[BORDER_COLOR CGColor]];
    CALayer *layer2=[cell.innerbackview layer];
    [layer2 setMasksToBounds:YES];
    [layer2 setBorderWidth:1];
    [layer2 setBorderColor:[BORDER_COLOR CGColor]];
    
    UIButton *btn = cell.btn;
    [btn addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    if ([self.type isEqualToString:@"1"]) {
        [btn setTitle:@" 进入审阅" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"review_icon_normal"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitle:@" 进入审阅" forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:@"review_icon_pressed"]  forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor colorWithRed:47/255.0 green:122/255.0 blue:227/255.0 alpha:1.0f] forState:UIControlStateHighlighted];
    }else if([self.type isEqualToString:@"2"]){
        [btn setTitle:@" 查看详情" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"review_look_icon_normal"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitle:@" 查看详情" forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:@"review_look_icon_pressed"]  forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor colorWithRed:47/255.0 green:122/255.0 blue:227/255.0 alpha:1.0f] forState:UIControlStateHighlighted];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dic = [NSDictionary cleanNullForDic:[self.dataSource objectAtIndex:indexPath.row]];
    NSString *sendpname = [dic objectForKey:@"sendpname"];
    NSString *addtime = [dic objectForKey:@"addtime"];
    NSString *newscontent = [dic objectForKey:@"newscontent"];
    NSString *path = [dic objectForKey:@"path"];
    if (path.length == 0) {
        [cell.haveimg setHidden:YES];
    }else{
        [cell.haveimg setHidden:NO];
    }
    cell.sendpname.text = sendpname;
    cell.addtime.text = addtime;
    cell.newscontent.text = newscontent;
    cell.newscontent.numberOfLines = 0;
    cell.newscontent.lineBreakMode = NSLineBreakByWordWrapping;
    [cell.newscontent sizeToFit];
    
    // 列寬
    CGFloat contentWidth = [UIScreen mainScreen].bounds.size.width;
    UIFont *font = [UIFont systemFontOfSize:16];
    CGSize textSize;
    if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        textSize = [newscontent boundingRectWithSize:CGSizeMake(contentWidth-26, MAXFLOAT)
                                         options:options
                                      attributes:attributes
                                         context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        textSize = [newscontent sizeWithFont:font
                       constrainedToSize:CGSizeMake(contentWidth-26, MAXFLOAT)
                           lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        
    }
    [cell.newscontent setFrame:CGRectMake(cell.newscontent.frame.origin.x, cell.newscontent.frame.origin.y, textSize.width, textSize.height)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self toDetail:indexPath];
}

- (void)checkButtonTapped:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil)
    {
        [self toDetail:indexPath];
    }
}

-(void)toDetail:(NSIndexPath *)indexPath{
    NSDictionary *info = [self.dataSource objectAtIndex:indexPath.row];
    info = [NSDictionary cleanNullForDic:info];
    SignReportDetailViewController *infoDetail = [[self storyboard] instantiateViewControllerWithIdentifier:@"SignReportDetailViewController"];
    infoDetail.info = info;
    infoDetail.type = self.type;
    [self.navigationController pushViewController:infoDetail animated:YES];
}

#pragma mark -
#pragma mark UIScrollView PullDelegate

- (void)scrollView:(UIScrollView*)scrollView loadWithState:(LoadState)state {
    if (state == PullDownLoadState) {
        [self performSelector:@selector(PullDownLoadEnd) withObject:nil afterDelay:0.1];
    }
    else {
        [self performSelector:@selector(PullUpLoadEnd) withObject:nil afterDelay:0.1];
    }
}
//下拉刷新
- (void)PullDownLoadEnd {
    [self loadData];
    self.tableView.canPullUp = YES;
    NSLog(@"PullDownLoadEnd");
}

- (void)PullUpLoadEnd {
    page = [NSNumber numberWithInt:[page intValue] + PAGE_COUNT];
    
    [self loadMore];
    NSLog(@"PullUpLoadEnd");
}

@end
