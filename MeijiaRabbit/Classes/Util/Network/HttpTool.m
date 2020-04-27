//
//  WBHttpTool.m
//  
//
//  Created by 548543LJ on 15/4/24.
//  Copyright (c) 2015年 548543LJ. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"
#import "DES3Util.h"
#import "RSAUtil.h"
#import "NSDictionary+YYAdd.h"
#import "NSString+Extension.h"
#import "NSString+YYAdd.h"
#import "MjtSignHelper.h"
#import "MjtSigner.h"
#define DESKEY @"BJMJT88662020041"
@implementation HttpTool
#pragma mark - 字典加密
+ (NSString *)securitStringWithDict:(NSDictionary *)dict
{
    NSString *RSA_Public_key =  [MjtSigner sharedSigner].publickey;
    NSString *value = [NSString DataTOjsonString:dict];
    NSString *signString = [RSAUtil encryptString:value publicKey:RSA_Public_key];
    return signString;
}
//生成八位随机字符串
+ (NSString *)randomString {
    NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    // Get the characters into a C array for efficient shuffling
    NSUInteger numberOfCharacters = [alphabet length];
    unichar *characters = calloc(numberOfCharacters, sizeof(unichar));
    [alphabet getCharacters:characters range:NSMakeRange(0, numberOfCharacters)];
    
    // Perform a Fisher-Yates shuffle
    for (NSUInteger i = 0; i < numberOfCharacters; ++i) {
        NSUInteger j = (arc4random_uniform((float)numberOfCharacters - i) + i);
        unichar c = characters[i];
        characters[i] = characters[j];
        characters[j] = c;
    }
    
    // Turn the result back into a string
    NSString *result = [NSString stringWithCharacters:characters length:8];
    free(characters);
    return result;
}

+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    //增加这几行代码；
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    if (parameters == nil){
        parameters = [[NSMutableDictionary alloc] init];
    }
    NSString *des_Key = [self randomString];
    parameters[@"sign"] = [MjtSignHelper signWithPath:URLString];
    
    //对参数进行加密
    NSString * public_key= [MjtSigner sharedSigner].publickey;
    
    NSString *jsonString = [NSString DataTOjsonString:parameters];
    
    NSString *securitString = [DES3Util encryptUseDES:jsonString key:des_Key];
    NSString *RSA_Key = [RSAUtil encryptString:des_Key publicKey:public_key];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"encrytoken"] = RSA_Key;
    param[@"param"] = securitString;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
     manager.requestSerializer.timeoutInterval = 15.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //申明返回的结果类型
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    manager.responseSerializer= serializer;
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//
//    //声明请求的数据是json类型
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"application/json",nil];
    
    NSString *urlStr = [KURL(URLString)  stringByRemovingPercentEncoding];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    [manager POST:urlStr parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:window animated:YES];
        });
        if (success) {
            NSString *desString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSString *responseString = [DES3Util decryptUseDES:desString key:des_Key];
            NSDictionary *responseDic = [responseString jsonValueDecoded];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD wj_showPlainText:responseDic[@"msg"] view:window];
            });
            
            success(responseDic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:window animated:YES];
                [MBProgressHUD wj_showPlainText:@"网络加载失败" view:window];
            });
            // 展示错误信息
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
            }];
            failure(error);
        }
    }];
}

+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //申明返回的结果类型
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    manager.responseSerializer= serializer;
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
//    //申明请求的数据是json类型
//    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"application/json",nil];
    
   
    [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
           NSString *desString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
           NSString *responseString = [DES3Util decryptUseDES:desString key:DESKEY];
           NSDictionary *responseDic = [responseString jsonValueDecoded];
            success(responseDic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)POSTJson:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"application/json",nil];

    //发送请求
    [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)POST:(NSString *)URLString params:(id)param data:(NSData *)data paramName:(NSString *)paramName fileName:(NSString *)fileName mimeType:(NSString *)mimeType success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    [manager POST:URLString parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
          [formData appendPartWithFileData:data name:paramName fileName:fileName mimeType:mimeType];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)postWithURL:(NSString *)url params:(NSMutableDictionary *)params formDataArray:(NSMutableDictionary *)formDataArray success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    // 1.创建请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"application/json", nil];
    NSString *urlStr = [url stringByRemovingPercentEncoding];
    // 2.发送请求
    [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 在发送请求之前会自动调用这个block，需要在这个block中添加文件参数到formData中
        /**
         FileURL : 需要上传的文件的URL路径
         name : 服务器那边接收文件用的参数名
         fileName : （告诉服务器）所上传文件的文件名
         mimeType : 所上传文件的文件类型
         */
        //        NSURL *url = [[NSBundle mainBundle] URLForResource:@"itcast" withExtension:@"txt"];
        //        [formData appendPartWithFileURL:url name:@"file" fileName:@"test.txt" mimeType:@"text/plain" error:nil];
        
        /**
         FileData : 需要上传的文件的具体数据
         name : 服务器那边接收文件用的参数名
         fileName : （告诉服务器）所上传文件的文件名
         mimeType : 所上传文件的文件类型
         */
        //        UIImage *image = [UIImage imageNamed:@"minion_01"];
        //        NSData *fileData = UIImagePNGRepresentation(image);
        //        [formData appendPartWithFileData:fileData name:@"headIco" fileName:@"haha.png" mimeType:@"image/png"];
        
        if(formDataArray==nil){
            return;
        }
        NSData * data = formDataArray[@"file"];
        [formData appendPartWithFileData:data name:@"file"  fileName:@"avatar.jpg"  mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
