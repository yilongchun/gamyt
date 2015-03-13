//
//  InfoDetailStatusViewController.m
//  gamyt
//
//  Created by yons on 15-3-13.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "InfoDetailStatusViewController.h"
#import "TimeLineViewControl.h"

@implementation InfoDetailStatusViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    
    NSArray *times = @[@"2015-03-13 02:18",@"02:09",@"2015-03-12 06:01",@"2015-03-12 06:01",@"2015-03-12 06:01",@"2015-03-12 06:01",@"2015-03-12 06:01",@"2015-03-12 06:01",@"2015-03-12 06:01",@"2015-03-12 06:01"];
    NSArray *descriptions = @[@"夷陵区分局\n张勇\n上报",@"夷陵区分局\n张勇\n上报",@"夷陵区分局\n张勇\n上报",@"夷陵区分局\n张勇\n上报",@"夷陵区分局\n张勇\n上报",@"夷陵区分局\n张勇\n上报",@"夷陵区分局\n张勇\n上报",@"夷陵区分局\n张勇\n上报",@"夷陵区分局\n张勇\n上报",@"夷陵区分局\n张勇\n上报"];
    TimeLineViewControl *timeline = [[TimeLineViewControl alloc] initWithTimeArray:times
                                                           andTimeDescriptionArray:descriptions
                                                                  andCurrentStatus:5
                                                                          andFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height)];
    timeline.progressViewContainerLeft = [NSNumber numberWithFloat:([UIScreen mainScreen].bounds.size.width - 26) / 2] ;
//    timeline.backgroundColor = [UIColor grayColor];
    
//    CGPoint point = self.view.center;
//    point.y = (self.view.frame.size.height - 64)/2 + 64;
//    timeline.center = point;
    [self.myscrollview addSubview:timeline];
    [self.myscrollview setContentSize:CGSizeMake(self.view.frame.size.width, 1000)];
    
//    [self.view addSubview:timeline];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
