//
//  UIColor+Extension.h
//  HuangtaijiDingcan
//
//  Created by WangJian on 15/7/6.
//  Copyright (c) 2015年 KKStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (UIColor *)colorFromHexString:(NSString *)string;

+ (UIColor *)colorWithHexColorString:(NSString *)string alpha:(CGFloat)alpha;

@end
