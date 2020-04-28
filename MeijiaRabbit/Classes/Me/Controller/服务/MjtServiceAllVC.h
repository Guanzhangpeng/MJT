//
//  MjtServiceAllVC.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/20.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MJTServiceOrderType) {

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
@interface MjtServiceBaseVC : MjtBaseViewController
- (MJTServiceOrderType)orderType;
@end

///全部
@interface MjtServiceAllVC : MjtServiceBaseVC

@end

///代付款
@interface MjtServicePayingVC : MjtServiceBaseVC

@end

///待开工
@interface MjtServiceWorkingVC : MjtServiceBaseVC

@end

///待验收
@interface MjtServiceCheckingVC : MjtServiceBaseVC

@end

///待评价
@interface MjtServicePricingVC : MjtServiceBaseVC

@end




NS_ASSUME_NONNULL_END
