//
//  NetBaseTool.m
//  
//
//  Created by 548543LJ on 15/4/29.
//  Copyright (c) 2015年 548543LJ. All rights reserved.
//

#import "NetBaseTool.h"
#import "HttpTool.h"
#import "MJExtension.h"
@implementation NetBaseTool

+ (void)getWithUrl:(NSString *)url params:(id)param success:(void (^)(id responeseObject))success failure:(void (^)(NSError * error))failure{
    
    [HttpTool GET:url parameters:nil success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)postWithUrl:(NSString *)url params:(id)param resultClass:(Class)resultClass success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSDictionary *params = [param mj_keyValues];
    [HttpTool POST:url parameters:params success:^(id responseObj) {
        if (success) {
            id result = [resultClass mj_objectWithKeyValues:responseObj];// 将返回的字典自动转换成模型
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
+(void)postJsonWithUrl:(NSString *)url params:(id)param resultClass:(Class)resultClass success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSDictionary *params = [param mj_keyValues];
    [HttpTool POSTJson:url parameters:params success:^(id responseObj) {
        if (success) {
            id result = [resultClass mj_objectWithKeyValues:responseObj];// 将返回的字典自动转换成模型
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)postWithUrl:(NSString *)url params:(id)param success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    NSDictionary *params = [param mj_keyValues];
    [HttpTool POST:url parameters:params success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)postWithUrl:(NSString *)url params:(id)param data:(NSData *)data paramName:(NSString *)paramName fileName:(NSString *)fileName mimeType:(NSString *)mimeType success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSDictionary *params = [param mj_keyValues];
    [HttpTool POST:url params:params data:data paramName:paramName fileName:fileName mimeType:mimeType success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
