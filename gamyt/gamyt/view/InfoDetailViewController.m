//
//  InfoDetailViewController.m
//  gamyt
//
//  Created by yons on 15-3-10.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "InfoDetailViewController.h"

@implementation InfoDetailViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    NSLog(@"%@",self.info);
    
    
    NSString *sendname = [self.info objectForKey:@"sendname"];//姓名
    NSString *notename = [self.info objectForKey:@"notename"];//单位
//    NSNumber *opttype = [self.info objectForKey:@"opttype"];//类型
    NSString *sendpic = [self.info objectForKey:@"sendpic"];//照片
//    NSString *content = [self.info objectForKey:@"content"];//内容
//    NSString *addtime = [self.info objectForKey:@"addtime"];//时间
//    
//    NSString *opttopename = [Utils getOptTypeName:opttype];
    self.sepline.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    self.sendname.text = sendname;
    self.notename.text = notename;
    
    NSString *imagePath = [NSString stringWithFormat:@"%@%@%@",[Utils getHostname],[Utils getImagePath],sendpic];
    NSLog(@"%@",imagePath);
//    self.sendpic 
}


@end
