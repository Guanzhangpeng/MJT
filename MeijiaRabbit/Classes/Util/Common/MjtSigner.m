//
//  MjtSigner.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/24.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtSigner.h"
#import "MjtSignHelper.h"
@implementation MjtSigner

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
+ (instancetype)sharedSigner
{
    if (_instance == nil) { // 防止频繁加锁
        @synchronized(self) {
            if (_instance == nil) { // 防止创建多次
                NSString *path = [MjtSignHelper kSignPath];
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


+ (instancetype)signerWithDict:(NSDictionary *)signDic{
    [self destroySiner];
    _instance = [MjtSigner sharedSigner];
    [_instance setValuesForKeysWithDictionary:signDic];
    return _instance;
}

+ (void)destroySiner{
    _instance = nil;
    NSString *path = [MjtSignHelper kSignPath];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

+ (void)saveDataToKeyChian{
    NSData *signerData = [NSKeyedArchiver archivedDataWithRootObject:[self sharedSigner]];
    NSString *path = [MjtSignHelper kSignPath];
    if ([signerData writeToFile:path atomically:YES]) {
        MJTLog(@"保存成功..");
    }
}

#pragma mark -- NSCoping
- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.app_token forKey:@"app_token"];
    [coder encodeObject:self.publickey forKey:@"publickey"];
    
}
- (nullable instancetype)initWithCoder:(NSCoder *)coder{
    if (self = [super init]) {
        self.app_token = [coder decodeObjectForKey:@"app_token"];
        self.publickey = [coder decodeObjectForKey:@"publickey"];
    }
    return self;
}
@end
