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

@implementation LeftMenuViewController

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
    
    [self loadData];
        
}

-(void)loadData{
    [SlideNavigationController sharedInstance].selectIndex = 0;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSArray *menus = [userdefaults objectForKey:@"menus"];
    self.dataSource = [NSMutableArray arrayWithArray:menus];
    [self.tableView reloadData];
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
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftMenuCell"];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:17]];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:50/255.0 green:60/255.0 blue:90/255.0 alpha:1];
    NSDictionary *info = [self.dataSource objectAtIndex:indexPath.row];
    NSString *imagename = [info objectForKey:@"imagename"];
    NSString *menuname = [info objectForKey:@"menuname"];
    cell.imageView.image = [UIImage imageNamed:imagename];
    cell.textLabel.text = menuname;
    if ([SlideNavigationController sharedInstance].selectIndex == indexPath.row) {
        cell.backgroundColor = [UIColor colorWithRed:50/255.0 green:60/255.0 blue:90/255.0 alpha:1];
    }else{
        cell.backgroundColor = [UIColor clearColor];
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
    }else{
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                                 withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                         andCompletion:nil];
    }
    
    
    
    
	
}

@end
