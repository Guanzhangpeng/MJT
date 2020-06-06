//
//  AppDelegate.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/3.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "AppDelegate.h"
#import "OttoFPSButton.h"
#import "DES3Util.h"
#import "RSAUtil.h"
#import "MjtTabBarController.h"
#import "UIImage+Extension.h"
#import "NSString+YYAdd.h"
#import <CoreLocation/CoreLocation.h>
#import <AlipaySDK/AlipaySDK.h>
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
@interface AppDelegate ()<CLLocationManagerDelegate,JPUSHRegisterDelegate>
@property(nonatomic,retain)CLLocationManager *locationManager;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:2.f];
    [self setupJPushWithOptions:launchOptions];//集成极光推送
    ///导航栏样式
    [self _setupNavigationBar];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
     self.window.rootViewController = [[MjtTabBarController alloc] init];
     [self.window makeKeyAndVisible];
    
//    //FPS
//    CGRect frame = CGRectMake(0, 300, 80, 30);
//    UIColor *btnBGColor = [UIColor colorWithWhite:0.000 alpha:0.700];
//    OttoFPSButton *btn = [OttoFPSButton setTouchWithFrame:frame titleFont:[UIFont systemFontOfSize:15] backgroundColor:btnBGColor backgroundImage:nil];
//    [self.window addSubview:btn];
    
    return YES;
}
//集成极光推送
-(void)setupJPushWithOptions:(NSDictionary *)launchOptions
{
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:APP_KEY_JPUSH
                          channel:CHANNEL_JPUSH
                 apsForProduction:NO
            advertisingIdentifier:nil];
    // 注册用户全局用户登录事件
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(localNotiJPushRegister:) name:kJPFNetworkDidLoginNotification object:nil];
    [center addObserver:self selector:@selector(localNotiJPushNewMsg:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}
- (void)_setupNavigationBar{
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage imageWithColor:MJTColorFromHexString(@"#FFCE00")] forBarMetrics:UIBarMetricsDefault];
    UIImage *backImg = [[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navBar.backIndicatorImage = backImg;
    navBar.backIndicatorTransitionMaskImage = backImg;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-500, 0) forBarMetrics:UIBarMetricsDefault];
//   navBar.backgroundColor = MJTColorFromHexString(@"#FFCE00");
   NSDictionary *attrs = @{ NSStrokeWidthAttributeName: @(0),
                            NSFontAttributeName: [UIFont systemFontOfSize:17],
                            NSForegroundColorAttributeName:[UIColor whiteColor]};
   [navBar setTitleTextAttributes:attrs];
   [navBar setTintColor:[UIColor whiteColor]];
}

-(void)applicationDidBecomeActive:(UIApplication *)application{
    [self locationStart];
}
//开始定位
-(void)locationStart{
    //判断定位操作是否被允许
    
    if([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init] ;
        self.locationManager.delegate = self;
        //设置定位精度
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;//每隔多少米定位一次（这里的设置为每隔百米)
        if (MJT_iOS8_VERSTION_LATER) {
            //使用应用程序期间允许访问位置数据
            [self.locationManager requestWhenInUseAuthorization];
        }
        // 开始定位
        [self.locationManager startUpdatingLocation];
    }else {
        //提示用户无法进行定位操作
        NSLog(@"%@",@"定位服务当前可能尚未打开，请设置打开！");
    }
}

#pragma mark - CoreLocation Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [self.locationManager stopUpdatingLocation];
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    
    //获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count >0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //获取城市
             NSString *currCity = placemark.locality;
             [[NSUserDefaults standardUserDefaults] setObject:currCity forKey:@"City"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"LOCATION_CITY" object:nil userInfo:@{@"CurrentCity":currCity}];
             
         } else if (error ==nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }else if (error !=nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
         
     }];
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (error.code ==kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
    
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SERVICEORDER_PAYFINISH object:nil userInfo:resultDic];
        }];
    }
    return   YES;
}
#pragma mark --NOTIFICATION
- (void)localNotiJPushRegister:(NSNotification *)noti {
    
    NSString* jPushRegistID = [JPUSHService registrationID];
    MjtUserInfo *user = [MjtUserInfo sharedUser];
    if (user == nil) {
        return;
    }
//    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:
//                                  @{
//                                    @"mobile":user.mobile,
//                                    @"jgid":jPushRegistID
//                                    }];
//    [NetBaseTool postWithUrl:KURL(kURLAddJpush) params:param success:^(id json) {
//        if([json[@"status"] intValue]==SERVER_CODE_OK){
//            NSLog(NSLocalizedString(@"push_regist_error", nil), json[@"msg"]);
//        }
//
//    } failure:^(NSError *error) {
//        NSLog(NSLocalizedString(@"push_regist_error", nil), [error localizedDescription]);
//    }];
}

//在收到极光推送的消息的时候会调用该方法；
- (void)localNotiJPushNewMsg:(NSNotification *)noti {
    NSLog(@"%@",noti.userInfo);
}

#pragma mark - Local Notification
//实现注册 APNs 失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  //Optional
  NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}
#pragma mark- JPUSHRegisterDelegate
// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
  if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    //从通知界面直接进入应用
  }else{
    //从通知设置界面进入应用
  }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
  // Required
  NSDictionary * userInfo = notification.request.content.userInfo;
  if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    [JPUSHService handleRemoteNotification:userInfo];
  }
  completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
  // Required
  NSDictionary * userInfo = response.notification.request.content.userInfo;
  if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    [JPUSHService handleRemoteNotification:userInfo];
  }
  completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

  // Required, iOS 7 Support
  [JPUSHService handleRemoteNotification:userInfo];
  completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

  // Required, For systems with less than or equal to iOS 6
  [JPUSHService handleRemoteNotification:userInfo];
}
@end
