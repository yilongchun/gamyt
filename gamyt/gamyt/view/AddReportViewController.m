//
//  AddReportViewController.m
//  gamyt
//
//  Created by yons on 15-3-12.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "AddReportViewController.h"
#import "ImageViewController.h"

@interface AddReportViewController (){
    UIImagePickerController *imagePicker1;//照相机
}

@end

@implementation AddReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteImage:)
                                                 name:@"deleteImage"
                                               object:nil];
    
    self.backimage.backgroundColor = [UIColor whiteColor];
    //设置layer
    CALayer *layer=[self.backimage layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框线的宽
    [layer setBorderWidth:1];
    //设置边框线的颜色
    [layer setBorderColor:[[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1] CGColor]];
    self.chosenImages = [NSMutableArray array];
    [self.choseBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length <= 200) {
        NSString *s = [NSString stringWithFormat:@"最多能输入%lu个字符",200 - textView.text.length];
        self.textnumberLabel.text = s;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    NSLog(@"上报");
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    if (self.content.text.length == 0) {
        [self showHint:@"请填写上报内容"];
        return;
    }
    
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i < self.chosenImages.count; i++) {
        UIImageView *imageview = [self.chosenImages objectAtIndex:i];
        [images addObject:imageview.image];
    }
    
    
    
    
    [self showHudInView:self.view hint:@"加载中"];
    NSString *str = [NSString stringWithFormat:@"%@%@",[Utils getHostname],@"/mobile/report/addReport"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.content.text forKey:@"content"];
    
    NSMutableURLRequest *request = [Utils postRequestWithParems:url postParams:parameters images:images];
    
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
            [self showHint:@"加载失败"];
        }else if([code intValue] == 4){
            [self hideHud];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:self];
        }else if([code intValue] == 0){
            [self hideHud];
            [self showHint:@"新增成功"];
            [self performSelector:@selector(back) withObject:self afterDelay:1.0f];
            
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self hideHud];
        [self showHint:@"连接失败"];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyReport" object:nil];
    }];
}

- (void)showcamera {
    if (imagePicker1 == nil) {
        imagePicker1 = [[UIImagePickerController alloc] init];
        imagePicker1.delegate = self;
        imagePicker1.allowsEditing = YES;
        imagePicker1.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker1.mediaTypes =  [[NSArray alloc] initWithObjects:@"public.image", nil];
    }
    [self presentViewController:imagePicker1 animated:YES completion:nil];
}

- (IBAction)chooseImage:(id)sender {
    
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
            [self performSelector:@selector(showcamera) withObject:nil afterDelay:0.3];
        }]];
        [actionsheet addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self chooseImage];
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
            [self performSelector:@selector(showcamera) withObject:nil afterDelay:0.3];
        }
            break;
        case 1://本地相簿
        {
            [self chooseImage];
        }
            break;
        default:
            break;
    }
}

-(void)chooseImage{
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    elcPicker.maximumImagesCount = 4 - self.chosenImages.count; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = NO; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //Supports image and movie types
    elcPicker.imagePickerDelegate = self;
    [[elcPicker navigationBar] setTintColor:[UIColor whiteColor]];
    [[elcPicker navigationBar] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    [self presentViewController:elcPicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    CGRect workingFrame = self.choseBtn.frame;
    workingFrame.origin.x = 15 + (self.chosenImages.count * (workingFrame.size.width + 5));
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
        UIImage  *image = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
        imageview.userInteractionEnabled = YES;
        //                [imageview setContentMode:UIViewContentModeScaleAspectFit];
        imageview.frame = workingFrame;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
        [imageview addGestureRecognizer:tap];
        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageLongPress:)];
        [imageview addGestureRecognizer:longpress];
        [self.view addSubview:imageview];
        workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width + 5;
        self.leftLayout.constant = workingFrame.origin.x;
        imageview.tag = self.chosenImages.count+1;
        [self.chosenImages addObject:imageview];
        
        if (self.chosenImages.count >= 4) {
            [self.choseBtn setHidden:YES];
        }else{
            [self.choseBtn setHidden:NO];
        }
    }
   
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    
    CGRect workingFrame = self.choseBtn.frame;
    workingFrame.origin.x = 15 + (self.chosenImages.count * (workingFrame.size.width + 5));
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
//                [images addObject:image];
                
                UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
                imageview.userInteractionEnabled = YES;
//                [imageview setContentMode:UIViewContentModeScaleAspectFit];
                imageview.frame = workingFrame;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
                [imageview addGestureRecognizer:tap];
                UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageLongPress:)];
                [imageview addGestureRecognizer:longpress];
                
                [self.view addSubview:imageview];
                workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width + 5;
                self.leftLayout.constant = workingFrame.origin.x;
                imageview.tag = self.chosenImages.count+1;
                [self.chosenImages addObject:imageview];
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        }  else {
            NSLog(@"Uknown asset type");
        }
    }
//    self.chosenImages = images;
    if (self.chosenImages.count >= 4) {
        [self.choseBtn setHidden:YES];
    }else{
        [self.choseBtn setHidden:NO];
    }
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageClick:(UITapGestureRecognizer *)recognizer
{
//    UIImageView *imageview = (UIImageView *)recognizer.view;
//    [self.chosenImages removeObject:imageview];
//    [imageview removeFromSuperview];
//    CGRect workingFrame = self.choseBtn.frame;
//    
//    for (int i = 0 ; i < self.chosenImages.count ; i++) {
//        workingFrame.origin.x = 16 + (i * (workingFrame.size.width + 5));
//        UIImageView *imageview = [self.chosenImages objectAtIndex:i];
//        imageview.frame = workingFrame;
//    }
//    
//    workingFrame.origin.x = 16 + (self.chosenImages.count * (workingFrame.size.width + 5));
//    self.leftLayout.constant = workingFrame.origin.x;
//    if (self.chosenImages.count >= 4) {
//        [self.choseBtn setHidden:YES];
//    }else{
//        [self.choseBtn setHidden:NO];
//    }
    NSLog(@"%ld",(long)recognizer.view.tag);
    
    ImageViewController *view = [[self storyboard] instantiateViewControllerWithIdentifier:@"ImageViewController"];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.chosenImages.count; i++) {
        UIImageView *imageview = [self.chosenImages objectAtIndex:i];
        UIImage *image = imageview.image;
        [arr addObject:image];
    }
    
    
    view.chosenImages = arr;
    view.current = [NSNumber numberWithLong:recognizer.view.tag-1];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self presentViewController:view animated:YES completion:nil];
    
}

- (void)imageLongPress:(UITapGestureRecognizer *)recognizer
{
    UIImageView *imageview = (UIImageView *)recognizer.view;
    [self.chosenImages removeObject:imageview];
    [imageview removeFromSuperview];
    CGRect workingFrame = self.choseBtn.frame;
    
    for (int i = 0 ; i < self.chosenImages.count ; i++) {
        workingFrame.origin.x = 15 + (i * (workingFrame.size.width + 5));
        UIImageView *imageview = [self.chosenImages objectAtIndex:i];
        imageview.frame = workingFrame;
        imageview.tag = i+1;
    }
    
    workingFrame.origin.x = 15 + (self.chosenImages.count * (workingFrame.size.width + 5));
    self.leftLayout.constant = workingFrame.origin.x;
    if (self.chosenImages.count >= 4) {
        [self.choseBtn setHidden:YES];
    }else{
        [self.choseBtn setHidden:NO];
    }
}

-(void)deleteImage:(NSNotification *)notification{
    NSDictionary *userinfo = [notification userInfo];
    NSNumber *index = [userinfo objectForKey:@"deleteImageIndex"];
    if ([index intValue] < self.chosenImages.count) {
        UIImageView *imageview = [self.chosenImages objectAtIndex:[index intValue]];
        [imageview removeFromSuperview];
        [self.chosenImages removeObjectAtIndex:[index intValue]];
        
        CGRect workingFrame = self.choseBtn.frame;
        for (int i = 0 ; i < self.chosenImages.count ; i++) {
            workingFrame.origin.x = 15 + (i * (workingFrame.size.width + 5));
            UIImageView *imageview = [self.chosenImages objectAtIndex:i];
            imageview.frame = workingFrame;
            imageview.tag = i+1;
        }
        workingFrame.origin.x = 15 + (self.chosenImages.count * (workingFrame.size.width + 5));
        self.leftLayout.constant = workingFrame.origin.x;
        if (self.chosenImages.count >= 4) {
            [self.choseBtn setHidden:YES];
        }else{
            [self.choseBtn setHidden:NO];
        }
    }
    
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
