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
+ (NSDictionary *) mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}

static id _instance;//静态全局变量
//copy方法有可能会产生新的对象，copy内部会调用该方法，对该进行拦截
- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

/***  alloc方法内部会调用这个方法*/
+ (id)allocWithZone:(struct _NSZone *)zone
{
    if (_instance == nil) { // 最严谨的方法，判断两次，防止频繁加锁
        @synchronized(self) {
            if (_instance == nil) { // 防止创建多次
                _instance = [super allocWithZone:zone];
            }
        }
    }
    return _instance;
}
+ (instancetype)sharedUser
{
    if (_instance == nil) { // 防止频繁加锁
        @synchronized(self) {
            if (_instance == nil) { // 防止创建多次
                NSString *path = [MjtSignHelper kUserPath];
                NSData *signData = [NSData dataWithContentsOfFile:path];
                if (signData != nil) {
                    _instance = [NSKeyedUnarchiver unarchiveObjectWithData:signData];
                }
                if (signData == nil) {
                    _instance = [[self alloc] init];
                }
            }
        }
    }
    return _instance;
}


+ (instancetype)userWithDict:(NSDictionary *)userDic{
    [self destroyUser];
    _instance = [self sharedUser];
    [_instance setValuesForKeysWithDictionary:userDic];
    return _instance;
}

+ (void)destroyUser{
    _instance = nil;
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
