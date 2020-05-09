//
//  MjtCategoryView.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/5/7.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCategoryListContainerView.h"
NS_ASSUME_NONNULL_BEGIN
@class MjtFindServiceModel;
@interface MjtCategoryView : UIView<JXCategoryListContentViewDelegate>
@property (nonatomic, strong) MjtFindServiceModel *model;
@property (nonatomic, strong) void(^tapAction)();
@end

NS_ASSUME_NONNULL_END
