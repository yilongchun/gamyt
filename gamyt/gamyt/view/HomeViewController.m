//
//  HomeViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "HomeViewController.h"
#import "LeftMenuViewController.h"


@implementation HomeViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.navigationController setNavigationBarHidden:NO];
    
//    NSLog(@"123");
    
    
//    UIViewController *test = [[self storyboard] instantiateViewControllerWithIdentifier: @"InfoViewController"];
//    UIViewController *test2 = [[self storyboard] instantiateViewControllerWithIdentifier: @"InfoViewController"];
    
    
    
//    CGFloat yDelta;
//    
//    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
//        yDelta = 20.0f;
//    } else {
//        yDelta = 0.0f;
//    }
//    
//    UIViewController *test = [[self storyboard]
//                                instantiateViewControllerWithIdentifier: @"InfoViewController"];
//    [test.view setFrame:CGRectMake(0, 50+yDelta+44, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height-50-44-yDelta)];
//    UIViewController *test2 = [[self storyboard]
//                              instantiateViewControllerWithIdentifier: @"InfoViewController"];
//    [test2.view setFrame:CGRectMake(0, 50+yDelta+44, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height-50-44-yDelta)];
//    
//    
//    // Segmented control with more customization and indexChangeBlock
//    self.segmentedControl3 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"全部", @"未处理", @"已归档", @"已上报", @"已录用"]];
//    [self.segmentedControl3 setFrame:CGRectMake(0, 44 + yDelta, [UIScreen mainScreen].bounds.size.width, 50)];
//    
//    __weak typeof(self) weakSelf = self;
//    [self.segmentedControl3 setIndexChangeBlock:^(NSInteger index) {
//        NSLog(@"Selected index %ld (via block)", (long)index);
//        if (index == 0) {
//            if (![weakSelf.view.subviews containsObject:test.view]) {
//                [weakSelf.view addSubview:test.view];
//            }
//            [weakSelf.view bringSubviewToFront:test.view];
//        }
//        if (index == 1) {
//            if (![weakSelf.view.subviews containsObject:test2.view]) {
//                [weakSelf.view addSubview:test2.view];
//            }
//            [weakSelf.view bringSubviewToFront:test2.view];
//        }
//    }];
//    self.segmentedControl3.selectionIndicatorHeight = 4.0f;
//    self.segmentedControl3.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
//    self.segmentedControl3.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
//    self.segmentedControl3.selectedTextColor = [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1];
//    self.segmentedControl3.selectionIndicatorColor = [UIColor colorWithRed:0.5 green:0.8 blue:1 alpha:1];
//    self.segmentedControl3.selectionStyle = HMSegmentedControlSelectionStyleBox;
//    self.segmentedControl3.selectedSegmentIndex = HMSegmentedControlNoSegment;
//    self.segmentedControl3.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
//    self.segmentedControl3.shouldAnimateUserSelection = YES;
//    self.segmentedControl3.tag = 2;
//    [self.view addSubview:self.segmentedControl3];
//    [self.segmentedControl3 setSelectedSegmentIndex:0];
//    [self.view addSubview:test.view];
    
    

}



#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
	return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
	return NO;
}



@end
