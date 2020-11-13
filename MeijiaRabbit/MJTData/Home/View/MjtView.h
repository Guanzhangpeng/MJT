//
//  MjtView.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/6.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MjtView : UIView
@property (nonatomic, weak) UILabel *textLabel;
@property (nonatomic, weak) UILabel *detailtextLabel;
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UIImageView *bgView;
@property (nonatomic, strong) void(^clickBlock)();
@end

NS_ASSUME_NONNULL_END
