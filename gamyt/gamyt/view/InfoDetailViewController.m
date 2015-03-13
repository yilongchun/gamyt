//
//  InfoDetailViewController.m
//  gamyt
//
//  Created by yons on 15-3-10.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "InfoDetailViewController.h"

@implementation InfoDetailViewController{
    NSMutableArray *btns;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"toread_record_icon_normal"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem = rightitem;
    
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
    
    NSString *imagePath = [NSString stringWithFormat:@"%@%@%@",[Utils getHostname],IMAGE_PATH,sendpic];
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

    
    [self initButtons];
    
    NSString *path = [self.info objectForKey:@"path"];//照片路径
    if (path.length == 0) {
        [self.img1 removeFromSuperview];
        [self.img2 removeFromSuperview];
        [self.img3 removeFromSuperview];
        [self.img4 removeFromSuperview];
    }else{
        NSArray *imgArr =[path componentsSeparatedByString:NSLocalizedString(@",", nil)];
        for (int i = 0; i < imgArr.count; i++) {
            NSString *img = [imgArr objectAtIndex:i];
            NSString *imagePath = [NSString stringWithFormat:@"%@%@%@",[Utils getHostname],REPORT_PATH,img];
            switch (i) {
                case 0:
                    [self.img1 setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"defalut_pic"]];
                    break;
                case 1:
                    [self.img2 setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"defalut_pic"]];
                    break;
                case 2:
                    [self.img3 setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"defalut_pic"]];
                    break;
                case 3:
                    [self.img4 setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"defalut_pic"]];
                    break;
                default:
                    break;
            }
        }
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        [self setLayout];
    }
    
}

-(void)initButtons{
    self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn1 addTarget:self action:@selector(action1) forControlEvents:UIControlEventTouchUpInside];
    [self.btn2 addTarget:self action:@selector(action2) forControlEvents:UIControlEventTouchUpInside];
    [self.btn3 addTarget:self action:@selector(action3) forControlEvents:UIControlEventTouchUpInside];
    [self.btn4 addTarget:self action:@selector(action4) forControlEvents:UIControlEventTouchUpInside];
    self.btn1.translatesAutoresizingMaskIntoConstraints = NO;
    self.btn2.translatesAutoresizingMaskIntoConstraints = NO;
    self.btn3.translatesAutoresizingMaskIntoConstraints = NO;
    self.btn4.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIImage *img1 = [[UIImage imageNamed:@"base_blue_btn_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    [self.btn1 setBackgroundImage:img1 forState:UIControlStateNormal];
    [self.btn2 setBackgroundImage:img1 forState:UIControlStateNormal];
    [self.btn3 setBackgroundImage:img1 forState:UIControlStateNormal];
    [self.btn4 setBackgroundImage:img1 forState:UIControlStateNormal];
    
    UIImage *img2 = [[UIImage imageNamed:@"base_blue_btn_pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    [self.btn1 setBackgroundImage:img2 forState:UIControlStateHighlighted];
    [self.btn2 setBackgroundImage:img2 forState:UIControlStateHighlighted];
    [self.btn3 setBackgroundImage:img2 forState:UIControlStateHighlighted];
    [self.btn4 setBackgroundImage:img2 forState:UIControlStateHighlighted];
    
    UIImage *imgArrow = [UIImage imageNamed:@"detail_adopt_icon"];
    [self.btn1 setImage:imgArrow withTitle:@"录用" forState:UIControlStateNormal];
    [self.btn1 setImage:imgArrow withTitle:@"录用" forState:UIControlStateHighlighted];
    
    UIImage *imgArrow2 = [UIImage imageNamed:@"detail_toreport_icon"];
    [self.btn2 setImage:imgArrow2 withTitle:@"上报" forState:UIControlStateNormal];
    [self.btn2 setImage:imgArrow2 withTitle:@"上报" forState:UIControlStateHighlighted];
    
    UIImage *imgArrow3 = [UIImage imageNamed:@"detail_save_icon"];
    [self.btn3 setImage:imgArrow3 withTitle:@"归档" forState:UIControlStateNormal];
    [self.btn3 setImage:imgArrow3 withTitle:@"归档" forState:UIControlStateHighlighted];
    
    UIImage *imgArrow4 = [UIImage imageNamed:@"detail_toread_icon"];
    [self.btn4 setImage:imgArrow4 withTitle:@"报审" forState:UIControlStateNormal];
    [self.btn4 setImage:imgArrow4 withTitle:@"报审" forState:UIControlStateHighlighted];
    
    self.btn1.layer.masksToBounds = YES;
    self.btn1.layer.cornerRadius = 5.0;
    self.btn2.layer.masksToBounds = YES;
    self.btn2.layer.cornerRadius = 5.0;
    self.btn3.layer.masksToBounds = YES;
    self.btn3.layer.cornerRadius = 5.0;
    self.btn4.layer.masksToBounds = YES;
    self.btn4.layer.cornerRadius = 5.0;
    
    btns = [NSMutableArray array];
    
    
    //超级管理员 只有归档
    //其他管理员 4个都有
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *type = [userdefaults objectForKey:@"type"];
    switch ([type integerValue]) {
        case MANAGER://管理员
        case COUNTY_MANAGER://省管理员
        case CITY_MANAGER://市管理员
        case SHENG_MANAGER://县管理员
        {
                //录用
            NSNumber *hireed = [self.info objectForKey:@"hireed"];
            if (![hireed boolValue]) {
                [btns addObject:self.btn1];
                [self.myscrollview addSubview:self.btn1];
            }
            //上报
            NSNumber *reported = [self.info objectForKey:@"reported"];
            if (![reported boolValue]) {
                [btns addObject:self.btn2];
                [self.myscrollview addSubview:self.btn2];
            }
            //归档
            NSNumber *archived = [self.info objectForKey:@"archived"];
            if (![archived boolValue]) {
                [btns addObject:self.btn3];
                [self.myscrollview addSubview:self.btn3];
            }
            //报审
            [btns addObject:self.btn4];
            [self.myscrollview addSubview:self.btn4];
        }
            break;
        case SMANAGER:
        {//超级管理员
            //归档
            NSNumber *archived = [self.info objectForKey:@"archived"];
            if (![archived boolValue]) {
                [btns addObject:self.btn3];
                [self.myscrollview addSubview:self.btn3];
            }
        }
            break;
        default:
            break;
    }
}

-(void)setLayout{
    NSString *path = [self.info objectForKey:@"path"];//照片路径
    if (path.length == 0) {
        self.contentTopLayout.constant = 8;
    }else{
        CGFloat width = [UIScreen mainScreen].bounds.size.width/4 - 10;
        self.contentTopLayout.constant = width + 16;
//        NSArray *imgArr =[path componentsSeparatedByString:NSLocalizedString(@",", nil)];
//        for (int i = 0; i < imgArr.count; i++) {
//            NSString *img = [imgArr objectAtIndex:i];
//            NSString *imagePath = [NSString stringWithFormat:@"%@%@%@",[Utils getHostname],REPORT_PATH,img];
//            UIImageView *image = [[UIImageView alloc]init];
//            image.translatesAutoresizingMaskIntoConstraints = NO;
//            [image setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"defalut_pic"]];
//            [self.img1 setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"defalut_pic"]];
//            [self.view addSubview:image];
//            NSLayoutConstraint *imageWidth = [NSLayoutConstraint constraintWithItem:image attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
//            NSLayoutConstraint *imageHeight = [NSLayoutConstraint constraintWithItem:image attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
//            [image addConstraints:@[imageWidth,imageHeight]];
//            [self.view addConstraint:[NSLayoutConstraint
//                                      constraintWithItem:image
//                                      attribute:NSLayoutAttributeLeading
//                                      relatedBy:NSLayoutRelationEqual
//                                      toItem:self.view
//                                      attribute:NSLayoutAttributeLeading
//                                      multiplier:1
//                                      constant:10 + ((width + 5) * i)]];
//            [self.view addConstraint:[NSLayoutConstraint
//                                      constraintWithItem:image
//                                      attribute:NSLayoutAttributeTop
//                                      relatedBy:NSLayoutRelationEqual
//                                      toItem:self.sepline
//                                      attribute:NSLayoutAttributeBottom
//                                      multiplier:1
//                                      constant:8]];
//        }
    }
    
    
    
    
    
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width/4 - 10;
    
    for (int i = 0 ; i < btns.count; i++) {
        UIButton *btn = [btns objectAtIndex:i];
        
        NSLayoutConstraint *btnWidth = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
        NSLayoutConstraint *btnHeight = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44];
        [btn addConstraints:@[btnWidth,btnHeight]];
        [self.view addConstraint:[NSLayoutConstraint
                                  constraintWithItem:btn
                                  attribute:NSLayoutAttributeLeading
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self.view
                                  attribute:NSLayoutAttributeLeading
                                  multiplier:1
                                  constant:10 + (width + 5) * i]];
        [self.view addConstraint:[NSLayoutConstraint
                                  constraintWithItem:btn
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self.sepline2
                                  attribute:NSLayoutAttributeBottom
                                  multiplier:1
                                  constant:+10]];
    }
    
    
//    NSLayoutConstraint *btnWidth = [NSLayoutConstraint constraintWithItem:self.btn1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
//    NSLayoutConstraint *btnHeight = [NSLayoutConstraint constraintWithItem:self.btn1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44];
//    [self.btn1 addConstraints:@[btnWidth,btnHeight]];
//    [self.view addConstraint:[NSLayoutConstraint
//                            constraintWithItem:self.btn1
//                            attribute:NSLayoutAttributeLeading
//                            relatedBy:NSLayoutRelationEqual
//                            toItem:self.view
//                            attribute:NSLayoutAttributeLeading
//                            multiplier:1
//                            constant:10]];
//    [self.view addConstraint:[NSLayoutConstraint
//                            constraintWithItem:self.btn1
//                            attribute:NSLayoutAttributeTop
//                            relatedBy:NSLayoutRelationEqual
//                            toItem:self.sepline2
//                            attribute:NSLayoutAttributeBottom
//                            multiplier:1
//                            constant:+10]];
    
//    NSLayoutConstraint *btnWidth2 = [NSLayoutConstraint constraintWithItem:self.btn2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
//    NSLayoutConstraint *btnHeight2 = [NSLayoutConstraint constraintWithItem:self.btn2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44];
//    [self.btn2 addConstraints:@[btnWidth2,btnHeight2]];
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:self.btn2
//                              attribute:NSLayoutAttributeLeading
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:self.view
//                              attribute:NSLayoutAttributeLeading
//                              multiplier:1
//                              constant:10]];
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:self.btn1
//                              attribute:NSLayoutAttributeTop
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:self.sepline2
//                              attribute:NSLayoutAttributeBottom
//                              multiplier:1
//                              constant:+10]];
    
//    NSLayoutConstraint *btnWidth3 = [NSLayoutConstraint constraintWithItem:self.btn3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
//    NSLayoutConstraint *btnHeight3 = [NSLayoutConstraint constraintWithItem:self.btn3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44];
//    [self.btn3 addConstraints:@[btnWidth3,btnHeight3]];
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:self.btn1
//                              attribute:NSLayoutAttributeLeading
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:self.view
//                              attribute:NSLayoutAttributeLeading
//                              multiplier:1
//                              constant:10]];
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:self.btn1
//                              attribute:NSLayoutAttributeTop
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:self.sepline2
//                              attribute:NSLayoutAttributeBottom
//                              multiplier:1
//                              constant:+10]];
    
//    NSLayoutConstraint *btnWidth4 = [NSLayoutConstraint constraintWithItem:self.btn4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
//    NSLayoutConstraint *btnHeight4 = [NSLayoutConstraint constraintWithItem:self.btn4 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44];
//    [self.btn4 addConstraints:@[btnWidth4,btnHeight4]];
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:self.btn1
//                              attribute:NSLayoutAttributeLeading
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:self.view
//                              attribute:NSLayoutAttributeLeading
//                              multiplier:1
//                              constant:10]];
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:self.btn1
//                              attribute:NSLayoutAttributeTop
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:self.sepline2
//                              attribute:NSLayoutAttributeBottom
//                              multiplier:1
//                              constant:+10]];
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.myscrollview setContentSize:CGSizeMake(self.myscrollview.frame.size.width, self.sepline2.frame.origin.y + 100)];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self setLayout];
    }
    [self.myscrollview setContentSize:CGSizeMake(self.myscrollview.frame.size.width, self.sepline2.frame.origin.y + 100)];
}

-(void)action1{
    NSLog(@"录用");
}

-(void)action2{
    NSLog(@"上报");
}

-(void)action3{
    NSLog(@"归档");
}

-(void)action4{
    NSLog(@"报审");
}


@end
