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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    
    
    
}



-(void)viewDidLayoutSubviews{
    if (!flag) {
//        for (int i = 0 ; i < self.chosenImages.count; i++) {
//            [[self.myscrollview.subviews objectAtIndex:i] setFrame:CGRectMake(0 + (self.myscrollview.frame.size.width * i), 0, self.myscrollview.frame.size.width, self.myscrollview.frame.size.height)];
//        }
//        [self.myscrollview setContentSize:CGSizeMake(self.myscrollview.frame.size.width * self.chosenImages.count, self.myscrollview.frame.size.height)];
//        [self.myscrollview scrollRectToVisible:CGRectMake(0 + (self.myscrollview.frame.size.width * [self.current intValue]), 0, self.myscrollview.frame.size.width, self.myscrollview.frame.size.height) animated:NO];
        
        CGRect rect = self.view.bounds;
//        rect.size.width += SDPhotoBrowserImageViewMargin * 2;
        
        self.myscrollview.bounds = rect;
        
        CGFloat y = SDPhotoBrowserImageViewMargin;
        CGFloat w = self.myscrollview.frame.size.width - SDPhotoBrowserImageViewMargin * 2;
        CGFloat h = self.myscrollview.frame.size.height - SDPhotoBrowserImageViewMargin * 2;
        
        self.myscrollview.showsHorizontalScrollIndicator = NO;
        self.myscrollview.showsVerticalScrollIndicator = NO;
        
        [self.myscrollview.subviews enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL *stop) {
            CGFloat x = SDPhotoBrowserImageViewMargin + idx * (SDPhotoBrowserImageViewMargin * 2 + w);
            obj.frame = CGRectMake(x, y, w, h);
        }];
        
        self.myscrollview.contentSize = CGSizeMake(self.myscrollview.subviews.count * self.myscrollview.frame.size.width, 0);
        self.myscrollview.contentOffset = CGPointMake([self.current intValue] * self.myscrollview.frame.size.width, 0);//偏移
        self.myscrollview.pagingEnabled = YES;
        flag = YES;
    }
    
}

- (IBAction)cancel:(id)sender {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    
    self.pageLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.chosenImages.count];
    
}
@end
