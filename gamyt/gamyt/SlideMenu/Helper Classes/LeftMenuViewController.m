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
    
    [SlideNavigationController sharedInstance].selectIndex = 0;
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 5;
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
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftMenuCell"];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:18]];
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:50/255.0 green:60/255.0 blue:90/255.0 alpha:1];
	switch (indexPath.row)
	{
		case 0:
            cell.imageView.image = [UIImage imageNamed:@"menu_item_myreport_icon"];
			cell.textLabel.text = @"我的上报";
			break;
		case 1:
            cell.imageView.image = [UIImage imageNamed:@"menu_item_formyreport_icon1"];
			cell.textLabel.text = @"下级上报";
			break;
		case 2:
            cell.imageView.image = [UIImage imageNamed:@"menu_item_notice_icon"];
			cell.textLabel.text = @"我的公告";
			break;
        case 3:
            cell.imageView.image = [UIImage imageNamed:@"menu_item_unitmanage_icon"];
            cell.textLabel.text = @"单位管理";
            break;
        case 4:
            cell.imageView.image = [UIImage imageNamed:@"menu_item_setting_icon"];
            cell.textLabel.text = @"个人设置";
            break;
//		case 5:
//			cell.textLabel.text = @"退出";
//			break;
	}
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
    
	switch (indexPath.row)
	{
		case 0:
			vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"HomeViewController"];
			break;
			
		case 1:
			vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"MainViewController"];
			break;
			
		case 2:
			vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"MyNotice"];
			break;
			
//		case 3:
//			[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
//			[[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
//			return;
//			break;
        default:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"MainViewController"];
            break;
	}
	
	[[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
															 withSlideOutAnimation:self.slideOutAnimationEnabled
																	 andCompletion:nil];
}

@end
