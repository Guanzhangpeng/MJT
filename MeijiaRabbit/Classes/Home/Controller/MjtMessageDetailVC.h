//
//  MjtMessageDetailVC.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/6/6.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MjtMessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MjtMessageDetailVC : UIViewController
@property (nonatomic, strong) void(^readAction)();
@property (nonatomic, strong) MjtMessageModel *message;
@end

NS_ASSUME_NONNULL_END
