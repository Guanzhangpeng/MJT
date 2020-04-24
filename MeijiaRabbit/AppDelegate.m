//
//  AppDelegate.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/3.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "AppDelegate.h"
#import "OttoFPSButton.h"
#import "MjtSigner.h"
#import "DES3Util.h"
#import "RSAUtil.h"
#import "MjtTabBarController.h"
#import "UIImage+Extension.h"
#import "NSString+YYAdd.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate ()<CLLocationManagerDelegate>
@property(nonatomic,retain)CLLocationManager *locationManager;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self _loadPublickey];
    [NSThread sleepForTimeInterval:2.f];
    
    ///导航栏样式
    [self _setupNavigationBar];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
     self.window.rootViewController = [[MjtTabBarController alloc] init];
     [self.window makeKeyAndVisible];
    
    //FPS
    CGRect frame = CGRectMake(0, 300, 80, 30);
    UIColor *btnBGColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    OttoFPSButton *btn = [OttoFPSButton setTouchWithFrame:frame titleFont:[UIFont systemFontOfSize:15] backgroundColor:btnBGColor backgroundImage:nil];
    [self.window addSubview:btn];
    
    return YES;
}

- (void)_loadPublickey{
    [NetBaseTool getWithUrl:MJT_PUBLICKEY_PATH params:nil success:^(id responeseObject) {
        [MjtSigner signerWithDict:responeseObject];
        [MjtSigner saveDataToKeyChian];
    } failure:^(NSError *error) {
        MJTLog(@"....");
    }];
    return;
    //1.确定URL
       NSURL *url = [NSURL URLWithString:MJT_PUBLICKEY_PATH];
       
       //2.创建请求对象
       NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
       //2.1 设置请求方法为post
         request.HTTPMethod = @"POST";
       //3.创建会话对象
       NSURLSession * session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

       NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
           NSString *desString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
           NSString *responseString = [DES3Util decryptUseDES:desString key:DESKEY];
           NSDictionary *responseDic = [responseString jsonValueDecoded];
           [MjtSigner signerWithDict:responseDic];
           [MjtSigner saveDataToKeyChian];
       }];
       
       //5.执行Task
       [dataTask resume];
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
             [[NSUserDefaults standardUserDefaults] setObject:@"City" forKey:currCity];
             [[NSUserDefaults standardUserDefaults] synchronize];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"LOCATION_CITY" object:nil userInfo:@{@"CurrentCity":currCity}];
             MJTLog(currCity);
//             if (!currCity) {
//                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
//                 currCity = placemark.administrativeArea;
//             }
//             if (self.localCityData.count <= 0) {
//                 GYZCity *city = [[GYZCity alloc] init];
//                 city.cityName = currCity;
//                 city.shortName = currCity;
//                 [self.localCityData addObject:city];
//
//                 [self.tableView reloadData];
//             }
             
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
@end
