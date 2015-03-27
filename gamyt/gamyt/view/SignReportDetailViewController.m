//
//  SignReportDetailViewController.m
//  gamyt
//
//  Created by yons on 15-3-25.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "SignReportDetailViewController.h"
#import "InfoDetailStatusViewController.h"
#import "SignReportViewController.h"

@implementation SignReportDetailViewController{
    
    NSNumber *reportid;
    NSNumber *newsid;
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshSignReportDetail:)
                                                 name:@"refreshSignReportDetail"
                                               object:nil];
    
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"toread_record_icon_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(toInfoDetailStatus)];
    self.navigationItem.rightBarButtonItem = rightitem;
    
    self.sendpic.layer.masksToBounds = YES;
    self.sendpic.layer.cornerRadius = 40;
    
    self.btn.layer.masksToBounds = YES;
    self.btn.layer.cornerRadius = 5.0;
    self.bottonView.layer.masksToBounds = YES;
    self.bottonView.layer.cornerRadius = 5.0;
    self.bottonView.layer.borderColor = BORDER_COLOR.CGColor;
    self.bottonView.layer.borderWidth = 1.0f;
    
    
    [self initData];
    
}

-(void)refreshSignReportDetail:(NSNotification *)notification{
    [self showHudInView:self.view hint:@"加载中"];
    self.type = @"2";
    NSDictionary *userinfo = notification.userInfo;
    NSString *signcontent = [userinfo objectForKey:@"signcontent"];
    [self.info setValue:signcontent forKey:@"content"];
    [self initData];
    [self hideHud];
    
}

//设置数据
-(void)initData{
    NSString *sendname = [self.info objectForKey:@"sendpname"];//姓名
    NSString *sendpic = [self.info objectForKey:@"sendppath"];//照片
    NSString *content = [self.info objectForKey:@"newscontent"];//内容
    NSString *addtime = [self.info objectForKey:@"addtime"];//时间
    
    if ([self.type isEqualToString:@"2"]) {
        NSString *signcontent= [self.info objectForKey:@"content"];
        self.signContent.text = signcontent;
        self.signContent.numberOfLines = 0;
        [self.signContent sizeToFit];
    }
    
    reportid = [self.info objectForKey:@"id"];
    newsid = [self.info objectForKey:@"newsid"];
    
    self.sepline.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    self.sepline2.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    self.sendname.text = sendname;
    self.addtime.text = addtime;
    
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
    
    NSString *path = [self.info objectForKey:@"path"];//照片路径
    [self.img1 setHidden:YES];
    [self.img2 setHidden:YES];
    [self.img3 setHidden:YES];
    [self.img4 setHidden:YES];
    if (path.length == 0) {
        self.contentTopLayout.constant = 0;
    }else{
        NSArray *imgArr =[path componentsSeparatedByString:NSLocalizedString(@",", nil)];
        for (int i = 0; i < imgArr.count; i++) {
            NSString *img = [imgArr objectAtIndex:i];
            NSString *imagePath = [NSString stringWithFormat:@"%@%@%@",[Utils getHostname],REPORT_PATH,img];
            switch (i) {
                case 0:
                {
                    [self.img1 setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"defalut_pic"]];
                    [self.img1 setHidden:NO];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
                    [self.img1 addGestureRecognizer:tap];
                }
                    break;
                case 1:
                {
                    [self.img2 setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"defalut_pic"]];
                    [self.img2 setHidden:NO];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
                    [self.img2 addGestureRecognizer:tap];
                }
                    break;
                case 2:
                {
                    [self.img3 setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"defalut_pic"]];
                    [self.img3 setHidden:NO];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
                    [self.img3 addGestureRecognizer:tap];
                }
                    break;
                case 3:
                {
                    [self.img4 setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"defalut_pic"]];
                    [self.img4 setHidden:NO];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
                    [self.img4 addGestureRecognizer:tap];
                }
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

//布局
-(void)setLayout{
    NSString *path = [self.info objectForKey:@"path"];//照片路径
    if (path.length == 0) {
        self.contentTopLayout.constant = 0;
    }else{
        CGFloat width = [UIScreen mainScreen].bounds.size.width-10-10-5-5-5;
        self.contentTopLayout.constant = width/4;
    }
    if ([self.type isEqualToString:@"1"]) {
        [self.bottonView setHidden:YES];
    }else if([self.type isEqualToString:@"2"]) {
        self.btnHeightLayoutConstraint.constant = 0;
        [self.bottonView setHidden:NO];
    }
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self setLayout];
    }
    if ([self.type isEqualToString:@"1"]) {
        [self.myscrollview setContentSize:CGSizeMake(self.myscrollview.frame.size.width, self.sepline2.frame.origin.y + 100)];
    }else if([self.type isEqualToString:@"2"]){
        [self.myscrollview setContentSize:CGSizeMake(self.myscrollview.frame.size.width, self.bottonView.frame.origin.y + self.bottonView.frame.size.height + 20)];
    }
    
}

-(void)toInfoDetailStatus{
    InfoDetailStatusViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"InfoDetailStatusViewController"];
    vc.newsid = newsid;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)imageClick:(UITapGestureRecognizer *)recognizer
{
    
    NSString *path = [self.info objectForKey:@"path"];
    NSArray *imgArr =[path componentsSeparatedByString:NSLocalizedString(@",", nil)];
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self.sourceImagesContainerView; // 原图的父控件
    browser.imageCount = imgArr.count; // 图片总数
    browser.currentImageIndex = (int)recognizer.view.tag;
    browser.delegate = self;
    [browser show];
}

#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [self.sourceImagesContainerView.subviews[index] image];
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *path = [self.info objectForKey:@"path"];
    NSArray *imgArr =[path componentsSeparatedByString:NSLocalizedString(@",", nil)];
    NSString *img = [imgArr objectAtIndex:index];
    NSString *imagePath = [NSString stringWithFormat:@"%@%@%@",[Utils getHostname],REPORT_PATH,img];
    return [NSURL URLWithString:imagePath];
}

- (IBAction)sign:(id)sender {
    
    SignReportViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"SignReportViewController"];
    vc.info = self.info;
    [self presentViewController:vc animated:YES completion:nil];
    
}
@end
