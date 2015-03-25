//
//  SignReportTableViewCell.m
//  gamyt
//
//  Created by yons on 15-3-25.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "SignReportTableViewCell.h"

@implementation SignReportTableViewCell

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    [self.btn setHighlighted:highlighted];
}
@end
