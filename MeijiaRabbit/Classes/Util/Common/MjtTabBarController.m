//
//  MjtTabBarController.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/5.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtTabBarController.h"
#import "UIColor+Extension.h"
#import "HomeViewController.h"
#import "DesignViewController.h"
#import "MallViewController.h"
#import "MineViewController.h"
#import "MjtNavigationController.h"
#import "MjtLoginVC.h"
#import "MjtWebView.h"
@interface MjtTabBarController ()<UITabBarControllerDelegate,UITabBarDelegate>{
    NSInteger tabTag;
}

@end

@implementation MjtTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    [self addChildVc:homeVC title:@"首页" image:@"tab_home_normal" selectedImage:@"tab_home"];
    
    DesignViewController *designVC = [[DesignViewController alloc] init];
    [self addChildVc:designVC title:@"灵感" image:@"tab_dessign_normal" selectedImage:@"tab_dessign"];
    
    MallViewController *mallVC = [[MallViewController alloc] init];
    [self addChildVc:mallVC title:@"商城" image:@"tab_mall_normal" selectedImage:@"tab_mall"];

    MineViewController *mineVC = [[MineViewController alloc] init];
    [self addChildVc:mineVC title:@"我的" image:@"tab_me_normal" selectedImage:@"tab_me"];
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    childVc.title = title;
    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = MJTColorFromHexString(@"#333333");//[UIColor colorWithHexColorString:@"#333333"];

    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = MJTGlobalMainColor;

    if (@available(iOS 13.0, *)) {

        [[UITabBar appearance] setUnselectedItemTintColor:MJTColorFromHexString(@"#333333")];

    }
    
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    MjtNavigationController *nav = [[MjtNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([viewController.title isEqualToString:@"商城"]) {
       MjtWebView *webView = [[MjtWebView alloc] init];
//              webView.hideNav = @"YES";
             webView.urlString = MJT_HTMLSHOPROOT_PATH;
       MjtNavigationController *nav = self.selectedViewController;
       [nav pushViewController:webView animated:YES];
       return NO;
    }
    else if([viewController.title isEqualToString:@"我的"]){
        //判断用户是否登录过,如果没有登录则跳转到登录界面
        if(![MjtUserInfo sharedUser].isLogin){
            MjtLoginVC *loginVc = [[MjtLoginVC alloc] init];
            loginVc.hidesBottomBarWhenPushed = YES;
            MjtNavigationController *nav = tabBarController.selectedViewController;
            [nav pushViewController:loginVc animated:YES];
            return false;
        }
    }
    return YES;
}
@end
