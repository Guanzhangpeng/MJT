//
//  MjtServiceAlertView.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/5/30.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MjtServiceAlertView : UIView
/**显示视图**/
- (void)show;
@property (nonatomic, strong) void(^dismissAction)();
@end

NS_ASSUME_NONNULL_END
