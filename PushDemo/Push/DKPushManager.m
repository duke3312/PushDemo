//
//  DKPushManager.m
//  PushDemo
//
//  Created by duke on 2019/7/24.
//  Copyright © 2019 duke. All rights reserved.
//

#import "DKPushManager.h"
#import <PushKit/PushKit.h>
#import "DKPushLocalNoti.h"

@interface DKPushManager ()<PKPushRegistryDelegate>{
    NSString *token;
}

@property (nonatomic,strong) id<PushCallBackDelegate> pushDelegate;

@end

@implementation DKPushManager
static DKPushManager *instance = nil;
+ (DKPushManager *)shareManager {
    if (instance == nil) {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}

-(void)initRegsionPush {
    // 注册PushKit通知
    PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:nil];
    pushRegistry.delegate = self;
    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    [[DKPushLocalNoti sharedPushLocalNoti] regsionPush];
}

- (void)setDelegate:(id<PushCallBackDelegate>)delegate {
    self.pushDelegate = delegate;
}

#pragma mark - PushKit delegate
- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type{
    if([credentials.token length] == 0) {
        NSLog(@"voip token NULL");
        return;
    }
    //应用启动获取token，并上传服务器
    token = [[[[credentials.token description] stringByReplacingOccurrencesOfString:@"<"withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"TOKEN = %@",token);
//    [[NSUserDefaults standardUserDefaults]setValue:token forKey:@"device_token"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    //token上传服务器
//    [self uploadToken];
}

- (void)uploadToken {
    
}

#pragma mark --- 收到推送  对数据进行处理
- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type{
    NSLog(@"push Kit payload ---> %@", payload.dictionaryPayload);
    // iOS10之前 只在后台才接受推送
    if ( [UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        [self.pushDelegate pushLocalNotiWithDic:payload.dictionaryPayload];
    }
}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type withCompletionHandler:(void(^)(void))completion NS_AVAILABLE_IOS(11_0)
{
    NSLog(@"\n============ push Kit payload ============\n%@",payload.dictionaryPayload);
    
    if ( [UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        //发起本地通知
        [self.pushDelegate pushLocalNotiWithDic:payload.dictionaryPayload];
    }
    // 收到推送后执行的回调， 最后的block需要在逻辑处理完成后主动回调
}

- (void)pushRegistry:(PKPushRegistry *)registry didInvalidatePushTokenForType:(PKPushType)type
{
    NSLog(@"======== push Kit失败 ===========");
    /// token 失效回调
}
@end
