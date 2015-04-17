//
//  NoticeTableViewCell.h
//  gamyt
//
//  Created by yons on 15-3-23.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIView *backview;
@property (weak, nonatomic) IBOutlet UIImageView *unreadStatus;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unreadStatusWidth;
@property (weak, nonatomic) IBOutlet UIImageView *haveimg;
@end
