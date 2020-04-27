//
//  MjtSignHelper.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/24.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtSignHelper.h"
#import "NSString+YYAdd.h"
#import "MjtSigner.h"
@implementation MjtSignHelper

+(NSDictionary *)urlWithString:(NSString *)url{
    NSURL *urlBase = [NSURL URLWithString:url];
    
    //1.先按照‘&’拆分字符串
    NSArray *array = [urlBase.query componentsSeparatedByString:@"&"];
    //2.初始化两个可变数组
    NSMutableArray *mutArrayKey = [[NSMutableArray alloc]init];
    NSMutableArray *mutArrayValue = [[NSMutableArray alloc]init];
    //3.以拆分的数组内容个数为准继续拆分数组，并将拆分的元素分别存到两个可变数组中
    for (int i=0; i<[array count]; i++) {
        NSArray *arr = [array[i] componentsSeparatedByString:@"="];
        [mutArrayKey addObject:arr[0]];
        [mutArrayValue addObject:arr[1]];
    }
    //4.初始化一个可变字典，并设置键值对
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjects:mutArrayValue forKeys:mutArrayKey];
    
    return @{@"scheme":urlBase.scheme?:@"",
             @"host":urlBase.host?:@"",
             @"port":urlBase.port?:@"",
             @"path":urlBase.path?:@"",
             @"query":dict};
    
}

+(NSString *)signWithPath:(NSString *)path{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateSting = [formatter stringFromDate:date];
    //拼装sign
    NSString *sign = [NSString stringWithFormat:@"%@%@%@",path,dateSting,[MjtSigner sharedSigner].app_token];
    return [sign md5String];
}

+ (NSString *)kUserPath{
    NSString * path = [self pathForDocumentsDirectoryWithPath:@"MJTUSER.json"];
    return path;
}
/**
*  签名路径
*/
+ (NSString *)kSignPath{
    NSString * path = [self pathForDocumentsDirectoryWithPath:@"MJTSIGN.json"];
    return path;
}

/**
*  拼接路径
*/
+ (NSString *)pathForDocumentsDirectoryWithPath:(NSString *)path{
    return [[self pathForDocumentsDirectory] stringByAppendingPathComponent:path];
}

/**
*  获取DocumentDirectory沙盒路径
*/
+ (NSString *)pathForDocumentsDirectory{
    static NSString *path = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        path = [paths lastObject];
    });
    return path;
}
@end
