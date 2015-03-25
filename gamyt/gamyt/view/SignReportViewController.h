//
//  SignReportViewController.h
//  gamyt
//
//  Created by yons on 15-3-25.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignReportViewController : UIViewController
- (IBAction)cancel:(id)sender;
- (IBAction)ok:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *mytextview;
@property(nonatomic, strong) NSDictionary *info;
@end
