//
//  MenuViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"
#import "HomeViewController.h"
#import "InfoViewController.h"
#import "LeftMenuCell.h"
#import "MyNoticeViewController.h"
#import "NoticeViewController.h"

@implementation LeftMenuViewController{
    
   
    UILabel *unreadlabel;
    UIImageView *unreadImage;
}

#pragma mark - UIViewController Methods -

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self.slideOutAnimationEnabled = NO;
	return [super initWithCoder:aDecoder];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
//	self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftMenu.jpg"]];
	self.tableView.backgroundView = imageView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData)
                                                 name:@"reloadLeftMenu"
                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(setupUnreadMessage)
//                                                 name:@"setupUnreadMessage"
//                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadUnreadCount)
                                                 name:@"loadUnreadCount"
                                               object:nil];
    [self loadData];
        
}

-(void)loadData{
    [SlideNavigationController sharedInstance].selectIndex = 0;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSArray *menus = [userdefaults objectForKey:@"menus"];
    self.dataSource = [NSMutableArray arrayWithArray:menus];
    [self.tableView reloadData];
    [self loadUnreadCount];
}

-(void)loadUnreadCount{
//    [self showHudInView:self.view hint:@"加载中"];
    NSString *str = [NSString stringWithFormat:@"%@%@",[Utils getHostname],@"/mobile/notice/countUnreadReceiveNotice"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    //    [request setTimeoutInterval:30.0];
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
//            [self hideHud];
            [self showHint:@"加载失败"];
        }else if([code intValue] == 4){
//            [self hideHud];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:self];
        }else if([code intValue] == 0){
//            [self hideHud];
            NSNumber *number = [resultDict objectForKey:@"data"];
            [self setupUnreadMessageCount:[number intValue]];
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
//        [self hideHud];
        [self showHint:@"连接失败"];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.dataSource count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
	view.backgroundColor = [UIColor clearColor];
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	LeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftMenuCell"];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:17]];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:50/255.0 green:60/255.0 blue:90/255.0 alpha:1];
    NSDictionary *info = [self.dataSource objectAtIndex:indexPath.row];
    NSString *imagename = [info objectForKey:@"imagename"];
    NSString *menuname = [info objectForKey:@"menuname"];
    cell.menuImage.image = [UIImage imageNamed:imagename];
    cell.menuName.text = menuname;
    
    if ([SlideNavigationController sharedInstance].selectIndex == indexPath.row) {
        cell.backgroundColor = [UIColor colorWithRed:50/255.0 green:60/255.0 blue:90/255.0 alpha:1];
    }else{
        cell.backgroundColor = [UIColor clearColor];
    }
//    cell.unreadLabel.layer.cornerRadius = 10;
//    cell.unreadLabel.layer.masksToBounds = YES;
//    cell.unreadLabel.layer.borderWidth = 1.0f;
//    cell.unreadLabel.layer.borderColor = [UIColor redColor].CGColor;
//    cell.unreadLabel.layer.backgroundColor = [UIColor redColor].CGColor;
    [cell.unreadLabel setHidden:YES];
    [cell.unreadImage setHidden:YES];
    if ([menuname isEqualToString:@"我的公告"]) {
        unreadlabel = cell.unreadLabel;
        unreadImage = cell.unreadImage;
//        [self setupUnreadMessageCount:1];
    }
    
    
    
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *lastIndexPaht = [NSIndexPath indexPathForItem:[SlideNavigationController sharedInstance].selectIndex inSection:0];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:lastIndexPaht];
    cell.backgroundColor = [UIColor clearColor];
    [SlideNavigationController sharedInstance].selectIndex = indexPath.row;
	UIStoryboard *mainStoryboard = [self storyboard];
	UIViewController *vc ;
    NSDictionary *info = [self.dataSource objectAtIndex:indexPath.row];
    NSString *vcname = [info objectForKey:@"vcname"];
    vc = [mainStoryboard instantiateViewControllerWithIdentifier: vcname];
    
    if ([vcname isEqualToString:@"HomeViewController"]) {//下级上报
        
            InfoViewController *info1 = [[self storyboard] instantiateViewControllerWithIdentifier: @"InfoViewController"];
            info1.title = @"全部";
            
            InfoViewController *info2 = [[self storyboard] instantiateViewControllerWithIdentifier: @"InfoViewController"];
            info2.title = @"未处理";
            info2.opttype = @"-1";
            
            InfoViewController *info3 = [[self storyboard] instantiateViewControllerWithIdentifier: @"InfoViewController"];
            info3.title = @"已归档";
            info3.opttype = @"1";
            
            InfoViewController *info4 = [[self storyboard] instantiateViewControllerWithIdentifier: @"InfoViewController"];
            info4.title = @"已上报";
            info4.opttype = @"3";
            
            InfoViewController *info5 = [[self storyboard] instantiateViewControllerWithIdentifier: @"InfoViewController"];
            info5.title = @"已录用";
            info5.opttype = @"5";
            
            NSMutableArray *vcs = [NSMutableArray array];
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            NSNumber *type = [userdefaults objectForKey:@"type"];
            switch ([type integerValue]) {
                case MANAGER://管理员(全部.未处理,已归档,已上报)
                    [vcs addObjectsFromArray:@[info1,info2,info3,info4]];
                    break;
                case COUNTY_MANAGER://省管理员
                case CITY_MANAGER://市管理员
                case SHENG_MANAGER://县管理员
                    //(全部,未处理,已归档,已上报,已录用)
                    [vcs addObjectsFromArray:@[info1,info2,info3,info4,info5]];
                    break;
                case SMANAGER:
                    //超级管理员(全部,未处理,已归档)
                    [vcs addObjectsFromArray:@[info1,info2,info3]];
                    break;
                default:
                    break;
            }
            HomeViewController *vc2 = [[HomeViewController alloc] initWithViewControllers:vcs];
            vc2.title = @"下级上报";
            vc2.indicatorInsets = UIEdgeInsetsMake(0, 0, 8, 0);
            vc2.indicator.backgroundColor = [UIColor colorWithRed:72/255.0 green:147/255.0 blue:219/255.0 alpha:1];
        
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc2
                                                                 withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                         andCompletion:nil];
    }else if([vcname isEqualToString:@"MyNoticeViewController"]){//我的公告
        
            NoticeViewController *notice1 = [[self storyboard] instantiateViewControllerWithIdentifier: @"NoticeViewController"];
            notice1.title = @"发送的公告";
            notice1.url = @"/mobile/notice/getNoticeHistory";
            notice1.type = @"1";
            
            NoticeViewController *notice2 = [[self storyboard] instantiateViewControllerWithIdentifier: @"NoticeViewController"];
            notice2.title = @"接受的公告";
            notice2.url = @"/mobile/notice/getReceiveNotice";
            notice2.type = @"2";
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            NSNumber *type = [userdefaults objectForKey:@"type"];
            NSMutableArray *arr = [NSMutableArray array];
            switch ([type integerValue]) {
                case MANAGER:
                case COUNTY_MANAGER:
                case CITY_MANAGER:
                case SHENG_MANAGER:
                case SMANAGER:
                    [arr addObjectsFromArray:@[notice1,notice2]];
                    break;
                default:
                    [arr addObjectsFromArray:@[notice2]];
                    break;
            }
            
            MyNoticeViewController *mynotice = [[MyNoticeViewController alloc] initWithViewControllers:arr];
            mynotice.title = @"我的公告";
            mynotice.indicatorInsets = UIEdgeInsetsMake(0, 0, 8, 0);
            mynotice.indicator.backgroundColor = [UIColor colorWithRed:72/255.0 green:147/255.0 blue:219/255.0 alpha:1];
        
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:mynotice
                                                                 withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                         andCompletion:nil];
    }else{
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                                 withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                         andCompletion:nil];
    }
}

//设置未读消息数
- (void)setupUnreadMessageCount:(NSInteger)unreadCount{
    if (unreadCount > 0) {
        if (unreadCount < 9) {
            unreadlabel.font = [UIFont systemFontOfSize:13];
        }else if(unreadCount > 9 && unreadCount < 99){
            unreadlabel.font = [UIFont systemFontOfSize:12];
        }else{
            unreadlabel.font = [UIFont systemFontOfSize:10];
        }
        [unreadlabel setHidden:NO];
        [unreadImage setHidden:NO];
        unreadlabel.text = [NSString stringWithFormat:@"%ld",(long)unreadCount];
    }else{
        [unreadlabel setHidden:YES];
        [unreadImage setHidden:YES];
    }
    
//    UIApplication *application = [UIApplication sharedApplication];
//    [application setApplicationIconBadgeNumber:unreadCount];
}

//-(void)setupUnreadMessage{
//    int unreadCount =  [unreadlabel.text intValue];
//    if (unreadCount > 0) {
//        unreadCount -= 1;
//    }
//    [self setupUnreadMessageCount:unreadCount];
//}

@end
