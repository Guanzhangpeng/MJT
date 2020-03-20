//
//  MjtLocationManager.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/19.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MjtLocationManager : NSObject

@property (nonatomic, strong) NSString *currentCity;
//开始定位
-(void)locationStart;
@end

NS_ASSUME_NONNULL_END
