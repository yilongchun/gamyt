//
//  InfoToUpViewController.h
//  gamyt
//
//  Created by yons on 15-3-16.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoToUpViewController : UIViewController<UIAlertViewDelegate>

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *infoType;
@property (weak, nonatomic) IBOutlet UIButton *chooseInfoTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
- (IBAction)setEdit:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *backimage;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UILabel *textnumberLabel;


@end
