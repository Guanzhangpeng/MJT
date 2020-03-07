//
//  STGuideView.h
//  kdzs
//
//  Created by 管章鹏 on 2019/5/17.
//  Copyright © 2019 gzp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MjtGuideView : UIView

@property (nonatomic, strong) void(^detailBlock)();

@end

NS_ASSUME_NONNULL_END
