//
//  NSString+Extension.m
//  黑马微博2期
//
//  Created by apple on 14-10-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//



#import "NSString+Extension.h"

@implementation NSString (Extension)

+(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}


- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    // 获得系统版本
   
        return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}

- (NSInteger)fileSize
{
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    BOOL dir = NO;// 判断是否为文件
    
    BOOL exists = [mgr fileExistsAtPath:self isDirectory:&dir];
    // 文件\文件夹不存在
    if (exists == NO) return 0;
    
    if (dir) { // self是一个文件夹
        // 遍历caches里面的所有内容 --- 直接和间接内容
        NSArray *subpaths = [mgr subpathsAtPath:self];
        NSInteger totalByteSize = 0;
        for (NSString *subpath in subpaths) {
            // 获得全路径
            NSString *fullSubpath = [self stringByAppendingPathComponent:subpath];
            // 判断是否为文件
            BOOL dir = NO;
            [mgr fileExistsAtPath:fullSubpath isDirectory:&dir];
            if (dir == NO) { // 文件
                totalByteSize += [[mgr attributesOfItemAtPath:fullSubpath error:nil][NSFileSize] integerValue];
            }
        }
        return totalByteSize;
    } else { // self是一个文件
        return [[mgr attributesOfItemAtPath:self error:nil][NSFileSize] integerValue];
    }
}

+(NSString * )regexPatten:(NSString * ) urlString
{
    NSString * result;
    //组装一个字符串，需要把里面的数字解析出来
    //    NSString *urlString=@"/Date(1440086400000)/";
    
    //NSRegularExpression类里面调用表达的方法需要传递一个NSError的参数。下面定义一个
    NSError *error;
    
    //正则表达式
    NSString * patten=@"\\d+";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:patten options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            result=[urlString substringWithRange:resultRange];
        }
    }
    return result;
}

+(NSString * )ChangeTimeFommater:(NSString *) utcTime
{
    long long  strTime=[[self regexPatten:utcTime] longLongValue];
    
    NSDate *nd = [NSDate dateWithTimeIntervalSince1970:strTime/1000.0];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:nd];
    
    return dateString;
}
+ (NSString *)imageNameWithMac:(NSString *)device_Mac{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"phoneMac" ofType:@"plist"];
    NSMutableDictionary *phoneMacData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *phoneBrand = phoneMacData[[device_Mac uppercaseString]];
    phoneBrand = [phoneBrand lowercaseString];
    NSString *imageName = @"";
    if (phoneBrand == nil || [phoneBrand isEqualToString:@""]){
        imageName = @"pinpai_other";
    }else{
        //手机品牌匹配图片
        if ([phoneBrand isEqualToString:@"huawei"]) {
            imageName = @"pinpai_huawei";
        }else if([phoneBrand isEqualToString:@"htc"]) {
            imageName = @"pinpai_htc";
        }else if([phoneBrand isEqualToString:@"oppo"]) {
            imageName = @"pinpai_oppo";
        }else if([phoneBrand isEqualToString:@"xiaomi"]) {
            imageName = @"pinpai_xiaomi";
        }else if([phoneBrand isEqualToString:@"apple"]) {
            imageName = @"pinpai_apple";
        }else if([phoneBrand isEqualToString:@"lg"]) {
            imageName = @"pinpai_LG";
        }else if([phoneBrand isEqualToString:@"sony"]) {
            imageName = @"pinpai_sony";
        }else if([phoneBrand isEqualToString:@"nokia"]) {
            imageName = @"pinpai_nokia";
        }else if([phoneBrand isEqualToString:@"samsung"]) {
            imageName = @"pinpai_samsung";
        }else if([phoneBrand isEqualToString:@"google"]) {
            imageName = @"pinpai_google";
        }else if([phoneBrand isEqualToString:@"meizu"]) {
            imageName = @"pinpai_meizu";
        }else if([phoneBrand isEqualToString:@"zte"]) {
            imageName = @"pinpai_zhongxin";
        }else if([phoneBrand isEqualToString:@"vivo"]) {
            imageName = @"pinpai_vivo";
        }else if([phoneBrand isEqualToString:@"doov"]) {
            imageName = @"pinpai_duowei";
        }else if([phoneBrand isEqualToString:@"lenovo"]) {
            imageName = @"pinpai_lenovo";
        }else if([phoneBrand isEqualToString:@"motorola"]) {
            imageName = @"pinpai_motuoluola";
        }else if([phoneBrand isEqualToString:@"coolpad"]) {
            imageName = @"pinpai_kupai";
        }else{
            imageName = @"pinpai_other";
        }
        
    }
    return imageName;
}
@end