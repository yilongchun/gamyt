//
//  NoticeDetailViewController.m
//  gamyt
//
//  Created by yons on 15-3-23.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "NoticeDetailViewController.h"

@implementation NoticeDetailViewController{
    CGSize textSize;
    
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if (self.info) {
        self.noticeId = [self.info objectForKey:@"id"];
        if ([self.type isEqualToString:@"1"]) {
            [self initData];
        }else if([self.type isEqualToString:@"2"]){
            NSNumber *readed = [self.info objectForKey:@"readed"];
            if ([readed boolValue]) {
                [self initData];
            }else{
                [self loadData];
            }
        }
    }else if (self.noticeId){
        [self loadData];
    }
    
    
    
    
}

-(void)loadData{
    [self showHudInView:self.view hint:@"加载中"];
    NSString *str = [NSString stringWithFormat:@"%@%@",[Utils getHostname],@"/mobile/notice/getReceiveNoticeDetail"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    //    [request setTimeoutInterval:30.0];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [request setValue:[numberFormatter stringFromNumber:[Utils getUserId]] forHTTPHeaderField:USERID];
    [request setValue:[Utils getToken] forHTTPHeaderField:TOKEN];
    
    //非JSON格式
    NSString *param = [NSString stringWithFormat:@"nid=%d",[self.noticeId intValue]];
    [request setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        NSLog(@"获取到的数据为：%@",dict);
        NSDictionary *resultDict = [NSDictionary cleanNullForDic:dict];
        if (resultDict == nil) {
            NSLog(@"json parse failed \r\n");
        }else{
            NSLog(@"%@",resultDict);
        }
        NSNumber *code = [resultDict objectForKey:@"code"];
        if ([code intValue] == 1) {
            [self hideHud];
            [self showHint:@"加载失败"];
        }else if([code intValue] == 4){
            [self hideHud];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:self];
        }else if([code intValue] == 0){
            [self hideHud];
            NSDictionary *dic = [NSDictionary cleanNullForDic:[resultDict objectForKey:@"data"]];
            self.info = dic;
            [self initData];
            
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self hideHud];
        [self showHint:@"连接失败"];
        
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

-(void)initData{
    NSString *sendname = [self.info objectForKey:@"sendname"];
    
    
    NSString *title = [self.info objectForKey:@"title"];
    NSString *path = [self.info objectForKey:@"path"];
    NSString *content = [self.info objectForKey:@"content"];
    self.sendname.text = [NSString stringWithFormat:@"发布人:%@",sendname];
    
    if ([self.type isEqualToString:@"1"]) {
        NSString *notename = [self.info objectForKey:@"notename"];
        self.sendnodename.text = [NSString stringWithFormat:@"发布单位:%@",notename];
        NSNumber *addtime = [self.info objectForKey:@"addtime"];
        NSTimeInterval time = [addtime doubleValue] / 1000;
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
        NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *date = [df stringFromDate:confromTimesp];
        self.addtime.text = [NSString stringWithFormat:@"发布时间:%@",date];
    }else if([self.type isEqualToString:@"2"]){
        NSString *sendnodename = [self.info objectForKey:@"sendnodename"];
        self.sendnodename.text = [NSString stringWithFormat:@"发布单位:%@",sendnodename];
        NSString *addtime = [self.info objectForKey:@"addtime"];
        self.addtime.text = [NSString stringWithFormat:@"发布时间:%@",addtime];
    }
    
    
    self.titleLabel.text = title;
    self.contentLabel.text = content;
    self.contentLabel.numberOfLines = 0;
    [self.contentLabel sizeToFit];
    
    // 列寬
    CGFloat contentWidth = [UIScreen mainScreen].bounds.size.width;
    UIFont *font = [UIFont systemFontOfSize:16];
    
    if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        textSize = [content boundingRectWithSize:CGSizeMake(contentWidth-16, MAXFLOAT)
                                         options:options
                                      attributes:attributes
                                         context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        textSize = [content sizeWithFont:font
                       constrainedToSize:CGSizeMake(contentWidth-16, MAXFLOAT)
                           lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        
    }
    [self.contentLabel setFrame:CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, contentWidth-16, textSize.height)];
    
    NSString *imagePath = [NSString stringWithFormat:@"%@%@%@",[Utils getHostname],NOTICE_PATH,path];
    [self.img setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"defalut_pic"]];
    [self.img setHidden:NO];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
    [self.img addGestureRecognizer:tap];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSString *path = [self.info objectForKey:@"path"];
    if (path.length == 0) {
        self.heightLayoutConstraint.constant = 0;
        [self.myscrollview setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, textSize.height + 118-70 + 110)];
    }else{
        [self.myscrollview setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, textSize.height + 118 + 110)];
    }
    
    
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
    
    //    NSString *urlStr = [[self.photoItemArray[index] thumbnail_pic] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:imagePath];
}

@end
