//
//  WBNetBaseTool.h
//  
//
//  Created by 548543LJ on 15/4/29.
//  Copyright (c) 2015年 548543LJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetBaseTool : NSObject

/**
 *  Get请求，字典转模型
 *
 *  @param url         请求路径
 *  @param param       参数
 *  @param resultClass 返回的模型数据
 *  @param success     成功的block
 *  @param failure     失败的block
 */
+ (void)getWithUrl:(NSString *)url params:(id)param resultClass:(Class)resultClass success:(void (^)(id))success failure:(void (^)(NSError *))failure;

/**
 *  Post请求，字典转模型
 *
 *  @param url         请求路径
 *  @param param       参数
 *  @param resultClass 返回的模型数据
 *  @param success     成功的block
 *  @param failure     失败的block
 */
+ (void)postWithUrl:(NSString *)url params:(id)param resultClass:(Class)resultClass success:(void (^)(id))success failure:(void (^)(NSError *))failure;


/**
 *  将参数封装成json发送post请求
 *
 *  @param url         请求路径
 *  @param param       参数
 *  @param resultClass 返回的模型数据
 *  @param success     成功
 *  @param failure     失败
 */
+ (void)postJsonWithUrl:(NSString *)url params:(id)param resultClass:(Class)resultClass success:(void (^)(id))success failure:(void (^)(NSError *))failure;



/**
 *  普通的Post请求
 *
 *  @param url         请求路径
 *  @param param       参数
 *  @param success     成功
 *  @param failure     失败
 */
+ (void)postWithUrl:(NSString *)url params:(id)param success:(void (^)(id))success failure:(void (^)(NSError *))failure;

+ (void)postWithUrl:(NSString *)url params:(id)param data:(NSData *)data paramName:(NSString *)paramName fileName:(NSString *)fileName mimeType:(NSString *)mimeType success:(void (^)(id))success failure:(void (^)(NSError *))failure;


@end
