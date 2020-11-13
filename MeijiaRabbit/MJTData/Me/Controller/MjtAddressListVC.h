//
//  MjtAddressListVC.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/18.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YWAddressInfoModel;
@interface MjtAddressListVC : MjtBaseViewController
@property (nonatomic, strong) void(^choseAction)(YWAddressInfoModel *addressModel);
@end

NS_ASSUME_NONNULL_END
