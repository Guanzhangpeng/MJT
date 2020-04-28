//
//  MjtUserInfoEditVC.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/27.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MjtUserInfoEditVC : MjtBaseViewController

@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic, strong) void(^avatarAction)(NSString *avatarPath);
@property (nonatomic, strong) void(^nickNameAction)(NSString *nickName);
@end

NS_ASSUME_NONNULL_END
