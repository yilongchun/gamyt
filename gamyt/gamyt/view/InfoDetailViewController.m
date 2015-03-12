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
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.sendpic.layer.masksToBounds = YES;
    self.sendpic.layer.cornerRadius = 40;
   
    NSString *sendname = [self.info objectForKey:@"sendname"];//姓名
    NSString *notename = [self.info objectForKey:@"notename"];//单位
    NSNumber *opttype = [self.info objectForKey:@"opttype"];//类型
    NSString *sendpic = [self.info objectForKey:@"sendpic"];//照片
    NSString *content = [self.info objectForKey:@"content"];//内容
    content = [NSString stringWithFormat:@"%@%@%@",content,content,content];
    NSString *addtime = [self.info objectForKey:@"addtime"];//时间
    

    self.sepline.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    self.sepline2.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    self.sendname.text = sendname;
    self.notename.text = [NSString stringWithFormat:@"单位:%@",notename];
    self.addtime.text = addtime;
    if ([opttype intValue] == -1) {
        self.opttypename.textColor = [UIColor colorWithRed:56/255.0 green:143/255.0 blue:219/255.0 alpha:1];
    }else{
        self.opttypename.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    }
    self.opttypename.text = [Utils getOptTypeName:opttype];
    
    NSString *imagePath = [NSString stringWithFormat:@"%@%@%@",[Utils getHostname],[Utils getImagePath],sendpic];
    [self.sendpic setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"defalut_photo"]];
    self.content.text = content;
    self.content.numberOfLines = 0;
    [self.content sizeToFit];
    // 列寬
    CGFloat contentWidth = [UIScreen mainScreen].bounds.size.width;
    UIFont *font = [UIFont systemFontOfSize:17];
    CGSize textSize;
    if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        textSize = [content boundingRectWithSize:CGSizeMake(contentWidth-20, MAXFLOAT)
                                         options:options
                                      attributes:attributes
                                         context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        textSize = [content sizeWithFont:font
                       constrainedToSize:CGSizeMake(contentWidth-20, MAXFLOAT)
                           lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        
    }
    [self.content setFrame:CGRectMake(self.content.frame.origin.x, self.content.frame.origin.y, textSize.width, textSize.height)];

    
    UIImage *img1 = [[UIImage imageNamed:@"base_blue_btn_normal.9"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    
    [self.btn1 setBackgroundImage:img1 forState:UIControlStateNormal];
    [self.btn2 setBackgroundImage:img1 forState:UIControlStateNormal];
    [self.btn3 setBackgroundImage:img1 forState:UIControlStateNormal];
    [self.btn4 setBackgroundImage:img1 forState:UIControlStateNormal];
    
    UIImage *img2 = [[UIImage imageNamed:@"base_blue_btn_pressed.9"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [self.btn1 setBackgroundImage:img2 forState:UIControlStateHighlighted];
    [self.btn2 setBackgroundImage:img2 forState:UIControlStateHighlighted];
    [self.btn3 setBackgroundImage:img2 forState:UIControlStateHighlighted];
    [self.btn4 setBackgroundImage:img2 forState:UIControlStateHighlighted];
    
    UIImage *imgArrow = [UIImage imageNamed:@"detail_adopt_icon"];
    [self.btn1 setImage:imgArrow forState:UIControlStateNormal];
    
    UIImage *imgArrow2 = [UIImage imageNamed:@"detail_toreport_icon"];
    [self.btn2 setImage:imgArrow2 forState:UIControlStateNormal];
    
    UIImage *imgArrow3 = [UIImage imageNamed:@"detail_save_icon"];
    [self.btn3 setImage:imgArrow3 forState:UIControlStateNormal];
    
    UIImage *imgArrow4 = [UIImage imageNamed:@"detail_toread_icon"];
    [self.btn4 setImage:imgArrow4 forState:UIControlStateNormal];
    
    
    
    self.btn1.layer.masksToBounds = YES;
    self.btn1.layer.cornerRadius = 5.0;
    self.btn2.layer.masksToBounds = YES;
    self.btn2.layer.cornerRadius = 5.0;
    self.btn3.layer.masksToBounds = YES;
    self.btn3.layer.cornerRadius = 5.0;
    self.btn4.layer.masksToBounds = YES;
    self.btn4.layer.cornerRadius = 5.0;
    
//    [self.btn1 setImageEdgeInsets:UIEdgeInsetsMake(0, -imgArrow.size.width, 0, imgArrow.size.width)];
//    [self.btn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, self.btn1.titleLabel.bounds.size.width, 0, -self.btn1.titleLabel.bounds.size.width)];
    
    

    
    
    
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.myscrollview setContentSize:CGSizeMake(self.myscrollview.frame.size.width, self.sepline2.frame.origin.y + 60)];
}

-(void)viewDidLayoutSubviews
{
    [self.myscrollview setContentSize:CGSizeMake(self.myscrollview.frame.size.width, self.sepline2.frame.origin.y + 60)];
}


@end
