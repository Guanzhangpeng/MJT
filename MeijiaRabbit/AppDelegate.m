//
//  AppDelegate.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/3.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "AppDelegate.h"
#import "MjtTabBarController.h"
#import "UIImage+Extension.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

///导航栏样式
    [self _setupNavigationBar];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
     self.window.rootViewController = [[MjtTabBarController alloc] init];
     [self.window makeKeyAndVisible];
    return YES;
}
- (void)_setupNavigationBar{
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage imageWithColor:MJTColorFromHexString(@"#FFCE00")] forBarMetrics:UIBarMetricsDefault];
    UIImage *backImg = [[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navBar.backIndicatorImage = backImg;
    navBar.backIndicatorTransitionMaskImage = backImg;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, 0) forBarMetrics:UIBarMetricsDefault];
//   navBar.backgroundColor = MJTColorFromHexString(@"#FFCE00");
   NSDictionary *attrs = @{ NSStrokeWidthAttributeName: @(0),
                            NSFontAttributeName: [UIFont systemFontOfSize:17],
                            NSForegroundColorAttributeName:[UIColor whiteColor]};
   [navBar setTitleTextAttributes:attrs];
   [navBar setTintColor:[UIColor whiteColor]];
}

@end
