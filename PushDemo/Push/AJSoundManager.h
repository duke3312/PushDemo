//
//  AJSoundManager.h
//  RabbitOpen
//
//  Created by 曾文辉 on 2017/12/4.
//  Copyright © 2017年 曾文辉. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, AJRin9gType){
    AJRingTypeSystemRing    = 0,                    //使用系统铃声声道播放声音,最长播放30秒
    AJRingTypeMedia,                                //使用媒体声道播放声音,时长不限
};


@interface AJSoundManager : NSObject
+ (AJSoundManager *)getInstance;
-(void)startIncomingCallRing:(NSInteger)type;
-(void)stopIncomingCallRing;
@end
