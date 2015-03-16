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
    NSString *hostname = [infolist objectForKey:@"httpurl2"];
    return hostname;
}

+ (NSString *)getOptTypeName:(NSNumber *)opttype{
    NSString *opttypename;
    switch ([opttype intValue]) {
        case -1:
            opttypename = @"未处理";
            break;
        case 0:
            opttypename = @"已签阅";
            break;
        case 1:
            opttypename = @"已归档";
            break;
        case 2:
            opttypename = @"已分发";
            break;
        case 3:
            opttypename = @"已上报";
            break;
        case 4:
            opttypename = @"转审阅";
            break;
        case 5:
        case 6:
            opttypename = @"已录用";
            break;
        default:
            opttypename = @"";
            break;
    }
    return opttypename;
}

@end
