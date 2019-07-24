//
//  CustomAlertView.m
//  PushDemo
//
//  Created by duke on 2019/7/24.
//  Copyright © 2019 duke. All rights reserved.
//

#import "CustomAlertView.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "AJSoundManager.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define kRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

@implementation CustomAlertView

-(instancetype)initWithMessage:(NSString *)message{
    self = [super init];
    if (self) {
        // 播放音效
        [[AJSoundManager getInstance] startIncomingCallRing:AJRingTypeMedia];
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor whiteColor];
        CGFloat marginX = 20;
        CGFloat btnH = 45;
        CGFloat viewW = 280;
        UIView *view = [[UIView alloc] init] ;
        view.backgroundColor = kRGBAlpha(0xf8f8f8, 0.95);
        view.layer.cornerRadius = 10;
        view.layer.masksToBounds = NO;
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowRadius = 3;
        view.layer.shadowOffset = CGSizeMake(3, 3);
        view.layer.shadowOpacity = 0.6;
        [self addSubview:view];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, marginX, viewW-2*marginX, marginX)];
        titleLabel.text = @"消息";
        titleLabel.textColor = kRGBAlpha(0x333333, 1.0);
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:titleLabel];
        
//        CGFloat contentH = [message heightWithFont:[UIFont systemFontOfSize:14] constrainedToWidth:viewW-2*marginX];
        CGFloat contentH = 50.f;
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(titleLabel.frame) + marginX/2.f, viewW-2*marginX, contentH+marginX/2.f)];
        contentLabel.numberOfLines = 0;
        contentLabel.text = message;
        contentLabel.textColor = kRGBAlpha(0x4c4c4c, 1.0);
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:contentLabel];
        
        UIView *separatorH = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(contentLabel.frame) + marginX, viewW, 1)];
        separatorH.backgroundColor = kRGBAlpha(0xDDDDDD, 1.0);
        [view addSubview:separatorH];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(separatorH.frame), viewW/2, btnH)];
        cancelButton.tag = 101;
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:kRGBAlpha(0x3478F6, 1.0) forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [cancelButton addTarget:self action:@selector(clickToDoDelegate:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:cancelButton];
        
        UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cancelButton.frame) + 1, CGRectGetMaxY(separatorH.frame), cancelButton.frame.size.width-1, btnH)];
        sureButton.tag = 102;
        [sureButton setTitle:@"接受" forState:UIControlStateNormal];
        [sureButton setTitleColor:kRGBAlpha(0x3478F6, 1.0) forState:UIControlStateNormal];
        sureButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [sureButton addTarget:self action:@selector(clickToDoDelegate:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:sureButton];
        
        UIView *separatorW = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cancelButton.frame), CGRectGetMaxY(separatorH.frame), 1, btnH)];
        separatorW.backgroundColor = kRGBAlpha(0xDDDDDD, 1.0);
        [view addSubview:separatorW];
        
        CGFloat viewH = 4*marginX + contentH + btnH;
        [view setFrame:CGRectMake((SCREEN_WIDTH - viewW)/2.f, (SCREEN_HEIGHT - viewH)/2.f, 280, viewH)];
    }
    return self;
}
- (void)clickToDoDelegate:(UIButton *)btn {
    
    [[AJSoundManager getInstance] stopIncomingCallRing];
    [self removeFromSuperview];
}

- (void)show {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:self];
    [delegate.window bringSubviewToFront:self];
}


@end
