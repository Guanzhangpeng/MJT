//
//  MjtNavigationController.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/5.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtNavigationController.h"

@interface MjtNavigationController ()

@end

@implementation MjtNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
           /* 自动显示和隐藏tabbar */
           viewController.hidesBottomBarWhenPushed = YES;
         
       }
       [super pushViewController:viewController animated:animated];
}
@end
