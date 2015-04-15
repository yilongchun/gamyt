//
//  MainViewController.m
//  gamyt
//
//  Created by yons on 15-3-3.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "MyReportViewController.h"
#import "MyReportTableViewCell.h"
#import "XDKAirMenuController.h"

@implementation MyReportViewController{
    NSNumber *count;
    NSNumber *totalpage;
    NSNumber *page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *image = [UIImage imageNamed:@"menuchange_normal"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonPressed:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData)
                                                 name:@"refreshMyReport"
                                               object:nil];
    
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_report_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(toAdd)];
    self.navigationItem.rightBarButtonItem = rightitem;
    
    
    
    _tableView.pullDelegate = self;
    _tableView.canPullDown = YES;
    _tableView.canPullUp = YES;
    [self loadData];
}

-(void)toAdd{
//    UIViewController *vc = [[self storyboard]
//                                 instantiateViewControllerWithIdentifier:@"AddReportViewController"];
//    [self.navigationController pushViewController:vc animated:YES];
    
    [self performSegueWithIdentifier:@"toAddReport" sender:self];
    
                            
    
//    [self presentViewController:vc animated:YES completion:^{
//        
//    }];
}

-(void)loadData{
    [self showHudInView:self.view hint:@"加载中"];
    page = [NSNumber numberWithInt:0];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%d",PAGE_COUNT] forKey:@"count"];
    [parameters setObject:[NSString stringWithFormat:@"%d",[page intValue]] forKey:@"page"];
    NSString *urlstring = [NSString stringWithFormat:@"%@%@",[Utils getHostname],@"/mobile/report/getMyReport"];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSString *post=[NSString jsonStringWithDictionary:parameters];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:30.0];
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
                                       }
                                   }
                                   [self.tableView stopLoadWithState:PullDownLoadState];
                               });
                           }];
}

-(void)loadMore{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%d",PAGE_COUNT] forKey:@"count"];
    [parameters setObject:[NSString stringWithFormat:@"%d",[page intValue]] forKey:@"page"];
    NSString *urlstring = [NSString stringWithFormat:@"%@%@",[Utils getHostname],@"/mobile/report/getMyReport"];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSString *post=[NSString jsonStringWithDictionary:parameters];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:30.0];
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
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myreportcell"];
    
    //设置layer
//    CALayer *layer=[cell.background layer];
//    //是否设置边框以及是否可见
//    [layer setMasksToBounds:YES];
//    //设置边框线的宽
//    [layer setBorderWidth:0.3f];
//    //设置边框线的颜色
//    [layer setBorderColor:[[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1] CGColor]];
//    layer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
//    layer.shadowOffset = CGSizeMake(0,1);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//    layer.shadowOpacity = 0.2;//阴影透明度，默认0
//    layer.shadowRadius = 1;//阴影半径，默认3
    
    NSDictionary *info = [self.dataSource objectAtIndex:indexPath.row];
    info = [NSDictionary cleanNullForDic:info];
    NSString *addtime = [info objectForKey:@"addtime"];
    NSNumber *opttype = [info objectForKey:@"opttype"];
    NSString *receivername =[info objectForKey:@"receivername"];
    NSString *path = [info objectForKey:@"path"];
    if (path.length == 0) {
        [cell.haveimg setHidden:YES];
    }else{
        [cell.haveimg setHidden:NO];
    }
    
    if ([opttype intValue] == -1) {
        cell.opttypename.textColor = [UIColor colorWithRed:56/255.0 green:143/255.0 blue:219/255.0 alpha:1];
    }else{
        cell.opttypename.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    }
    
    cell.sendname.text = receivername;
    cell.addtime.text = addtime;
    cell.opttypename.text = [Utils getOptTypeName:opttype];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UIScrollView PullDelegate

- (void)scrollView:(UIScrollView*)scrollView loadWithState:(LoadState)state {
    if (state == PullDownLoadState) {
        [self performSelector:@selector(PullDownLoadEnd) withObject:nil afterDelay:1];
    }
    else {
        [self performSelector:@selector(PullUpLoadEnd) withObject:nil afterDelay:1];
    }
}
//下拉刷新
- (void)PullDownLoadEnd {
    [self loadData];
    _tableView.canPullUp = YES;
}

- (void)PullUpLoadEnd {
    page = [NSNumber numberWithInt:[page intValue] + PAGE_COUNT];
    [self loadMore];
}

- (IBAction)menuButtonPressed:(id)sender
{
    XDKAirMenuController *menu = [XDKAirMenuController sharedInstance];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUnreadCount" object:self];
    if (menu.isMenuOpened)
        [menu closeMenuAnimated];
    else
        [menu openMenuAnimated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
