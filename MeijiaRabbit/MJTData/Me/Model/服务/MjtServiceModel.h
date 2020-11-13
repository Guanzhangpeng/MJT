//
//  MjtServiceModel.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/30.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MjtServiceModel : NSObject

@property (nonatomic, strong) NSString *orderid;
@property (nonatomic, strong) NSString *service_name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, assign) NSInteger service_order_status;//1
@property (nonatomic, strong) NSString *service_order_status_name;//"待处理"
//"orderid": "7",
//"service_name": "局部装修-美缝",
//"description": "测试测试",
//"create_time": "2020-04-01 15:55:45",
//"service_order_status": "1",
//"service_order_status_name": "待处理"
@end

NS_ASSUME_NONNULL_END
