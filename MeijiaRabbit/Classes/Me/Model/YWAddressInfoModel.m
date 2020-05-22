//
//  YWAddressInfoModel.m
//  YWChooseAddress
//
//  Created by Candy on 2018/2/8.
//  Copyright © 2018年 com.zhiweism. All rights reserved.
//

#import "YWAddressInfoModel.h"
#import "MJExtension.h"
@implementation YWAddressInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}
- (id)copyWithZone:(NSZone *)zone {
    YWAddressInfoModel *copy = [[[self class] alloc] init];
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
    for (int i = 0; i < propertyCount; i++ ) {
        objc_property_t thisProperty = propertyList[i];
        const char* propertyCName = property_getName(thisProperty);
        NSString *propertyName = [NSString stringWithCString:propertyCName encoding:NSUTF8StringEncoding];
        id value = [self valueForKey:propertyName];
        [copy setValue:value forKey:propertyName];
    }
    return copy;
}
// 注意此处需要实现这个函数，因为在通过Runtime获取属性列表时，会获取到一个名字为hash的属性名，这个是系统帮你生成的一个属性
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
@end
