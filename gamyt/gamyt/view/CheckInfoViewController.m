//
//  CheckInfoViewController.m
//  gamyt
//
//  Created by yons on 15-3-6.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "CheckInfoViewController.h"
#import "XDKAirMenuController.h"

@implementation CheckInfoViewController

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


@end
