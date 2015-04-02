//
//  MyNotict.m
//  gamyt
//
//  Created by yons on 15-3-4.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "MyNoticeViewController.h"
#import "XDKAirMenuController.h"

@implementation MyNoticeViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"menuchange_normal"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonPressed:)];
    self.navigationItem.leftBarButtonItem = leftItem;
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

//#pragma mark - SlideNavigationController Methods -
//
//- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
//{
//    return YES;
//}
//
//- (BOOL)slideNavigationControllerShouldDisplayRightMenu
//{
//    return NO;
//}


@end
