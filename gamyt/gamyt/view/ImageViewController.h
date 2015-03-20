//
//  ImageViewController.h
//  gamyt
//
//  Created by yons on 15-3-19.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *myscrollview;
@property (nonatomic, strong) NSMutableArray *chosenImages;
@property (nonatomic, strong) NSNumber *current;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
- (IBAction)cancel:(id)sender;
@end
