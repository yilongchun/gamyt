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

//+ (NSString *)getImageHostname{
//    //从资源文件获取请求路径
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
//    NSMutableDictionary *infolist = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
//    NSString *hostname = [infolist objectForKey:@"HttpImageurl3"];
//    return hostname;
//}
//
//+ (NSString *)getVideoHostname{
//    //从资源文件获取请求路径
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
//    NSMutableDictionary *infolist = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
//    NSString *hostname = [infolist objectForKey:@"HttpVideourl3"];
//    return hostname;
//}
//
//+ (BOOL) isBlankString:(NSString *)string {
//    if (string == nil || string == NULL) {
//        return YES;
//    }
//    if ([string isKindOfClass:[NSNull class]]) {
//        return YES;
//    }
//    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
//        return YES;
//    }
//    return NO;
//}

@end
