//
//  DKPushLocalNoti.h
//  PushDemo
//
//  Created by duke on 2019/7/24.
//  Copyright © 2019 duke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DKPushLocalNoti : NSObject

+ (instancetype)sharedPushLocalNoti;
- (void)regsionPush;

@end

NS_ASSUME_NONNULL_END
