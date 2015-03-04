//
//  MobileLoginParam.h
//  gamyt
//
//  Created by yons on 15-3-4.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MobileLoginParam : NSObject

@property(weak, nonatomic) NSString *username;
@property(nonatomic) NSInteger devicetype;
@property(weak, nonatomic) NSString *pwd;
@property(weak, nonatomic) NSString *deviceid;

@end
