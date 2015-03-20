//
//  AddReportViewController.h
//  gamyt
//
//  Created by yons on 15-3-12.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerHeader.h"

@interface AddReportViewController : UIViewController<UITextViewDelegate,ELCImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)chooseImage:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *backimage;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UILabel *textnumberLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayout;

@property (weak, nonatomic) IBOutlet UIButton *choseBtn;
@property (nonatomic, strong) NSMutableArray *chosenImages;

@end
