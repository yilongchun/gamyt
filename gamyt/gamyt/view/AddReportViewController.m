//
//  AddReportViewController.m
//  gamyt
//
//  Created by yons on 15-3-12.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "AddReportViewController.h"

@interface AddReportViewController ()

@end

@implementation AddReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.backimage.backgroundColor = [UIColor whiteColor];
    //设置layer
    CALayer *layer=[self.backimage layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框线的宽
    [layer setBorderWidth:1];
    //设置边框线的颜色
    [layer setBorderColor:[[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1] CGColor]];
}

- (void)textViewDidChange:(UITextView *)textView{
    NSLog(@"%d",textView.text.length);
    if (textView.text.length <= 200) {
        NSString *s = [NSString stringWithFormat:@"最多能输入%d个字符",200 - textView.text.length];
        self.textnumberLabel.text = s;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)save:(id)sender {
    NSLog(@"上报");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
