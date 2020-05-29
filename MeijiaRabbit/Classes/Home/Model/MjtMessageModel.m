
//
//  MjtMessageModel.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/5/29.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtMessageModel.h"
#import "MJExtension.h"
#import "NSDate+Extension.h"
@implementation MjtMessageModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
#pragma mark - Getter
- (NSString *)create_time
{
    NSDateFormatter *fmt = [NSDateFormatter mh_defaultDateFormatter];
#warning CoderMikeHe: 真机调试的时候，必须加上这句
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 获得发布的具体时间
    NSDate *createDate = [fmt dateFromString:_create_time];
    
    // 判断是否为今年
    if (createDate.mh_isThisYear) {
        if (createDate.mh_isToday) { // 今天
            NSDateComponents *cmps = [createDate mh_deltaWithNow];
            if (cmps.hour >= 1) { // 至少是1小时前发的
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1~59分钟之前发的
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 1分钟内发的
                return @"刚刚";
            }
        } else if (createDate.mh_isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        } else { // 至少是前天
            fmt.dateFormat = @"MM月dd日";
            return [fmt stringFromDate:createDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt stringFromDate:createDate];
    }
}
@end
