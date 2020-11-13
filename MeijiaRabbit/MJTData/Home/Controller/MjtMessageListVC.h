//
//  MjtMessageListVC.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/10.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "JXCategoryListContainerView.h"
#import "MjtMessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MjtMessageListVC : UIViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, assign) MJTMessageType messageType;
@end

NS_ASSUME_NONNULL_END
