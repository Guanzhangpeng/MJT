//
//  YWAddressInfoModel.h
//  YWChooseAddress
//
//  Created by Candy on 2018/2/8.
//  Copyright © 2018年 com.zhiweism. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWAddressInfoModel : NSObject<NSCopying>

@property (nonatomic, copy) NSString * phone;            // 电话
@property (nonatomic, copy) NSString * name;             // 姓名
@property (nonatomic, copy) NSString * province_code;
@property (nonatomic, copy) NSString * city_code;
@property (nonatomic, copy) NSString * area_code;
@property (nonatomic, copy) NSString * street_code;            // 地区码（如：510107）
@property (nonatomic, copy) NSString * address;     // 地区（如：四川省成都市武侯区）
@property (nonatomic, copy) NSString * house_number;   // 门牌号 详细地址（如：红牌楼街道下一站都市B座406）
@property (nonatomic, copy) NSString * detail_address;       // 四川省成都市武侯区红牌楼街道下一站都市B座406）
@property (nonatomic, copy) NSString * default_address;    // 是否默认地址（1：是，2：否）



@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * create_time;
@property (nonatomic, copy) NSString * update_time;
@property (nonatomic, copy) NSString * userid;

@end
