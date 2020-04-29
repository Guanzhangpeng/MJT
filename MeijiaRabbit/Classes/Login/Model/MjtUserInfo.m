//
//  MjtUserInfo.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/27.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtUserInfo.h"
#import "MjtSignHelper.h"
@implementation MjtUserInfo
//+ (NSDictionary *)mj_replacedKeyFromPropertyName{
//    return @{
//             @"ID" : @"id"//前边的是你想用的key，后边的是返回的key
//             };
//}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

static MjtUserInfo *_userInfo;//静态全局变量
//copy方法有可能会产生新的对象，copy内部会调用该方法，对该进行拦截
- (id)copyWithZone:(NSZone *)zone
{
    return _userInfo;
}

/***  alloc方法内部会调用这个方法*/
+ (id)allocWithZone:(struct _NSZone *)zone
{
    if (_userInfo == nil) { // 最严谨的方法，判断两次，防止频繁加锁
        @synchronized(self) {
            if (_userInfo == nil) { // 防止创建多次
                _userInfo = [super allocWithZone:zone];
            }
        }
    }
    return _userInfo;
}
+ (instancetype)sharedUser
{
    if (_userInfo == nil) { // 防止频繁加锁
        @synchronized(self) {
            if (_userInfo == nil) { // 防止创建多次
                NSString *path = [MjtSignHelper kUserPath];
                NSData *userData = [NSData dataWithContentsOfFile:path];
                if (userData != nil) {
                    userData = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
                }
                if (userData == nil) {
                    userData = [[self alloc] init];
                }
            }
        }
    }
    return _userInfo;
}


+ (instancetype)userWithDict:(NSDictionary *)userDic{
    [self destroyUser];
    _userInfo = [self sharedUser];
    [_userInfo setValuesForKeysWithDictionary:userDic];
    return _userInfo;
}

+ (void)destroyUser{
    _userInfo = nil;
    NSString *path = [MjtSignHelper kUserPath];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

+ (void)saveDataToKeyChian{
    NSData *signerData = [NSKeyedArchiver archivedDataWithRootObject:[self sharedUser]];
    NSString *path = [MjtSignHelper kUserPath];
    if ([signerData writeToFile:path atomically:YES]) {
        MJTLog(@"保存成功..");
    }
}

-(BOOL)isLogin
{
    if (_userInfo && _userInfo.mobile != nil && _userInfo.ID != nil && ![_userInfo.mobile isEqualToString:@""] && ![_userInfo.ID isEqualToString:@""]) {
        return true;
    }
    return false;
}
#pragma mark -- NSCoping
- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.ID forKey:@"ID"];
    [coder encodeObject:self.avatar forKey:@"avatar"];
    [coder encodeObject:self.mobile forKey:@"mobile"];
    [coder encodeObject:self.sex forKey:@"sex"];
    [coder encodeObject:self.user_name forKey:@"user_name"];
    
}
- (nullable instancetype)initWithCoder:(NSCoder *)coder{
    if (self = [super init]) {
        self.ID = [coder decodeObjectForKey:@"ID"];
        self.avatar = [coder decodeObjectForKey:@"avatar"];
        self.mobile = [coder decodeObjectForKey:@"mobile"];
        self.sex = [coder decodeObjectForKey:@"sex"];
        self.user_name = [coder decodeObjectForKey:@"user_name"];
    }
    return self;
}
@end
