//
//  MjtDiscountCell.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/16.
//  Copyright © 2020 管章鹏. All rights reserved.
// 每日特价

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MjtDiscountCell : UITableViewCell

@property (nonatomic, strong) void(^cartButtonAction)();
@end

NS_ASSUME_NONNULL_END
