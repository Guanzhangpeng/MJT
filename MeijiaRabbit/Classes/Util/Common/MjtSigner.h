//
//  MjtSigner.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/24.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MjtSigner : NSObject<NSCopying>

@property (nonatomic, strong) NSString *app_token;
@property (nonatomic, strong) NSString *publickey;

/*
 获取Signer签名对象
 */
+ (instancetype)sharedSigner;

/*
 根据字典创建Signer签名对象
 */
+ (instancetype)signerWithDict:(NSDictionary *)signDic;

/*
Signer签名对象 保存
*/
+ (void)saveDataToKeyChian;
@end

NS_ASSUME_NONNULL_END
