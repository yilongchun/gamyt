//
//  NoticeViewController.m
//  gamyt
//
//  Created by yons on 15-3-23.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeTableViewCell.h"
#import "NoticeDetailViewController.h"

@implementation NoticeViewController{
    NSNumber *count;
    NSNumber *totalpage;
    NSNumber *page;
    
    NSNumber *noteid;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    
    self.tableView.pullDelegate = self;
    self.tableView.canPullDown = YES;
    self.tableView.canPullUp = YES;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *note = [userdefaults objectForKey:@"notes"];
    noteid = [note objectForKey:@"id"];
    [self showHudInView:self.view hint:@"加载中"];
    [self loadData];
}

-(void)loadData{
    page = [NSNumber numberWithInt:0];
    NSString *str = [NSString stringWithFormat:@"%@%@",[Utils getHostname],self.url];
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
    
    if ([self.type isEqualToString:@"1"]) {
        [parameters setObject:noteid forKey:@"noteid"];//2种情况不一样
    }
    
    
    NSString *post=[NSString jsonStringWithDictionary:parameters];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [request setHTTPBody:postData];
    
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
    NSString *str = [NSString stringWithFormat:@"%@%@",[Utils getHostname],self.url];
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
    if ([self.type isEqualToString:@"1"]) {
        [parameters setObject:noteid forKey:@"noteid"];//2种情况不一样
    }
    NSString *post=[NSString jsonStringWithDictionary:parameters];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [request setHTTPBody:postData];
    
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
        [self.tableView stopLoadWithState:PullUpLoadState];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self hideHud];
        [self showHint:@"连接失败"];
        [self.tableView stopLoadWithState:PullUpLoadState];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 列寬
    CGFloat contentWidth = [UIScreen mainScreen].bounds.size.width;
    // 用何種字體進行顯示
    UIFont *font = [UIFont systemFontOfSize:16];
    // 該行要顯示的內容
    NSString *content = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"content"];
    // 計算出顯示完內容需要的最小尺寸
    
    CGSize textSize;
    if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        textSize = [content boundingRectWithSize:CGSizeMake(contentWidth-8-21, MAXFLOAT)
                                         options:options
                                      attributes:attributes
                                         context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        textSize = [content sizeWithFont:font
                       constrainedToSize:CGSizeMake(contentWidth-8-21, MAXFLOAT)
                           lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        
    }
    return textSize.height + 66 < 87 ? 87 : textSize.height + 66;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noticecell"];
    
    //设置layer
//    CALayer *layer=[cell.backview layer];
//    //是否设置边框以及是否可见
//    [layer setMasksToBounds:YES];
//    //设置边框线的宽
//    [layer setBorderWidth:1];
//    //设置边框线的颜色
//    [layer setBorderColor:[[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1] CGColor]];
//    layer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
//    layer.shadowOffset = CGSizeMake(0,1);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//    layer.shadowOpacity = 0.2;//阴影透明度，默认0
//    layer.shadowRadius = 1;//阴影半径，默认3
    
    NSDictionary *info = [self.dataSource objectAtIndex:indexPath.row];
    info = [NSDictionary cleanNullForDic:info];
    NSString *sendname = [info objectForKey:@"sendname"];
    
    NSString *content = [info objectForKey:@"content"];
    
    NSString *path = [info objectForKey:@"path"];
    if ([self.type isEqualToString:@"1"]) {
        [cell.unreadStatus setHidden:YES];
        
        NSNumber *addtime = [info objectForKey:@"addtime"];
        NSTimeInterval time = [addtime doubleValue] / 1000;
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
        NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *date = [df stringFromDate:confromTimesp];
        cell.date.text = [NSString stringWithFormat:@"%@",date];
//        cell.unreadStatusWidth = 0;
    }else if ([self.type isEqualToString:@"2"]) {
        NSNumber *readed = [info objectForKey:@"readed"];
        [cell.unreadStatus setHidden:[readed boolValue]];
        
        NSString *addtime = [info objectForKey:@"addtime"];
        cell.date.text = [NSString stringWithFormat:@"%@",addtime];
    }
    if (path.length == 0) {
        [cell.haveimg setHidden:YES];
    }else{
        [cell.haveimg setHidden:NO];
    }
    
    
//    cell.unreadStatus.layer.cornerRadius = 4.0f;
//    cell.unreadStatus.layer.masksToBounds = YES;
    
    cell.username.text = sendname;
//    if ([addtime isKindOfClass:[NSString class]]) {
//        cell.date.text = addtime;
//    }else{
//        cell.date.text = @"";
//    }
    
    cell.content.text = content;

    cell.content.numberOfLines = 0;
    cell.content.lineBreakMode = NSLineBreakByWordWrapping;
    [cell.content sizeToFit];
//    cell.content.backgroundColor = [UIColor greenColor];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    // 列寬
    CGFloat contentWidth = [UIScreen mainScreen].bounds.size.width;
    UIFont *font = [UIFont systemFontOfSize:16];
    CGSize textSize;
    if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        textSize = [content boundingRectWithSize:CGSizeMake(contentWidth-8-21, MAXFLOAT)
                                         options:options
                                      attributes:attributes
                                         context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        textSize = [content sizeWithFont:font
                       constrainedToSize:CGSizeMake(contentWidth-8-21, MAXFLOAT)
                           lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        
    }
    [cell.content setFrame:CGRectMake(cell.content.frame.origin.x, cell.content.frame.origin.y, textSize.width, textSize.height)];
    
    UIView *view_bg = [[UIView alloc]initWithFrame:cell.contentView.frame];
    view_bg.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = view_bg;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NoticeTableViewCell *cell = (NoticeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *info = [self.dataSource objectAtIndex:indexPath.row];
    info = [NSDictionary cleanNullForDic:info];
    NSNumber *readed = [info objectForKey:@"readed"];
    if (![readed boolValue]) {
        [cell.unreadStatus setHidden:YES];
        [info setValue:[NSNumber numberWithInt:1] forKey:@"readed"];
//        [self.dataSource removeObjectAtIndex:indexPath.row];
//        [self.dataSource insertObject:info atIndex:indexPath.row];
        [self.dataSource replaceObjectAtIndex:indexPath.row withObject:info];
    }
    
    
    
    
    NoticeDetailViewController *infoDetail = [[self storyboard] instantiateViewControllerWithIdentifier:@"NoticeDetailViewController"];
    infoDetail.info = info;
    if ([readed boolValue]) {
        infoDetail.readed = [NSNumber numberWithInt:1];
    }else{
        infoDetail.readed = [NSNumber numberWithInt:0];
    }
    infoDetail.title = @"公告详情";
    infoDetail.type = self.type;
    [self.navigationController pushViewController:infoDetail animated:YES];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessage" object:self];
    
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
}

- (void)PullUpLoadEnd {
    page = [NSNumber numberWithInt:[page intValue] + PAGE_COUNT];
    [self loadMore];
}

@end
