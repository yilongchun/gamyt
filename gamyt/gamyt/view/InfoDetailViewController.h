//
//  InfoDetailViewController.h
//  gamyt
//
//  Created by yons on 15-3-10.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDPhotoBrowser.h"

@interface InfoDetailViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate,SDPhotoBrowserDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) NSDictionary *info;
@property(nonatomic, strong) NSNumber *reportid;
@property (weak, nonatomic) IBOutlet UIScrollView *myscrollview;
@property (weak, nonatomic) IBOutlet UIImageView *sendpic;
@property (weak, nonatomic) IBOutlet UILabel *sendname;
@property (weak, nonatomic) IBOutlet UILabel *notename;
@property (weak, nonatomic) IBOutlet UIImageView *sepline;
@property (weak, nonatomic) IBOutlet UIImageView *sepline2;
@property (weak, nonatomic) IBOutlet UILabel *opttypename;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *addtime;
@property (weak, nonatomic) IBOutlet UIView *sourceImagesContainerView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTopLayout;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UIImageView *img4;

@end
