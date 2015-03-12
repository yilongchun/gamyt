//
//  TestViewController.m
//  gamyt
//
//  Created by yons on 15-3-5.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "InfoViewController.h"
#import "InfoTableViewCell.h"
#import "InfoDetailViewController.h"

@implementation InfoViewController{
    NSNumber *count;
    NSNumber *totalpage;
    NSNumber *page;
    
    NSString *tempTitle;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showHudInView:self.view hint:@"加载中"];
    tempTitle = self.title;
    _tableView.pullDelegate = self;
    _tableView.canPullDown = YES;
    _tableView.canPullUp = YES;
    [self loadData];
}

-(void)loadData{
    page = [NSNumber numberWithInt:0];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.opttype) {
        [parameters setObject:self.opttype forKey:@"opttype"];
    }
    [parameters setObject:[NSString stringWithFormat:@"%d",PAGE_COUNT] forKey:@"count"];
    [parameters setObject:[NSString stringWithFormat:@"%d",[page intValue]] forKey:@"page"];
    NSString *urlstring = [NSString stringWithFormat:@"%@%@",[Utils getHostname],@"/mobile/report/getForMyReport"];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSString *post=[NSString jsonStringWithDictionary:parameters];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:10.0];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"content-type"];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [request setValue:[numberFormatter stringFromNumber:[Utils getUserId]] forHTTPHeaderField:USERID];
    [request setValue:[Utils getToken] forHTTPHeaderField:TOKEN];
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
                                       NSError *error;
                                       NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                       resultDict = [NSDictionary cleanNullForDic:resultDict];
                                       if (resultDict == nil) {
                                           NSLog(@"json parse failed \r\n");
                                       }else{
//                                           NSLog(@"%@",resultDict);
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
                                           self.title = [NSString stringWithFormat:@"%@\n(%d)",tempTitle,[count intValue]];
                                           [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSegmentBar" object:nil];
                                       }
                                   }
                                   
                                   [self.tableView stopLoadWithState:PullDownLoadState];
                               });
                           }];
}

-(void)loadMore{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.opttype) {
        [parameters setObject:self.opttype forKey:@"opttype"];
    }
    [parameters setObject:[NSString stringWithFormat:@"%d",PAGE_COUNT] forKey:@"count"];
    [parameters setObject:[NSString stringWithFormat:@"%d",[page intValue]] forKey:@"page"];
    NSString *urlstring = [NSString stringWithFormat:@"%@%@",[Utils getHostname],@"/mobile/report/getForMyReport"];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSString *post=[NSString jsonStringWithDictionary:parameters];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:10.0];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"content-type"];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [request setValue:[numberFormatter stringFromNumber:[Utils getUserId]] forHTTPHeaderField:USERID];
    [request setValue:[Utils getToken] forHTTPHeaderField:TOKEN];
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
                                       NSError *error;
                                       NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                       resultDict = [NSDictionary cleanNullForDic:resultDict];
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
                                   }
                                   [self.tableView stopLoadWithState:PullUpLoadState];
                               });
                           }];
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
        textSize = [content boundingRectWithSize:CGSizeMake(contentWidth-28, MAXFLOAT)
                                             options:options
                                          attributes:attributes
                                             context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        textSize = [content sizeWithFont:font
                           constrainedToSize:CGSizeMake(contentWidth-28, MAXFLOAT)
                               lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop

    }
    return textSize.height + 70 < 90 ? 90 : textSize.height + 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infocell"];

    //设置layer
    CALayer *layer=[cell.background layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框线的宽
    [layer setBorderWidth:1];
    //设置边框线的颜色
    [layer setBorderColor:[[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1] CGColor]];
    
    
    NSDictionary *info = [self.dataSource objectAtIndex:indexPath.row];
    info = [NSDictionary cleanNullForDic:info];
    NSString *sendname = [info objectForKey:@"sendname"];
    NSString *addtime = [info objectForKey:@"addtime"];
    NSNumber *opttype = [info objectForKey:@"opttype"];
    NSString *content = [info objectForKey:@"content"];
    
    if ([opttype intValue] == -1) {
        cell.opttypename.textColor = [UIColor colorWithRed:56/255.0 green:143/255.0 blue:219/255.0 alpha:1];
    }else{
        cell.opttypename.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    }
    NSString *path = [info objectForKey:@"path"];
    if (path.length == 0) {
        [cell.haveimg setHidden:YES];
    }else{
        [cell.haveimg setHidden:NO];
    }
    
    
    cell.sendname.text = sendname;
    cell.addtime.text = addtime;
    cell.opttypename.text = [Utils getOptTypeName:opttype];
    cell.content.text = content;
    
    cell.content.numberOfLines = 0;
    cell.content.lineBreakMode = NSLineBreakByWordWrapping;
    [cell.content sizeToFit];
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
        textSize = [content boundingRectWithSize:CGSizeMake(contentWidth-28, MAXFLOAT)
                                         options:options
                                      attributes:attributes
                                         context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        textSize = [content sizeWithFont:font
                       constrainedToSize:CGSizeMake(contentWidth-28, MAXFLOAT)
                           lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        
    }
    [cell.content setFrame:CGRectMake(cell.content.frame.origin.x, cell.content.frame.origin.y, textSize.width, textSize.height)];
    
    UIView *view_bg = [[UIView alloc]initWithFrame:cell.content.frame];
    view_bg.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = view_bg;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *info = [self.dataSource objectAtIndex:indexPath.row];
    info = [NSDictionary cleanNullForDic:info];
    
    InfoDetailViewController *infoDetail = [[self storyboard] instantiateViewControllerWithIdentifier:@"InfoDetailViewController"];
    infoDetail.info = info;
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
    _tableView.canPullUp = YES;
    NSLog(@"PullDownLoadEnd");
}

- (void)PullUpLoadEnd {
    page = [NSNumber numberWithInt:[page intValue] + PAGE_COUNT];
    
    [self loadMore];
    NSLog(@"PullUpLoadEnd");
}


@end
