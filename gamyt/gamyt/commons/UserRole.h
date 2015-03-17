//
//  UserRole.h
//  gamyt
//
//  Created by yons on 15-3-6.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USERID @"uid"
#define TOKEN @"tk"
#define PAGE_COUNT 10

#define IMAGE_PATH @"/files/users/"
#define REPORT_PATH @"/files/report"
#define NOTICE_PATH @"/files/notice/"

#define DEFAULT_BLUE_COLOR [UIColor colorWithRed:37/255.0 green:134/255.0 blue:216/255.0 alpha:1]
#define BORDER_COLOR [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]
#define BACKGROUND_COLOR [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1]

#define GENERAL 0 // 普通会员
#define TASTER 1 // 审阅会员

/**管理员*/
#define MANAGER 2 // 管理员

/** 超级管理员 */
#define SMANAGER 3// 超级管理员

/** 县级管理员 */
#define COUNTY_MANAGER 21// 县级管理员

/** 市级管理员 */
#define CITY_MANAGER 22// 市级管理员

/** 省级管理员 */
#define SHENG_MANAGER 23// 省级管理员

// /一个单位审阅员与管理员的人数上限
#define TMX 10// 审阅人数上限
#define MMX 1// 管理员人数上限

// /用户是否锁定
#define UNLOCK 0// 未锁
#define LOCK 1// 已锁

// /单位是否锁定
#define NOTE_UNLOCK 0// 未锁
#define NOTE_LOCK 1// 已锁

#define REPORTTYPE_IN 0// 发送给我
#define REPORTTYPE_TO 1// 我发送给别人

// /上报信息处理状态
#define OPTTYPE_ALL 111// 全部
#define OPTTYPE_TREATED 100// 已处理
#define OPTTYPE_UNTREATED -1// 未处理
#define OPTTYPE_READ 0// 签阅
#define OPTTYPE_SAVE 1// 归档
#define OPTTYPE_ALLOT 2// 分发
#define OPTTYPE_REPORT 3// 上报

/**上报省级*/
#define OPTTYPE_REPORT_SHENG 31

/**上报市局*/
#define OPTTYPE_REPORT_CITY  3

/**上报县局*/
#define OPTTYPE_REPORT_COUNTY 33

#define OPTTYPE_TOREAD 4// 转审阅

/**省级录用*/
#define OPTTYPE_HIRE_SHENG 7//

/**市级录用*/
#define OPTTYPE_HIRE_CITY 5// 市级录用

/**县级录用*/
#define OPTTYPE_HIRE_COUNTY 6//

// /群是否锁定
#define GROUP_UNLOCK 0// 未锁
#define GROUP_LOCK 1// 已锁
// /群角色
#define GROUP_MEMBER 1// 群成员
#define GROUP_MANAGER 2// 群管理员

// /添加群的审核状态
#define AUDIT_WAIT 0// 等待审核
#define AUDIT_PASS 1// 审核通过
#define AUDIT_NOPASS 2// 审核不通过

// /群消息的状态
#define GROUPNEWS_DISPLAY 0// 群消息隐藏
#define GROUPNEWS_SHOW 1// 群消息显示

// 群人员的存在状态
#define GROUPPEOPLE_NROMAL 0// 未封号
#define GROUPPEOPLE_FROBIDEN 1// 已封号

/** 超级管理员的节点id -1*/
#define SMANAGER_NODE_ID -1

// / 下级节点根结点的did
#define DOWN_ROOT_NODE_ID -2

// 积分类型
/** 新增信息 */
#define ADD_NEWS 1

/** 县级录用信息 */
#define COUNTY_HIRE_NEWS 2

/** 市级录用信息 */
#define CITY_HIRE_NEWS 3

@interface UserRole : NSObject

@end
