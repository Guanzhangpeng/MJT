//
//  MjtSignHelper.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/24.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MjtSignHelper : NSObject
/**
 *  获取URL地址中的host path 以及参数等信息,并且返回字典格式
 */
+ (NSDictionary *)urlWithString:(NSString *)url;

/**
*  获取签名信息
*/
+ (NSString *)signWithPath:(NSString *)path;


/**
*  获取签名路径
*/
+ (NSString *)kSignPath;

/**
*  获取用户路径
*/
+ (NSString *)kUserPath;

@end

NS_ASSUME_NONNULL_END
