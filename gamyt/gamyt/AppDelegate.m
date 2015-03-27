//
//  AppDelegate.m
//  gamyt
//
//  Created by yons on 15-3-3.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "LeftMenuViewController.h"
#import "BPush.h"
#import <AudioToolbox/AudioToolbox.h>
#import "InfoDetailViewController.h"
#import "SlideNavigationController.h"

@interface AppDelegate ()<BPushDelegate>

@end

@implementation AppDelegate{
    NSDictionary *tempUserInfo;
    BOOL flag;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(unbindChannel)
                                                 name:@"unbindChannel"
                                               object:nil];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:36/255.0 green:102/255.0 blue:171/255.0 alpha:1]];
    }
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    LeftMenuViewController *leftMenu = (LeftMenuViewController*)[mainStoryboard
                                                                 instantiateViewControllerWithIdentifier: @"LeftMenuViewController"];
    [SlideNavigationController sharedInstance].leftMenu = leftMenu;
    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = .18;
    [SlideNavigationController sharedInstance].enableSwipeGesture = NO;
    [SlideNavigationController sharedInstance].portraitSlideOffset = [UIScreen mainScreen].bounds.size.width-200;
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidClose object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSLog(@"Closed %@", menu);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidOpen object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSLog(@"Opened %@", menu);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidReveal object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSLog(@"Revealed %@", menu);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUnreadCount" object:self];
        
    }];
    
    
    //推送
    // iOS8 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
        
    }
    
#warning 上线 AppStore 时需要修改 pushMode
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    //正式
//    [BPush registerChannel:launchOptions apiKey:@"ZUbGFfu96LviK68lNRR1GxPr" pushMode:BPushModeDevelopment isDebug:YES];
    
    //测试
    [BPush registerChannel:launchOptions apiKey:@"XoW4d6oBCmduBq1ISjDclNcl" pushMode:BPushModeDevelopment isDebug:YES];
    
    //    [BPush setupChannel:launchOptions];
    
    // 设置 BPush 的回调
    [BPush setDelegate:self];
    
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
        [self performSelector:@selector(toRemoteNotificationView:) withObject:userInfo afterDelay:0.3f];
    }
    application.applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    return YES;
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSLog(@"test:%@",deviceToken);
//    NSString *deviceId = [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding];
    
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannel];
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"%@",userInfo);
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
    application.applicationIconBadgeNumber = 0;
    
    NSDictionary *dic = [userInfo objectForKey:@"aps"];
    NSString *message = [dic objectForKey:@"alert"];
    
    
    //判断应用程序当前的运行状态，如果是激活状态，则进行提醒，否则不提醒
    if (application.applicationState == UIApplicationStateActive) {
        if (!flag) {
            flag = YES;
            if (CURRENT_SYSTEM_VERSION < 8.0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"打开", nil,nil];
                tempUserInfo = userInfo;
                [alert show];
            }else{
                UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alert2 addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    flag = NO;
                }]];
                [alert2 addAction:[UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    flag = NO;
                    [self performSelector:@selector(toRemoteNotificationView:) withObject:userInfo afterDelay:0.3f];
                }]];
                [self.window.rootViewController presentViewController:alert2 animated:YES completion:nil];
            }
        }
    }else{
        [self showNotificationWithMessage:message];
    }
    
    
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    NSLog(@"didReceiveLocalNotification:%@",notification.userInfo);
    
//    // App 收到本地的通知
//    if ([[notification.userInfo objectForKey:@"id"] isEqualToString:@"affair.schedule"]) {
//        //判断应用程序当前的运行状态，如果是激活状态，则进行提醒，否则不提醒
//        if (application.applicationState == UIApplicationStateActive) {
//            
//            if (CURRENT_SYSTEM_VERSION < 8.0) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:notification.alertBody delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:notification.alertAction, nil,nil];
//                [alert show];
//            }else{
//                UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"提醒" message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
//                [alert2 addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil]];
//                [alert2 addAction:[UIAlertAction actionWithTitle:notification.alertAction style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                    [self performSelector:@selector(toRemoteNotificationView:) withObject:userInfo afterDelay:0.3f];
//                }]];
//                [self.window.rootViewController presentViewController:alert2 animated:YES completion:nil];
//            }
//        }
//    }
}

//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
//{
//    if (notification)
//    {
//        application.applicationIconBadgeNumber=0;
//        int count =[[[UIApplication sharedApplication] scheduledLocalNotifications] count];
//        if(count>0)
//        {
//            NSMutableArray *newarry= [NSMutableArray arrayWithCapacity:0];
//            for (int i=0; i<count; i++)
//                {
//                    UILocalNotification *notif=[[[UIApplication sharedApplication] scheduledLocalNotifications] objectAtIndex:i];
//                    notif.applicationIconBadgeNumber=i+1;
//                    [newarry addObject:notif];
//                }
//            [[UIApplication sharedApplication] cancelAllLocalNotifications];
//            if (newarry.count>0)
//                {
//                    for (int i=0; i<newarry.count; i++)
//                        {
//                            UILocalNotification *notif = [newarry objectAtIndex:i];
//                            [[UIApplication sharedApplication] scheduleLocalNotification:notif];
//                        }
//                }
//        }
//    }
//}


- (void)applicationDidBecomeActive:(UIApplication *)application{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //reset applicationIconBadgeNumber;
    application.applicationIconBadgeNumber=0;
    int count =[[[UIApplication sharedApplication] scheduledLocalNotifications] count];
    if(count>0)
    {
        NSMutableArray *newarry= [NSMutableArray arrayWithCapacity:0];
        for (int i=0; i<count; i++)
        {
                UILocalNotification *notif=[[[UIApplication sharedApplication] scheduledLocalNotifications] objectAtIndex:i];
                notif.applicationIconBadgeNumber=i+1;
                [newarry addObject:notif];
            }
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        if (newarry.count>0)
        {
                for (int i=0; i<newarry.count; i++)
                {
                        UILocalNotification *notif = [newarry objectAtIndex:i];
                        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
                    }
            }
    }
}

- (void)showNotificationWithMessage:(NSString *)message{
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    notification.fireDate=[[NSDate new] dateByAddingTimeInterval:3];
    notification.alertBody = message;
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.alertAction = @"打开";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.applicationIconBadgeNumber = [[[UIApplication sharedApplication] scheduledLocalNotifications] count]+1;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark Push Delegate
- (void)onMethod:(NSString*)method response:(NSDictionary*)data{
    NSLog(@"Method: %@\n%@",method,data);
    if ([method isEqualToString:@"bind"]) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *channelid = [BPush getChannelId];
        [ud setObject:channelid forKey:@"channelid"];
        NSString *pushuserid = [BPush getUserId];
        [ud setObject:pushuserid forKey:@"pushUserId"];
    }
}


-(void)toRemoteNotificationView:(NSDictionary *)userInfo{
    NSNumber *messageType = [userInfo objectForKey:@"messageType"];
    switch ([messageType intValue]) {
        case 0://有新的上报信息
        {
            NSNumber *infoId = [userInfo objectForKey:@"infoId"];
            //            NSMutableDictionary *userinfo = [NSMutableDictionary dictionary];
            //            [userinfo setObject:infoId forKey:@"infoId"];
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"toInfoDetail" object:nil userInfo:userinfo];
            
            
            
            InfoDetailViewController *infoDetail = [[UIStoryboard storyboardWithName:@"Main"
                                                                              bundle: nil] instantiateViewControllerWithIdentifier:@"InfoDetailViewController"];
            infoDetail.reportid = infoId;
            
                        [[SlideNavigationController sharedInstance] pushViewController:infoDetail animated:YES];
            
            //            [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:infoDetail
            //                                                                     withSlideOutAnimation:NO
            //                                                                             andCompletion:nil];
            
//            [self.window.rootViewController.navigationController pushViewController:infoDetail animated:YES];
            //            [self.window.rootViewController   presentViewController:infoDetail animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self performSelector:@selector(toRemoteNotificationView:) withObject:tempUserInfo afterDelay:0.3f];
    }
    flag = NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
