//
//  NetBaseTool.m
//  
//
//  Created by 548543LJ on 15/4/29.
//  Copyright (c) 2015年 548543LJ. All rights reserved.
//

#import "NetBaseTool.h"
#import "HttpTool.h"
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

+ (void)postWithUrl:(NSString *)url params:(id)param decryptResponse:(BOOL)isDecrypt showHud:(BOOL)isShowHud success:(void (^)(id responseDict))success failure:(void (^)(NSError *error))failure{
    [HttpTool POST:url parameters:param decryptResponse:isDecrypt showHud:isShowHud success:^(id responseObj) {
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
    [HttpTool POST:url params:param data:data paramName:paramName fileName:fileName mimeType:mimeType success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
+(void)postWithURL:(NSString *)url params:(NSMutableDictionary *)param formDataArray:(NSMutableDictionary *)formDataArray success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [HttpTool postWithURL:url params:param formDataArray:formDataArray success:^(id responseObj) {
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
