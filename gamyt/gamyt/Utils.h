//
//  Util.h
//  hmjz
//  工具类
//  Created by yons on 14-10-23.
//  Copyright (c) 2014年 yons. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Utils : NSObject
//获取userid
+ (NSNumber *)getUserId;
//获取token
+ (NSString *)getToken;
//获取服务器接口路径
+ (NSString *)getHostname;
//返回消息类型
+ (NSString *)getOptTypeName:(NSNumber *)opttype;
//上传多图片
+ (NSMutableURLRequest *)postRequestWithParems:(NSURL *)url postParams:(NSMutableDictionary *)postParams images: (NSArray *)images;

@end
