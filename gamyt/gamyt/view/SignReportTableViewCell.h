//
//  SignReportTableViewCell.h
//  gamyt
//
//  Created by yons on 15-3-25.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignReportTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *backview;
@property (weak, nonatomic) IBOutlet UIView *innerbackview;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *sendpname;
@property (weak, nonatomic) IBOutlet UILabel *addtime;
@property (weak, nonatomic) IBOutlet UILabel *newscontent;
@property (weak, nonatomic) IBOutlet UIImageView *haveimg;
@end
