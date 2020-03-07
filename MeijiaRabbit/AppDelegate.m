//
//  AppDelegate.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/3.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "AppDelegate.h"
#import "MjtTabBarController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
     self.window.rootViewController = [[MjtTabBarController alloc] init];
     [self.window makeKeyAndVisible];
    return YES;
}


@end
