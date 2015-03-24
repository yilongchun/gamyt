//
//  ImageViewController.m
//  gamyt
//
//  Created by yons on 15-3-19.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "ImageViewController.h"
#define SDPhotoBrowserImageViewMargin 10

@implementation ImageViewController{
    BOOL flag;
    int selectIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
//    CGFloat dx = 50;
//    CGFloat itemWidth = self.myscrollview.bounds.size.width + dx * 2.0;
//    for (int i = 0 ; i < self.chosenImages.count; i++) {
//        CGRect frame = self.myscrollview.bounds;
//        frame.origin.x = itemWidth * i;
//        frame.origin.y = 0.0;
//        frame.size.width = itemWidth;
//        
//        UIImage *image = [self.chosenImages objectAtIndex:i];
//        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectZero];
//        imageview.image = image;
//        [imageview setContentMode:UIViewContentModeScaleAspectFit];
//        imageview.frame = CGRectInset(frame, dx, 0);
//        [self.myscrollview addSubview:imageview];
//    }
    
    
    
    [self initData];
}

-(void)initData{
    for (int i = 0 ; i < self.chosenImages.count; i++) {
        UIImage *image = [self.chosenImages objectAtIndex:i];
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageview.image = image;
        [imageview setContentMode:UIViewContentModeScaleAspectFit];
        [self.myscrollview addSubview:imageview];
    }
    
    if (self.chosenImages.count == 1) {
        [self.pageLabel setHidden:YES];
    }
    flag = NO;
    
    self.pageLabel.text = [NSString stringWithFormat:@"%d/%ld", [self.current intValue]+1, (long)self.chosenImages.count];
}



-(void)viewDidLayoutSubviews{
//    if (!flag) {
//        for (int i = 0 ; i < self.chosenImages.count; i++) {
//            [[self.myscrollview.subviews objectAtIndex:i] setFrame:CGRectMake(0 + (self.myscrollview.frame.size.width * i), 0, self.myscrollview.frame.size.width, self.myscrollview.frame.size.height)];
//        }
//        [self.myscrollview setContentSize:CGSizeMake(self.myscrollview.frame.size.width * self.chosenImages.count, self.myscrollview.frame.size.height)];
//        [self.myscrollview scrollRectToVisible:CGRectMake(0 + (self.myscrollview.frame.size.width * [self.current intValue]), 0, self.myscrollview.frame.size.width, self.myscrollview.frame.size.height) animated:NO];
        
        CGRect rect = self.view.bounds;
//        rect.size.width += SDPhotoBrowserImageViewMargin * 2;
        
        self.myscrollview.bounds = rect;
        
        CGFloat y = rect.origin.y;NSLog(@"%f",y);
        CGFloat w = self.myscrollview.frame.size.width - SDPhotoBrowserImageViewMargin * 2;
        CGFloat h = self.myscrollview.frame.size.height - SDPhotoBrowserImageViewMargin * 2;
        
        self.myscrollview.showsHorizontalScrollIndicator = NO;
        self.myscrollview.showsVerticalScrollIndicator = NO;
        self.myscrollview.contentSize = CGSizeMake(self.myscrollview.subviews.count * self.myscrollview.frame.size.width, 0);
        self.myscrollview.contentOffset = CGPointMake([self.current intValue] * self.myscrollview.frame.size.width, 0);//偏移
        self.myscrollview.pagingEnabled = YES;
        [self.myscrollview.subviews enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL *stop) {
            CGFloat x = SDPhotoBrowserImageViewMargin + idx * (SDPhotoBrowserImageViewMargin * 2 + w);
            [obj setContentMode:UIViewContentModeScaleAspectFit];
            obj.frame = CGRectMake(x, y, w, h);NSLog(@"%f",y);
        }];
        
        
//        flag = YES;
//    }
    
}

- (IBAction)cancel:(id)sender {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteImg:(id)sender {
    if (selectIndex < self.myscrollview.subviews.count) {
        [self.myscrollview.subviews[selectIndex] removeFromSuperview];
        [self.chosenImages removeObjectAtIndex:selectIndex];
        NSMutableDictionary *userinfo = [NSMutableDictionary dictionary];
        [userinfo setObject:[NSNumber numberWithInt:selectIndex] forKey:@"deleteImageIndex"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteImage" object:nil userInfo:userinfo];

        
        if (self.myscrollview.subviews.count > 0) {
            CGRect rect = self.view.bounds;
            self.myscrollview.bounds = rect;
            CGFloat y = SDPhotoBrowserImageViewMargin;
            CGFloat w = self.myscrollview.frame.size.width - SDPhotoBrowserImageViewMargin * 2;
            CGFloat h = self.myscrollview.frame.size.height - SDPhotoBrowserImageViewMargin * 2;
            [self.myscrollview.subviews enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL *stop) {
                CGFloat x = SDPhotoBrowserImageViewMargin + idx * (SDPhotoBrowserImageViewMargin * 2 + w);
                obj.frame = CGRectMake(x, y, w, h);
                
                [obj setContentMode:UIViewContentModeScaleAspectFit];
            }];
            self.myscrollview.contentSize = CGSizeMake(self.myscrollview.subviews.count * self.myscrollview.frame.size.width, 0);
            if (selectIndex == self.myscrollview.subviews.count) {
                selectIndex = selectIndex - 1;
                self.myscrollview.contentOffset = CGPointMake(selectIndex * self.myscrollview.frame.size.width, 0);//偏移
                
                self.pageLabel.text = [NSString stringWithFormat:@"%d/%ld", selectIndex+1, (long)self.chosenImages.count];
            }else{
                self.myscrollview.contentOffset = CGPointMake(selectIndex * self.myscrollview.frame.size.width, 0);//偏移
                
                self.pageLabel.text = [NSString stringWithFormat:@"%d/%ld", selectIndex+1, (long)self.chosenImages.count];
            }
            
            
        }else{
            [self cancel:nil];
        }
    }
}



#pragma mark - scrollview代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + self.myscrollview.bounds.size.width * 0.5) / self.myscrollview.bounds.size.width;
    // 有过缩放的图片在拖动100后清除缩放
//    CGFloat margin = 100.0;
//    CGFloat x = scrollView.contentOffset.x;
//    if ((x - index * self.bounds.size.width) > margin || (x - index * self.bounds.size.width) < - margin) {
//        if (index < _scrollView.subviews.count) {
//            SDBrowserImageView *imageView = _scrollView.subviews[index];
//            if (imageView.isScaled) {
//                [UIView animateWithDuration:0.5 animations:^{
//                    imageView.transform = CGAffineTransformIdentity;
//                } completion:^(BOOL finished) {
//                    [imageView eliminateScale];
//                }];
//            }
//        }
//        
//    }
    
    selectIndex = index;
    self.pageLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.chosenImages.count];
    
}
@end
