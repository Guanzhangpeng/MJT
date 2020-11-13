//
//  MjtServiceAllVC.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/20.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCategoryListContainerView.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MJTServiceOrderType) {
//获取类型(1:全部，2：待付款，3：待开工，4：待验收，5：待评价)
    MJTServiceOrderTypeAll = 1,
    /** 待付款 */
    MJTServiceOrderTypePaying = 2,
    /** 待开工 */
    MJTServiceOrderTypeWorking = 3,
        /** 待验收 */
    MJTServiceOrderTypeChecking = 4,
        /** 待评价 */
    MJTServiceOrderTypePricing = 5
    
};
@interface MjtServiceBaseVC : MjtBaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, assign) MJTServiceOrderType orderType;
@end
NS_ASSUME_NONNULL_END
