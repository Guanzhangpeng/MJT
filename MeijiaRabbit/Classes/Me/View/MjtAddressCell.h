//
//  MjtAddressCell.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/19.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YWAddressInfoModel;
@interface MjtAddressCell : UITableViewCell
@property (nonatomic, strong) YWAddressInfoModel *model;
@property (nonatomic, strong) void(^editAddressAction)();
@end

NS_ASSUME_NONNULL_END
