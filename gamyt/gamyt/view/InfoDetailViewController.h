//
//  InfoDetailViewController.h
//  gamyt
//
//  Created by yons on 15-3-10.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoDetailViewController : UIViewController

@property(nonatomic, strong) NSDictionary *info;
@property (weak, nonatomic) IBOutlet UIScrollView *myscrollview;
@property (weak, nonatomic) IBOutlet UIImageView *sendpic;
@property (weak, nonatomic) IBOutlet UILabel *sendname;
@property (weak, nonatomic) IBOutlet UILabel *notename;
@property (weak, nonatomic) IBOutlet UIImageView *sepline;
@property (weak, nonatomic) IBOutlet UIImageView *sepline2;
@property (weak, nonatomic) IBOutlet UILabel *opttypename;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *addtime;

@end
