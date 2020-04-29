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
 *  普通的Get请求
 *
 *  @param url         请求路径
 *  @param param       参数
 *  @param success     成功的block
 *  @param failure     失败的block
 */
+ (void)getWithUrl:(NSString *)url params:(id)param success:(void (^)(id responeseObject))success failure:(void (^)(NSError * error))failure;
/**
 *  普通的Post请求
 *
 *  @param url         请求路径
 *  @param param       参数
 *  @param success     成功
 *  @param failure     失败
 */
+ (void)postWithUrl:(NSString *)url params:(id)param decryptResponse:(BOOL)isDecrypt showHud:(BOOL)isShowHud success:(void (^)(id responseDict))success failure:(void (^)(NSError *error))failure;

/**
*  Post请求 上传数据*
*  @param url         请求路径
*  @param param       参数
*  @param data     待上传数据
*  @param paramName     参数名称
*  @param fileName     （告诉服务器）所上传文件的文件名
*  @param  mimeType : 所上传文件的文件类型
*  @param success    成功回调
*  @param failure    失败回调
*/
+ (void)postWithUrl:(NSString *)url params:(id)param data:(NSData *)data paramName:(NSString *)paramName fileName:(NSString *)fileName mimeType:(NSString *)mimeType success:(void (^)(id responseObjc))success failure:(void (^)(NSError *error))failure;

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
