//
//  DKPushLocalNoti.m
//  PushDemo
//
//  Created by duke on 2019/7/24.
//  Copyright © 2019 duke. All rights reserved.
//

#import "DKPushLocalNoti.h"
#import "DKPushManager.h"
#import <UserNotifications/UserNotifications.h>

@interface DKPushLocalNoti () <PushCallBackDelegate, UNUserNotificationCenterDelegate>{
    UILocalNotification *callNotification;
    UNNotificationRequest *request;//ios 10
}

@end

@implementation DKPushLocalNoti
+ (instancetype)sharedPushLocalNoti {
    
    static  DKPushLocalNoti *localNoti;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (localNoti == nil) {
            localNoti = [[DKPushLocalNoti alloc] init];
            [[DKPushManager shareManager] setDelegate:localNoti];
        }
    });
    return localNoti;
}
- (void)regsionPush {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
            NSLog(@"注册PushKit成功");
        }];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"pushkit设置 ----> %@",settings);
        }];
    } else{
        //较早版本
        // 注册通知，如果已经获得发送通知的授权则创建本地通知，否则请求授权(注意：如果不请求授权在设置中是没有对应的通知设置项的，也就是说如果从来没有发送过请求，即使通过设置也打不开消息允许设置)
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone) {
            
        } else {
            //请求授权
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound  categories:nil]];
        }
    }
}

#pragma mark --- PushCallBackDelegate
- (void)pushLocalNotiWithDic:(nonnull NSDictionary *)dataDic {
    NSDictionary *apsDic = [dataDic objectForKey:@"aps"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pushData"];
    //只在后台接受到推送才保存数据
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        //保存通知信息
        [[NSUserDefaults standardUserDefaults] setValue:dataDic forKey:@"pushData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.userInfo = dataDic;
        content.badge = [NSNumber numberWithInt:[[apsDic objectForKey:@"badge"] intValue]];
        if ([[apsDic objectForKey:@"type"] integerValue] == 1) { //邀请
            content.body = [NSString localizedUserNotificationStringForKey:[NSString stringWithFormat:@"%@", [apsDic objectForKey:@"alert"]] arguments:nil];
            UNNotificationSound *customSound = [UNNotificationSound soundNamed:@"voip_call.caf"];
            content.sound = customSound;
        }else { // 挂断
            //移除上一条推送
            [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[@"Voip_Push"]];
            content.title = [NSString localizedUserNotificationStringForKey:[apsDic objectForKey:@"name"] arguments:nil];
            content.body =[NSString localizedUserNotificationStringForKey:[NSString stringWithFormat:@"%@", [apsDic objectForKey:@"alert"]] arguments:nil];
            content.sound = [UNNotificationSound defaultSound];
        }
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
        request = [UNNotificationRequest requestWithIdentifier:@"Voip_Push" content:content trigger:trigger];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            
        }];
    }else {
        callNotification = [[UILocalNotification alloc] init];
        callNotification.userInfo = dataDic;
        callNotification.alertLaunchImage = @"Default";
        callNotification.alertTitle = [apsDic objectForKey:@"name"];
        callNotification.applicationIconBadgeNumber = 1;
        
        if ([[apsDic objectForKey:@"type"] integerValue] == 1) { //邀请
            callNotification.soundName = @"voip_call.caf";
            callNotification.alertBody = [NSString stringWithFormat:@"%@ %@", [apsDic objectForKey:@"name"], [apsDic objectForKey:@"alert"]];
        }else { // 挂断
            [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            callNotification.soundName = UILocalNotificationDefaultSoundName;
            callNotification.alertBody = [NSString stringWithFormat:@"%@", [apsDic objectForKey:@"alert"]];
        }
        [[UIApplication sharedApplication] presentLocalNotificationNow:callNotification];
    }
}

- (void)cancelNoti {
    //取消通知栏
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        NSMutableArray *arraylist = [[NSMutableArray alloc]init];
        [arraylist addObject:@"Voip_Push"];
        [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:arraylist];
    }else {
        [[UIApplication sharedApplication] cancelLocalNotification:callNotification];
    }
}


@end
