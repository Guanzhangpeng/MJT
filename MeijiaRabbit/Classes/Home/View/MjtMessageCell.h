//
//  MjtMessageCell.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/5/29.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MjtMessageModel;
@interface MjtMessageCell : UITableViewCell
@property (nonatomic, strong) MjtMessageModel *model;
@end

NS_ASSUME_NONNULL_END
