//
//  MjtWebView.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/12.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface MjtWebView : MjtBaseViewController

@property (nonatomic, strong) NSString *hideNav;

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *showPhotoBrowser;

@property (nonatomic, strong) NSString *isShowClose;
@property (nonatomic, strong) void(^payAction)();

@end

NS_ASSUME_NONNULL_END
