//
//  MjtTipView.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/6.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MjtTipView : UIView
@property (nonatomic, strong) void(^tapAction)();
@property (nonatomic, weak) UILabel *tipLabel;
@end

NS_ASSUME_NONNULL_END
