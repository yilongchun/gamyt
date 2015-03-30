//
//  QRcodeViewController.m
//  gamyt
//
//  Created by yons on 15-3-30.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "QRcodeViewController.h"

@implementation QRcodeViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.imageview setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"defalut_pic"]];
    [self.imageview setContentMode:UIViewContentModeCenter];
}

@end
