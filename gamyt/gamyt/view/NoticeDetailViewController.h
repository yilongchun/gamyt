//
//  NoticeDetailViewController.h
//  gamyt
//
//  Created by yons on 15-3-23.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDPhotoBrowser.h"

@interface NoticeDetailViewController : UIViewController<SDPhotoBrowserDelegate>

@property(nonatomic, strong) NSDictionary *info;

@property (weak, nonatomic) IBOutlet UILabel *addtime;
@property (weak, nonatomic) IBOutlet UILabel *sendname;
@property (weak, nonatomic) IBOutlet UILabel *sendnodename;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *myscrollview;
@property (weak, nonatomic) IBOutlet UIView *sourceImagesContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayoutConstraint;


@end
