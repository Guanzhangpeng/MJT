//
//  MjtSettingCell.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/12.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MjtSettingItemModel;
@interface MjtSettingCell : UITableViewCell
@property (nonatomic,strong) MjtSettingItemModel  *item; /**< item data*/
@end

NS_ASSUME_NONNULL_END
