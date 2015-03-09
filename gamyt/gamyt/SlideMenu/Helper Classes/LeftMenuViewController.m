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
	[[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
															 withSlideOutAnimation:self.slideOutAnimationEnabled
																	 andCompletion:nil];
}

@end
