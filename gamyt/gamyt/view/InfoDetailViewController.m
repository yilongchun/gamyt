//
//  InfoDetailViewController.m
//  gamyt
//
//  Created by yons on 15-3-10.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "InfoDetailViewController.h"
#import "InfoDetailStatusViewController.h"
#import "InfoToUpViewController.h"
#import "UIButton+WebCache.h"

@implementation InfoDetailViewController{
    NSMutableArray *btns;
    NSString *infoTitle;
    NSNumber *newsid;
    
    NSMutableArray *shenyueDataSource;
    NSMutableArray *selectedArr;
    
    UITableView *alertTableView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    alertTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 50, 270-20, 173) style:UITableViewStylePlain];
    alertTableView.backgroundColor = [UIColor clearColor];
    alertTableView.dataSource = self;
    alertTableView.delegate = self;
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [alertTableView setTableFooterView:v];
    if ([alertTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [alertTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([alertTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [alertTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData)
                                                 name:@"refreshInfoDetail"
                                               object:nil];
    
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"toread_record_icon_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(toInfoDetailStatus)];
    self.navigationItem.rightBarButtonItem = rightitem;
    
    self.sendpic.layer.masksToBounds = YES;
    self.sendpic.layer.cornerRadius = 40;
   
    selectedArr = [NSMutableArray array];
    if (self.info) {
        [self initData];
    }else if(self.reportid){
        [self loadData];
    }
    
    
}
//获取数据
-(void)loadData{
    [self showHudInView:self.view hint:@"加载中"];
    NSString *str = [NSString stringWithFormat:@"%@%@",[Utils getHostname],@"/mobile/report/getReportDetail"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
//    [request setTimeoutInterval:30.0];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [request setValue:[numberFormatter stringFromNumber:[Utils getUserId]] forHTTPHeaderField:USERID];
    [request setValue:[Utils getToken] forHTTPHeaderField:TOKEN];
    
    //JSON格式
//    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"content-type"];
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters setObject:[NSNumber numberWithInt:0] forKey:@"ismyreport"];
//    [parameters setObject:[self.info objectForKey:@"id"] forKey:@"reportid"];
//    NSString *post=[NSString jsonStringWithDictionary:parameters];
//    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    [request setHTTPBody:postData];
    //非JSON格式
    NSString *param = [NSString stringWithFormat:@"reportid=%d&ismyreport=0",[self.reportid intValue]];
    [request setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
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
            
            NSDictionary *dic = [resultDict objectForKey:@"data"];
            self.info = [NSDictionary cleanNullForDic:dic];
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
//设置数据
-(void)initData{
    NSString *sendname = [self.info objectForKey:@"sendname"];//姓名
    NSString *notename = [self.info objectForKey:@"notename"];//单位
    NSNumber *opttype = [self.info objectForKey:@"opttype"];//类型
    NSString *sendpic = [self.info objectForKey:@"sendpic"];//照片
    NSString *content = [self.info objectForKey:@"content"];//内容
    //    content = [NSString stringWithFormat:@"%@%@%@",content,content,content];
    NSString *addtime = [self.info objectForKey:@"addtime"];//时间
    infoTitle = [self.info objectForKey:@"title"];//标题
    newsid = [self.info objectForKey:@"newsid"];
    self.reportid = [self.info objectForKey:@"id"];
    
    
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
//设置按钮
-(void)initButtons{
    [self.btn1 removeFromSuperview];
    [self.btn2 removeFromSuperview];
    [self.btn3 removeFromSuperview];
    [self.btn4 removeFromSuperview];
    
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
        {
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
//布局
-(void)setLayout{
    NSString *path = [self.info objectForKey:@"path"];//照片路径
    if (path.length == 0) {
        self.contentTopLayout.constant = 0;
    }else{
        CGFloat width = [UIScreen mainScreen].bounds.size.width-10-10-5-5-5;
        self.contentTopLayout.constant = width/4;
    }
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width-10-10-(5*(btns.count-1)))/btns.count;
    
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

-(void)toInfoDetailStatus{
    InfoDetailStatusViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"InfoDetailStatusViewController"];
    vc.newsid = newsid;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)action1{
    NSLog(@"录用");
    
    NSString *title = @"信息录用";
    NSString *message = @"信息标题:(最多20字)";
    NSString *placeholder = @"请输入标题";
    
    if ([[UIDevice currentDevice] systemVersion].floatValue < 8.0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *tf=[alert textFieldAtIndex:0];
        if (infoTitle) {
            tf.text = infoTitle;
        }
        [tf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        tf.tag = 1;
        tf.delegate = self;
        tf.placeholder = placeholder;
        alert.tag = 1;
        [alert show];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = placeholder;
            textField.delegate = self;
            textField.tag = 1;
            [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            if (infoTitle) {
                textField.text = infoTitle;
            }
        }];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            UITextField *tf=[[alert textFields] objectAtIndex:0];
            [self hireReport:tf.text];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//录用
-(void)hireReport:(NSString *)title{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    if (title && title.length > 0) {
        [self showHudInView:self.view hint:@"加载中"];
        
        NSString *str = [NSString stringWithFormat:@"%@%@",[Utils getHostname],@"/mobile/report/hireReport"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setTimeoutInterval:30.0];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        [request setValue:[numberFormatter stringFromNumber:[Utils getUserId]] forHTTPHeaderField:USERID];
        [request setValue:[Utils getToken] forHTTPHeaderField:TOKEN];
        
        //JSON格式
        //        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"content-type"];
        //        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        //        [parameters setObject:title forKey:@"title"];
        //        [parameters setObject:newsid forKey:@"newid"];
        //        [parameters setObject:reportid forKey:@"reportid"];
        //        NSString *post=[NSString jsonStringWithDictionary:parameters];
        //        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        //        [request setHTTPBody:postData];
        //非JSON格式
        NSString *param = [NSString stringWithFormat:@"newsid=%d&reportid=%d&title=%@",[newsid intValue],[self.reportid intValue],title];
        [request setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            
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
                [self showHint:@"录用成功"];
                [self loadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshInfo" object:self];
            }
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"发生错误！%@",error);
            [self hideHud];
            [self showHint:@"连接失败"];
        }];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperation:operation];
    }else{
        [self showHint:@"请输入标题"];
    }
}

-(void)action2{
    NSLog(@"上报");
    
    InfoToUpViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"InfoToUpViewController"];
    vc.info = self.info;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)action3{
    NSLog(@"归档");
    
    NSString *title = @"归档上报";
    NSString *message = @"您确定要归档这条上报信息吗?";
    if ([[UIDevice currentDevice] systemVersion].floatValue < 8.0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 3;
        [alert show];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSLog(@"确定");
            [self archiveReport];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//归档
-(void)archiveReport{
    [self showHudInView:self.view hint:@"加载中"];
    NSString *str = [NSString stringWithFormat:@"%@%@",[Utils getHostname],@"/mobile/report/archiveReport"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30.0];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [request setValue:[numberFormatter stringFromNumber:[Utils getUserId]] forHTTPHeaderField:USERID];
    [request setValue:[Utils getToken] forHTTPHeaderField:TOKEN];
    
    //JSON格式
    //        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"content-type"];
    //        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //        [parameters setObject:title forKey:@"title"];
    //        [parameters setObject:newsid forKey:@"newid"];
    //        [parameters setObject:reportid forKey:@"reportid"];
    //        NSString *post=[NSString jsonStringWithDictionary:parameters];
    //        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //        [request setHTTPBody:postData];
    //非JSON格式
    NSString *param = [NSString stringWithFormat:@"newsid=%d&reportid=%d",[newsid intValue],[self.reportid intValue]];
    [request setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        
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
            [self showHint:@"归档成功"];
            [self loadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshInfo" object:self];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self hideHud];
        [self showHint:@"连接失败"];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

-(void)action4{
    NSLog(@"报审");
    
    if (shenyueDataSource == nil) {
        [self showHudInView:alertTableView hint:@"加载中"];
        NSString *str = [NSString stringWithFormat:@"%@%@",[Utils getHostname],@"/mobile/user/getTasters"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        //    [request setTimeoutInterval:30.0];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        [request setValue:[numberFormatter stringFromNumber:[Utils getUserId]] forHTTPHeaderField:USERID];
        [request setValue:[Utils getToken] forHTTPHeaderField:TOKEN];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            
            NSDictionary *resultDict = [NSDictionary cleanNullForDic:dict];
            if (resultDict == nil) {
                NSLog(@"json parse failed \r\n");
            }else{
                NSLog(@"%@",resultDict);
            }
            NSNumber *code = [resultDict objectForKey:@"code"];
            if ([code intValue] == 1) {
                [self hideHud];
                [self showHint:@"获取审阅员失败"];
            }else if([code intValue] == 4){
                [self hideHud];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:self];
            }else if([code intValue] == 0){
                [self hideHud];
                [self chooseShenYueYuan];
                NSArray *array = [resultDict objectForKey:@"data"];
                shenyueDataSource = [NSMutableArray arrayWithArray:array];
                [alertTableView reloadData];
            }
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"发生错误！%@",error);
            [self hideHud];
            [self showHint:@"连接失败"];
        }];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperation:operation];
    }else{
        [self chooseShenYueYuan];
    }
    
}

//报审
-(void)levelCheck{
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0; i < selectedArr.count; i++) {
        NSIndexPath *indexpath = [selectedArr objectAtIndex:i];
        NSDictionary *dic = [shenyueDataSource objectAtIndex:indexpath.row];
        NSNumber *userid = [dic objectForKey:@"key"];
        [list addObject:userid];
    }
    
    if (list.count == 0) {
        [self showHint:@"至少选择一个审阅员"];
        return;
    }
    
    [self showHudInView:self.view hint:@"加载中"];
    NSString *str = [NSString stringWithFormat:@"%@%@",[Utils getHostname],@"/mobile/report/levelCheckReport"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30.0];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [request setValue:[numberFormatter stringFromNumber:[Utils getUserId]] forHTTPHeaderField:USERID];
    [request setValue:[Utils getToken] forHTTPHeaderField:TOKEN];
    
    //JSON格式
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"content-type"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:newsid forKey:@"newsid"];
    [parameters setObject:list forKey:@"tasterlist"];
    NSString *post=[NSString jsonStringWithDictionary:parameters];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [request setHTTPBody:postData];
    //非JSON格式
    //        NSString *param = [NSString stringWithFormat:@"newsid=%d&reportid=%d&title=%@",[newsid intValue],[reportid intValue],title];
    //        [request setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        
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
            [self showHint:@"报审成功"];
            [self loadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshInfo" object:self];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self hideHud];
        [self showHint:@"连接失败"];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}


//选择审阅员
-(void)chooseShenYueYuan{
    [selectedArr removeAllObjects];
    [alertTableView reloadData];
    if (CURRENT_SYSTEM_VERSION < 8.0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择您需要报审的审阅员!" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 4;
        [alert setValue:alertTableView forKey:@"accessoryView"];
//        [alert addSubview:alertTableView];
        [alert show];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择您需要报审的审阅员!" message:@"\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
        [alert.view addSubview:alertTableView];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self levelCheck];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [shenyueDataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    NSDictionary *dic = [NSDictionary cleanNullForDic:[shenyueDataSource objectAtIndex:indexPath.row]];
    NSString *shenyuename = [dic objectForKey:@"value"];
    cell.textLabel.text = shenyuename;
    if ([selectedArr indexOfObject:indexPath] != NSNotFound) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [selectedArr addObject:indexPath];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        [selectedArr removeObject:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {//录用
        if (buttonIndex == 1) {//确定
            UITextField *tf=[alertView textFieldAtIndex:0];
            [self hireReport:tf.text];
        }
    }else if (alertView.tag == 3) {//归档
        if (buttonIndex == 1) {//确定
            [self archiveReport];
            NSLog(@"确定");
        }
    }else if (alertView.tag == 4) {//报审
        if (buttonIndex == 1) {//确定
            [self levelCheck];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField{
    if (textField.tag == 1) {
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
        }
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
