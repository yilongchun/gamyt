//
//  UserinfoViewController.m
//  gamyt
//
//  Created by yons on 15-3-17.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "UserinfoViewController.h"
#import "SettingViewController.h"

@implementation UserinfoViewController{
    NSDictionary *users;
    NSDictionary *notes;
    BOOL imgFlag;
    NSString *bankcardString;//银行卡号
    NSString *tempBankcardString;//临时记录 银行卡号
    UIImagePickerController *imagePicker1;//照相机
    UIImagePickerController *imagePicker2;//照片选择
    
    NSString *phoneNum;
    NSString *bankString;
    NSString *bankaddressString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
//    self.navigationController.delegate = self;
    
    [self.phone addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.bank addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.bankcard addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.bankaddress addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    [self initData];
    
    self.saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(save)];
}

-(void)initData{
    imgFlag = NO;
    self.navigationItem.rightBarButtonItem = nil;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    users = [userdefaults objectForKey:@"users"];
    notes = [userdefaults objectForKey:@"notes"];
    
    NSString *picpath = [users objectForKey:@"picpath"];//头像
    NSString *username = [users objectForKey:@"name"];//姓名
    NSString *notename = [notes objectForKey:@"name"];//单位
    phoneNum = [users objectForKey:@"phone"];//电话
    NSString *idcard = [users objectForKey:@"idcard"];//身份证
    
    //积分
    //积分等级
    bankString = [users objectForKey:@"bank"];//开户银行
    NSString *bankcard = [users objectForKey:@"bankcard"];//银行卡号
    bankaddressString = [users objectForKey:@"bankaddress"];//汇款地址
    
    NSString *imagePath = [NSString stringWithFormat:@"%@%@%@",[Utils getHostname],IMAGE_PATH,picpath];
    [self.img setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"defalut_photo"]];
    self.img.layer.masksToBounds = YES;
    self.img.layer.cornerRadius = 35;
    self.username.text = username;
    self.unitname.text = notename;
    self.phone.text = phoneNum;
    self.idcard.text = idcard;
    self.bank.text = bankString;
    
    bankcardString = bankcard;
    tempBankcardString = bankcard;
    NSMutableString *bankcards = [NSMutableString string];
    if (bankcard.length > 4) {
        for (int i = 0; i < bankcard.length-4; i++) {
            [bankcards appendString:@"*"];
        }
        self.bankcard.text = [NSString stringWithFormat:@"%@%@",bankcards,[bankcard substringFromIndex:bankcard.length-4]];
    }
    
    self.bankaddress.text = bankaddressString;
    
    [self loadData];
    [self loadUserProperty];
}

//加载积分和积分等级
-(void)loadData{
    [self showHudInView:self.view hint:@"加载中"];
    NSString *str = [NSString stringWithFormat:@"%@%@?uid=%d",[Utils getHostname],@"/mobile/user/getUserBaseInfo",[[Utils getUserId] intValue]];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:30.0];
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
            NSDictionary *dic = [NSDictionary cleanNullForDic:[resultDict objectForKey:@"data"]];
            NSNumber *points = [dic objectForKey:@"points"];//积分
            NSNumber *pointslevel = [dic objectForKey:@"pointslevel"];//积分等级
            self.point.text = [NSString stringWithFormat:@"%d",[points intValue]];
            self.pointlevel.text = [NSString stringWithFormat:@"%d",[pointslevel intValue]];;
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self hideHud];
        [self showHint:@"连接失败"];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}
//加载人员属性
-(void)loadUserProperty{
    
    NSString *str = [NSString stringWithFormat:@"%@%@",[Utils getHostname],@"/mobile/user/getMemberProp"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30.0];
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
//            NSLog(@"%@",resultDict);
        }
        NSNumber *code = [resultDict objectForKey:@"code"];
        if ([code intValue] == 1) {
            [self hideHud];
            [self showHint:@"获取人员属性失败"];
        }else if([code intValue] == 4){
            [self hideHud];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:self];
        }else if([code intValue] == 0){
            [self hideHud];
            
            NSNumber *propid = [users objectForKey:@"propid"];//人员属性 访问接口
            NSArray *userPropertyArr = [resultDict objectForKey:@"data"];
            BOOL flag = NO;
            for (int i = 0; i < userPropertyArr.count; i++) {
                NSDictionary *dic = [NSDictionary cleanNullForDic:[userPropertyArr objectAtIndex:i]];
                NSNumber *proid = [dic objectForKey:@"id"];
                NSString *proname = [dic objectForKey:@"name"];
                if ([proid intValue] == [propid intValue]) {
                    self.property.text = proname;
                    flag = YES;
                    break;
                }
            }
            if (!flag) {
                self.property.text = @"未设置";
            }
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self hideHud];
        [self showHint:@"获取人员失败"];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

//修改头像
- (void)updateImgAction{
    if (CURRENT_SYSTEM_VERSION < 8.0) {
        UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
        [actionsheet showInView:self.view];
    }else{
        UIAlertController *actionsheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [actionsheet addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            //检查相机模式是否可用
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                NSLog(@"sorry, no camera or camera is unavailable.");
                return;
            }
            if (imagePicker1 == nil) {
                imagePicker1 = [[UIImagePickerController alloc] init];
                imagePicker1.delegate = self;
                imagePicker1.allowsEditing = YES;
                imagePicker1.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker1.mediaTypes =  [[NSArray alloc] initWithObjects:@"public.image", nil];
            }
            [self presentViewController:imagePicker1 animated:YES completion:nil];
        }]];
        [actionsheet addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (imagePicker2 == nil) {
                imagePicker2 = [[UIImagePickerController alloc] init];
                imagePicker2.delegate = self;
                imagePicker2.allowsEditing = YES;
                imagePicker2.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker2.mediaTypes =  [[NSArray alloc] initWithObjects:@"public.image", nil];
                [[imagePicker2 navigationBar] setTintColor:[UIColor whiteColor]];
                [[imagePicker2 navigationBar] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
            }
            [self presentViewController:imagePicker2 animated:YES completion:nil];
        }]];
        [actionsheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:actionsheet animated:YES completion:nil];
    }
    
}



#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://照相机
        {
            //检查相机模式是否可用
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                NSLog(@"sorry, no camera or camera is unavailable.");
                return;
            }
            if (imagePicker1 == nil) {
                imagePicker1 = [[UIImagePickerController alloc] init];
                imagePicker1.delegate = self;
                imagePicker1.allowsEditing = YES;
                imagePicker1.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker1.mediaTypes =  [[NSArray alloc] initWithObjects:@"public.image", nil];
            }
            [self presentViewController:imagePicker1 animated:YES completion:nil];
        }
            break;
        case 1://本地相簿
        {
            if (imagePicker2 == nil) {
                imagePicker2 = [[UIImagePickerController alloc] init];
                imagePicker2.delegate = self;
                imagePicker2.allowsEditing = YES;
                imagePicker2.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker2.mediaTypes =  [[NSArray alloc] initWithObjects:@"public.image", nil];
                [[imagePicker2 navigationBar] setTintColor:[UIColor whiteColor]];
                [[imagePicker2 navigationBar] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
            }
            [self presentViewController:imagePicker2 animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
        UIImage  *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self.img setImage:img];
        imgFlag = YES;
        self.navigationItem.rightBarButtonItem = self.saveBtn;
        
//        NSData *fildData = UIImageJPEGRepresentation(img, 0.5);//UIImagePNGRepresentation(img); //
        //照片
//        [self uploadImg:fildData];
        //        self.fileData = UIImageJPEGRepresentation(img, 1.0);
    }
    //视频
    //    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"kUTTypeMovie"]) {
    //        NSString *videoPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
    //        self.fileData = [NSData dataWithContentsOfFile:videoPath];
    //    }
    [picker dismissViewControllerAnimated:YES completion:^{
        [self hideHud];
        
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // bug fixes: UIIMagePickerController使用中偷换StatusBar颜色的问题
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType ==     UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
    //    if([viewController isKindOfClass:[SettingViewController class]]){
    //        NSLog(@"返回");
    //        return;
    //    }
}

//-(void)saveToLocal:(NSData *)fileData{
//    
//    //将文件保存到本地
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *documentsDirectory=[paths objectAtIndex:0];
//    NSString *savedImagePath=[documentsDirectory stringByAppendingPathComponent:@"mythead.png"];
//    BOOL saveFlag = [fileData writeToFile:savedImagePath atomically:YES];
//    
//    if (saveFlag) {
//        NSFileManager *fileMgr = [NSFileManager defaultManager];
//        NSError *err;
//        [fileMgr removeItemAtPath:savedImagePath error:&err];
//    }
//    
//    
//}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self updateImgAction];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 3) {
        self.bankcard.text = @"";
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    switch (textField.tag) {
        case 1:
            if (![textField.text isEqualToString:phoneNum]) {
                self.navigationItem.rightBarButtonItem = self.saveBtn;
            }
            break;
        case 2:
            if (![textField.text isEqualToString:bankString]) {
                self.navigationItem.rightBarButtonItem = self.saveBtn;
            }
            break;
        case 3:
            if (textField.text.length == 0) {
                if (bankaddressString.length > 4) {
                    NSMutableString *bankcards = [NSMutableString string];
                    for (int i = 0; i < bankcardString.length-4; i++) {
                        [bankcards appendString:@"*"];
                    }
                    self.bankcard.text = [NSString stringWithFormat:@"%@%@",bankcards,[bankcardString substringFromIndex:bankcardString.length-4]];
                }
                tempBankcardString = bankcardString;
            }else{
                tempBankcardString = textField.text;
                self.navigationItem.rightBarButtonItem = self.saveBtn;
            }
            break;
        case 4:
            if (![textField.text isEqualToString:bankaddressString]) {
                self.navigationItem.rightBarButtonItem = self.saveBtn;
            }
            break;
        default:
            break;
    }
}
- (void)textFieldDidChange:(UITextField *)textField{
    switch (textField.tag) {
        case 1:
            if (textField.text.length > 11) {
                textField.text = [textField.text substringToIndex:11];
            }
            break;
        case 2:
            if (textField.text.length > 30) {
                textField.text = [textField.text substringToIndex:30];
            }
            break;
        case 3:
            if (textField.text.length > 19) {
                textField.text = [textField.text substringToIndex:19];
            }
            break;
        case 4:
            if (textField.text.length > 30) {
                textField.text = [textField.text substringToIndex:30];
            }
            break;
        default:
            break;
    }
}

- (void)save {
    if (self.phone.text.length != 11) {
        [self showHint:@"手机号码必须是11位"];
        return;
    }
    if (self.bankcard.text.length < 16 || self.bankcard.text.length > 19) {
        [self showHint:@"银行卡号应在16到19位之间"];
        return;
    }

    [self showHudInView:self.view hint:@"加载中"];
    NSString *str = [NSString stringWithFormat:@"%@%@",[Utils getHostname],@"/mobile/user/updateUserBaseInfoOfMulti"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.bank.text forKey:@"bank"];
    [parameters setObject:self.bankaddress.text forKey:@"bankaddress"];
    [parameters setObject:tempBankcardString forKey:@"bankcard"];
    [parameters setObject:self.phone.text forKey:@"phone"];
    [parameters setObject:self.phone.text forKey:@"username"];

    
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:30];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //要上传的图片
    UIImage *image=self.img.image;
    //得到图片的data
    NSData* data = UIImagePNGRepresentation(image);
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    
    //添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //添加字段名称，换2行
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"param"];
    NSString *post=[NSString jsonStringWithDictionary:parameters];
    //添加字段的值
    [body appendFormat:@"%@\r\n",post];
    
    if (imgFlag) {
        ////添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //声明pic字段，文件名为boris.png
        [body appendFormat:@"Content-Disposition: form-data; name=\"upfile\"; filename=\"mythead.png\"\r\n"];
        //声明上传文件的格式
        [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    }
    
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    if (imgFlag) {
        //将image的data加入
        [myRequestData appendData:data];
    }
    
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [request setValue:[numberFormatter stringFromNumber:[Utils getUserId]] forHTTPHeaderField:USERID];
    [request setValue:[Utils getToken] forHTTPHeaderField:TOKEN];
    //http method
    [request setHTTPMethod:@"POST"];
    
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
            [self showHint:@"修改成功"];
            NSDictionary *user = [NSDictionary cleanNullForDic:[resultDict objectForKey:@"data"]];
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:user forKey:@"users"];
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
@end
