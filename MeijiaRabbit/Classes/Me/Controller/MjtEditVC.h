//
//  MjtEditVC.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/28.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MjtEditVC : MjtBaseViewController

@property (nonatomic, strong) void(^editAction)(NSString *editInfo);
@end

NS_ASSUME_NONNULL_END
