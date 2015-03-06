//
//  TestViewController.m
//  gamyt
//
//  Created by yons on 15-3-5.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "TestViewController.h"

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
//    view.backgroundColor = [UIColor clearColor];
//    return view;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 20;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testcell"];
    [cell.textLabel setFont:[UIFont systemFontOfSize:17]];
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"我的上报";
            break;
        case 1:
            cell.textLabel.text = @"下级上报";
            break;
        case 2:
            cell.textLabel.text = @"我的公告";
            break;
        case 3:
            cell.textLabel.text = @"单位管理";
            break;
        case 4:
            cell.textLabel.text = @"个人设置";
            break;
        default:
            cell.textLabel.text = @"个人设置";
            break;
    }
    return cell;
}


@end
