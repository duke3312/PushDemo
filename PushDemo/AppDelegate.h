//
//  AppDelegate.h
//  PushDemo
//
//  Created by duke on 2019/5/17.
//  Copyright © 2019 duke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(nonatomic,assign) NSInteger isShowPushAlert;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

