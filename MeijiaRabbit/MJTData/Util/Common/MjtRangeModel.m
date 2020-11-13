//
//  MjtRangeModel.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/5/6.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtRangeModel.h"
#import "MJExtension.h"
@implementation MjtRangeModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"children" : @"MjtDetailRangeModel"};//前边，是属性数组的名字，后边就是类名
}
@end
