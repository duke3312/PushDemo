//
//  DKPushManager.h
//  PushDemo
//
//  Created by duke on 2019/7/24.
//  Copyright © 2019 duke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PushCallBackDelegate <NSObject>
/**
 发起本地通知

 @param dataDic 收到推送的数据
 */
- (void)pushLocalNotiWithDic:(NSDictionary *)dataDic;
/**
  取消通知
 */
- (void)cancelNoti;

@end

@interface DKPushManager : NSObject

+ (DKPushManager *)shareManager;

- (void)initRegsionPush;

- (void)setDelegate:(id<PushCallBackDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
