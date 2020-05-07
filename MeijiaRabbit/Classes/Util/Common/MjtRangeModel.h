//
//  MjtRangeModel.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/5/6.
//  Copyright © 2020 管章鹏. All rights reserved.
// 大分类

#import <Foundation/Foundation.h>
#import "MjtDetailRangeModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface MjtRangeModel : NSObject
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *category_name;//局部装修
@property (nonatomic, strong) NSArray<MjtDetailRangeModel *> *children;

@end

NS_ASSUME_NONNULL_END
