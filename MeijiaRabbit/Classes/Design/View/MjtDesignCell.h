//
//  MjtDesignCell.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/20.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MjtDesignCell : UITableViewCell

@property (nonatomic, strong) NSMutableDictionary *dict;
@property (nonatomic, strong) void(^thumbAction)();
@end

NS_ASSUME_NONNULL_END
