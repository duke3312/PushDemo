//
//  AJSoundManager.m
//  RabbitOpen
//
//  Created by 曾文辉 on 2017/12/4.
//  Copyright © 2017年 曾文辉. All rights reserved.
//

#import "AJSoundManager.h"
#import <AudioToolbox/AudioServices.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioSession.h>


id selfAJSoundManager;

@interface AJSoundManager()
{
    BOOL isRing;
    SystemSoundID           m_RingSound;
}
//@property (nonatomic,strong)NSTimer *playTimer;
@property (nonatomic,strong)AVAudioPlayer *player;

@end

@implementation AJSoundManager

-(instancetype)init
{
    if(self= [super init])
    {
        selfAJSoundManager = self;
        isRing = NO;
        m_RingSound = 0;
        self.player  = nil;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:NSExtensionHostDidEnterBackgroundNotification object:NULL];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(audioRouteChangeListenerCallback:)
                                                     name:AVAudioSessionRouteChangeNotification
                                                   object:nil];
        
    }
    return self;
}



+ (AJSoundManager *)getInstance{
    static AJSoundManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    
    return shareInstance;
}


-(void)startIncomingCallRing:(NSInteger)type
{
    [self stopIncomingCallRing];
    isRing = YES;
    NSString *ringpath=[[NSBundle mainBundle] pathForResource:@"voip_call" ofType:@"caf"];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    if(type == AJRingTypeMedia)
    {
        NSData *ringData=[NSData dataWithContentsOfFile:ringpath];
        self.player=[[AVAudioPlayer alloc] initWithData:ringData error:nil];
        self.player.numberOfLoops = -1;
        [self.player prepareToPlay];
        [self.player play];
        AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, ajsoundCompleteCallback, NULL);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(m_RingSound);
        
    } else if(type == AJRingTypeSystemRing)
    {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:ringpath], &m_RingSound);
        AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, ajsoundCompleteCallback, NULL);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(m_RingSound);
//        AudioServicesPlayAlertSound(m_RingSound);//如果静音则震动
    }
    
}

-(void)ajVibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

void ajsoundCompleteCallback(SystemSoundID sound,void * clientData) {
    [selfAJSoundManager performSelector:@selector(ajVibrate) withObject:nil afterDelay:1];
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);  //震动
    //    AudioServicesPlaySystemSound(sound);  // 播放系统声音
}



-(void)stopIncomingCallRing
{
    //    if(isRing)
    //    {
    isRing = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(ajVibrate) object:nil];
    if (m_RingSound > 0){
        
        AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);//移除
        AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
        AudioServicesRemoveSystemSoundCompletion(m_RingSound);//移除
        AudioServicesDisposeSystemSoundID(m_RingSound);//释放
        m_RingSound = 0;
    }
    
    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);//移除
    if (self.player){
        [self.player stop];
        self.player  = nil;
    }
    //    }
}

/*监听耳机插拔*/
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification{
    
}




- (void)applicationDidEnterBackground:(NSNotification*)notification{
    [self stopIncomingCallRing];
}





@end
