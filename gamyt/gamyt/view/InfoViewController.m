//
//  TestViewController.m
//  gamyt
//
//  Created by yons on 15-3-5.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "InfoViewController.h"
#import "InfoTableViewCell.h"

@implementation InfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSource = [NSMutableArray array];
    [self loadData];
}

-(void)loadData{
    [self showHudInView:self.view hint:@"加载中"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"10" forKey:@"count"];
    [parameters setObject:@"0" forKey:@"page"];
    
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
                                       if (resultDict == nil) {
                                           NSLog(@"json parse failed \r\n");
                                       }else{
                                           NSLog(@"%@",resultDict);
                                       }
                                       NSNumber *code = [resultDict objectForKey:@"code"];
                                       if ([code intValue] == 1) {
                                           [self hideHud];
                                           
                                       }else if([code intValue] == 4){
                                           [self hideHud];
                                           [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:nil];
                                           
                                       }else if([code intValue] == 0){
                                           [self hideHud];
                                          
                                          
//                                           NSNumber *count = [resultDict objectForKey:@"count"];
                                           NSArray *data = [resultDict objectForKey:@"data"];
                                          [self.dataSource addObjectsFromArray:data];
                                           [self.tableView reloadData];
                                           
                                       }
                                   }
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
                               lineBreakMode:NSLineBreakByCharWrapping];
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
    NSString *sendname = [info objectForKey:@"sendname"];
    NSString *addtime = [info objectForKey:@"addtime"];
    NSNumber *opttype = [info objectForKey:@"opttype"];
    NSString *content = [info objectForKey:@"content"];
    
    
    NSString *opttypename;
    switch ([opttype intValue]) {
        case -1:
            opttypename = @"未处理";
            break;
        case 0:
            opttypename = @"已签阅";
            break;
        case 1:
            opttypename = @"已归档";
            break;
        case 2:
            opttypename = @"已分发";
            break;
        case 3:
            opttypename = @"已上报";
            break;
        case 4:
            opttypename = @"转审阅";
            break;
        case 5:
        case 6:
            opttypename = @"已录用";
            break;
        default:
            break;
    }
    
    cell.sendname.text = sendname;
    cell.addtime.text = addtime;
    cell.opttypename.text = opttypename;
    cell.content.text = content;
    
    cell.content.numberOfLines = 0;
    cell.content.lineBreakMode = NSLineBreakByCharWrapping;
    [cell.content sizeToFit];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
