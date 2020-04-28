//
//  WBHttpTool.h
//  
//
//  Created by 548543LJ on 15/4/24.
//  Copyright (c) 2015年 548543LJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpTool : NSObject
/** 用于post请求 */
+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *error))failure;

/** 用于一般Get请求 */
+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *error))failure;

/** 用于postJson请求 */
+ (void)POSTJson:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *error))failure;

/** 用于上传文件 */
+ (void)POST:(NSString *)URLString params:(id)param data:(NSData *)data paramName:(NSString *)paramName fileName:(NSString *)fileName mimeType:(NSString *)mimeType success:(void (^)(id))success failure:(void (^)(NSError *error))failure;



/**
 *  发送一个POST请求(上传文件数据)  请求成功，返回json数据，请求失败，返回错误信息
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param formDataArray  文件参数,数组形式传送
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithURL:(NSString *)url params:(NSMutableDictionary *)params formDataArray:(NSMutableDictionary *)formDataArray success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

@end
