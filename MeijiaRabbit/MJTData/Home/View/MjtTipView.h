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
@property (nonatomic, strong) void(^moreAction)();

@property (nonatomic, weak) UILabel *tipLabel;
@property (nonatomic, strong) NSString *detailStr;
@end

NS_ASSUME_NONNULL_END
