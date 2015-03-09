//
//  Util.m
//  hmjz
//
//  Created by yons on 14-10-23.
//  Copyright (c) 2014年 yons. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSNumber *)getUserId{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *userid = [ud objectForKey:@"userid"];
    return userid;
}

+ (NSString *)getToken{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *token = [ud objectForKey:@"token"];
    return token;
}

+ (NSString *)getHostname{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSMutableDictionary *infolist = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *hostname = [infolist objectForKey:@"httpurl"];
    return hostname;
}

@end
