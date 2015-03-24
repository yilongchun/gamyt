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
    UIPickerView *typepicker;
    NSMutableArray *typeArr;
    NSInteger selectRow;
    NSNumber *reportType;
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
    
    NSString *content = [self.info objectForKey:@"content"];//内容
    self.content.text = content;
    
    NSString *s = [NSString stringWithFormat:@"最多能输入%lu个字符",200 - self.content.text.length];
    self.textnumberLabel.text = s;
    
    [self.img1 setHidden:YES];
    [self.img2 setHidden:YES];
    [self.img3 setHidden:YES];
    [self.img4 setHidden:YES];
    NSString *path = [self.info objectForKey:@"path"];//照片路径
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
    
    
    //设置layer
    CALayer *layer=[self.backimage layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框线的宽
    [layer setBorderWidth:1];
    //设置边框线的颜色
    [layer setBorderColor:[BORDER_COLOR CGColor]];
    
    
    typepicker = [[UIPickerView alloc] initWithFrame:CGRectMake(12, 32, self.view.frame.size.width-40, 216)];
    typepicker.dataSource = self;
    typepicker.delegate = self;
    selectRow = 0;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        NSString *path = [self.info objectForKey:@"path"];//照片路径
        if (path.length == 0) {
            self.imageHeightLayout.constant = 0;
        }else{
        }
    }
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        NSString *path = [self.info objectForKey:@"path"];//照片路径
        if (path.length == 0) {
            self.imageHeightLayout.constant = 0;
        }else{
        }
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancel:(id)sender{
    
    NSString *content = [self.info objectForKey:@"content"];//内容
    if ([self.content.text isEqualToString:content]) {
        [self cancelAndBack];
    }else{
        NSString *title = @"确定退出?";
        NSString *message = @"离开后,您操作后的信息将不再保存!";
        if ([[UIDevice currentDevice] systemVersion].floatValue < 8.0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 1;
            [alert show];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [self cancelAndBack];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (IBAction)save:(id)sender {
    if ([self.infoType.text isEqualToString:@"信息类别"]) {
        [self showHint:@"请选择类别"];
        return;
    }
    
    NSNumber *newsid = [self.info objectForKey:@"newsid"];
    NSNumber *reportid = [self.info objectForKey:@"id"];
    NSString *content = [self.info objectForKey:@"content"];//内容
    BOOL contentChanged;
    if ([self.content.text isEqualToString:content]) {
        contentChanged = NO;
    }else{
        contentChanged = YES;
    }
    
    [self showHudInView:self.view hint:@"加载中"];
    NSString *str = [NSString stringWithFormat:@"%@%@",[Utils getHostname],@"/mobile/report/upReport"];
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
    [parameters setObject:self.content.text forKey:@"content"];
    [parameters setObject:[NSNumber numberWithBool:contentChanged] forKey:@"contentChanged"];
    [parameters setValue:newsid forKey:@"newsid"];
    [parameters setValue:reportid forKey:@"reprotid"];
    [parameters setValue:reportType forKey:@"type"];
    NSString *post=[NSString jsonStringWithDictionary:parameters];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [request setHTTPBody:postData];
    //非JSON格式
//    NSString *param = [NSString stringWithFormat:@"reportid=%d&ismyreport=0",[reportid intValue]];
//    [request setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
    
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
            [self showHint:@"上报成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshInfoDetail" object:self];//刷新详情
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshInfo" object:self];//刷新列表
            [self performSelector:@selector(cancelAndBack) withObject:nil afterDelay:1.0];
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self hideHud];
        [self showHint:@"连接失败"];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

-(void)cancelAndBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {//确定
            [self cancelAndBack];
        }
    }
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length <= 200) {
        NSString *s = [NSString stringWithFormat:@"最多能输入%lu个字符",200 - textView.text.length];
        self.textnumberLabel.text = s;//提醒字数
    }else{
        textView.text = [textView.text substringToIndex:200];
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

//获取类别
-(void)loadType{
    [self showHudInView:typepicker hint:@"加载中"];
    NSString *str = [NSString stringWithFormat:@"%@%@",[Utils getHostname],@"/mobile/report/getAllSort"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30.0];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [request setValue:[numberFormatter stringFromNumber:[Utils getUserId]] forHTTPHeaderField:USERID];
    [request setValue:[Utils getToken] forHTTPHeaderField:TOKEN];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        ;
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
            [self showHintInCenter:@"加载失败"];
        }else if([code intValue] == 4){
            [self hideHud];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:self];
        }else if([code intValue] == 0){
            [self hideHud];
            NSArray *data = [resultDict objectForKey:@"data"];
            if (data != nil && ![data isKindOfClass:[NSString class]]) {
                typeArr = [NSMutableArray arrayWithArray:data];
                [typepicker reloadAllComponents];
                
            }
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self hideHud];
        [self showHintInCenter:@"连接失败"];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

- (IBAction)chooseType:(id)sender {
    if (typeArr == nil) {
        [self loadType];
    }
    [self alert];
}

-(void)alert{
    if (CURRENT_SYSTEM_VERSION < 8.0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择类别\n\n\n\n\n\n\n\n\n\n\n\n"
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:@"确定"
                                                        otherButtonTitles:nil, nil];
        actionSheet.tag = 1;
        [typepicker setFrame:CGRectMake(20, 32, self.view.frame.size.width-40, 210)];
        [actionSheet addSubview:typepicker];
        [actionSheet showInView:self.view];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择类别" message:@"\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
        [alert.view addSubview:typepicker];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleCancel
                                                handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction *action) {
                                                    [self confirmType];
                                                }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
//确定类型
-(void)confirmType{
    NSDictionary *type = [typeArr objectAtIndex:selectRow];
    reportType = [type objectForKey:@"id"];
    NSString *name = [type objectForKey:@"name"];
    self.infoType.text = name;
    NSMutableParagraphStyle *paragraphStyle = [[ NSMutableParagraphStyle alloc ] init ];
    [paragraphStyle setFirstLineHeadIndent :10];
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:self.infoType.text attributes:@{ NSParagraphStyleAttributeName : paragraphStyle}];
    self.infoType.attributedText = attrText;
    NSLog(@"%d",[reportType intValue]);
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [typeArr count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary *type = [typeArr objectAtIndex:row];
    NSString *name = [type objectForKey:@"name"];
    return name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    selectRow = row;
    NSDictionary *type = [typeArr objectAtIndex:selectRow];
    NSString *name = [type objectForKey:@"name"];
    self.infoType.text = name;
    NSMutableParagraphStyle *paragraphStyle = [[ NSMutableParagraphStyle alloc ] init ];
    [paragraphStyle setFirstLineHeadIndent :10 ];
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:self.infoType.text attributes:@{ NSParagraphStyleAttributeName : paragraphStyle}];
    self.infoType.attributedText = attrText;
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
