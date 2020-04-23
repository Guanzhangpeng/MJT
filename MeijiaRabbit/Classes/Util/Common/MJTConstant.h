//
//  MJTConstant.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/6.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
#import "HttpTool.h"

#define WeakSelf                __weak typeof(self) weakSelf = self

/**
 *  通知中心
 */
#define MJTNotificationCenter [NSNotificationCenter defaultCenter]


/**
 * 设置颜色
 */
#define MJTColorFromHexString(__hexString__) [UIColor colorFromHexString:__hexString__]

/**
 *  全局橘色主色调
 */
#define MJTGlobalMainColor       [UIColor colorFromHexString:@"#FFCE00"]

/**
 *  全局灰色色字体颜色 + placeHolder字体颜色
 */
#define MJTGlobalGrayTextColor       [UIColor colorFromHexString:@"#999999"]

/**
 *  全局白色字体
 */
#define MJTGlobalWhiteTextColor      [UIColor colorFromHexString:@"#ffffff"]

/**
 *  全局黑色字体
 */
#define MJTGlobalBlackTextColor      [UIColor colorFromHexString:@"#323232"]
/**
 *  全局浅黑色 字体
 */
#define MJTGlobalShadowBlackTextColor      [UIColor colorFromHexString:@"#646464"]

/**
 *  全局灰色 背景
 */
#define MJTGlobalGrayBackgroundColor [UIColor colorFromHexString:@"#f8f8f8"]

/**
 *  全局细下滑线颜色 以及分割线颜色
 */
#define MJTGlobalBottomLineColor     [UIColor colorFromHexString:@"#d6d7dc"]

/**
 *  全局橙色
 */
#define MJTGlobalOrangeTextColor      [UIColor colorFromHexString:@"#FF9500"]

/**
 *  全局细线高度 .75f
 */
UIKIT_EXTERN CGFloat const MJTGlobalBottomLineHeight;

/**
 *  UIView 动画时长
 */
UIKIT_EXTERN NSTimeInterval const MJTAnimateDuration ;

/**
 *  全局控制器顶部间距 10
 */
UIKIT_EXTERN CGFloat const MJTGlobalViewTopInset;

/**
 *  全局控制器左边间距 12
 */
UIKIT_EXTERN CGFloat const MJTGlobalViewLeftInset;

/**
 *  全局控制器中间间距 10
 */
UIKIT_EXTERN CGFloat const MJTGlobalViewInterInset;


/**
 *  全局默认头像
 */
#define MJTGlobalUserDefaultAvatar [UIImage imageNamed:@"mh_defaultAvatar"]









