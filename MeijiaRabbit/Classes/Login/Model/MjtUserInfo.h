//
//  MjtUserInfo.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/27.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MjtUserInfo : NSObject<NSCopying>
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *user_name;

/*
    判断用户是否已经登录
*/
-(BOOL)isLogin;


/*
     获取User对象
 */
+ (instancetype)sharedUser;

/*
     根据字典创建User对象
 */
+ (instancetype)userWithDict:(NSDictionary *)userDic;

/*
    User对象 保存
*/
+ (void)saveDataToKeyChian;

@end

NS_ASSUME_NONNULL_END
