//
//  InfoToUpViewController.m
//  gamyt
//
//  Created by yons on 15-3-16.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "InfoToUpViewController.h"

@implementation InfoToUpViewController{
    BOOL edit;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    edit = YES;
    [self setEdit:nil];
    
    self.infoType.layer.borderColor = [BORDER_COLOR CGColor];
    self.infoType.layer.borderWidth = 1.0;
    
    
    NSMutableParagraphStyle *paragraphStyle = [[ NSMutableParagraphStyle alloc ] init ];
    [paragraphStyle setFirstLineHeadIndent :10 ];
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:self.infoType.text attributes:@{ NSParagraphStyleAttributeName : paragraphStyle}];
    self.infoType.attributedText = attrText;
    
    
    //设置layer
    CALayer *layer=[self.backimage layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框线的宽
    [layer setBorderWidth:1];
    //设置边框线的颜色
    [layer setBorderColor:[BORDER_COLOR CGColor]];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancel:(id)sender{
    NSString *title = @"确定退出?";
    NSString *message = @"离开后,您操作后的信息将不再保存!";
    if ([[UIDevice currentDevice] systemVersion].floatValue < 8.0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1;
        [alert show];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSLog(@"确定");
            [self cancelAndBack];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
    
}

- (IBAction)save:(id)sender {
    NSLog(@"上报");
}

-(void)cancelAndBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {//确定
            NSLog(@"确定");
            [self cancelAndBack];
        }
    }
}


- (IBAction)setEdit:(id)sender {
    if (edit) {
        edit = NO;
        [self.editBtn setImage:[UIImage imageNamed:@"modifycontent_normal"] forState:UIControlStateNormal];
        [self.editBtn setTitleColor:[UIColor colorWithRed:36/255.0 green:102/255.0 blue:171/255.0 alpha:1] forState:UIControlStateNormal];
        [self.editBtn setTitle:@"修改" forState:UIControlStateNormal];
        self.backimage.backgroundColor = BACKGROUND_COLOR;
        self.content.backgroundColor = BACKGROUND_COLOR;
        [self.textnumberLabel setHidden:YES];
        [self.content setUserInteractionEnabled:NO];
        [self.content setTextColor:[UIColor grayColor]];
        
    }else{//修改
        edit = YES;
        [self.editBtn setImage:[UIImage imageNamed:@"modifycontent_normal"] forState:UIControlStateNormal];
        [self.editBtn setTitleColor:[UIColor colorWithRed:36/255.0 green:102/255.0 blue:171/255.0 alpha:1] forState:UIControlStateNormal];
        [self.editBtn setTitle:@"完成" forState:UIControlStateNormal];
        [self.content setUserInteractionEnabled:YES];
        self.backimage.backgroundColor = [UIColor whiteColor];
        self.content.backgroundColor = [UIColor whiteColor];
        [self.textnumberLabel setHidden:NO];
        [self.content setTextColor:[UIColor blackColor]];
        
    }
}
@end
