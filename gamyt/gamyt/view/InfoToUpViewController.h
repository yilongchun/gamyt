//
//  InfoToUpViewController.h
//  gamyt
//
//  Created by yons on 15-3-16.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoToUpViewController : UIViewController<UIAlertViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate>

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)setEdit:(id)sender;
- (IBAction)chooseType:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *infoType;
@property (weak, nonatomic) IBOutlet UIButton *chooseInfoTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightLayout;
@property (weak, nonatomic) IBOutlet UIImageView *backimage;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UILabel *textnumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UIImageView *img4;
@property(nonatomic, strong) NSDictionary *info;

@end
