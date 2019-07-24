//
//  CustomAlertView.h
//  PushDemo
//
//  Created by duke on 2019/7/24.
//  Copyright © 2019 duke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomAlertView : UIView

-(instancetype)initWithMessage:(NSString *)message;
-(void)show;

@end

NS_ASSUME_NONNULL_END
