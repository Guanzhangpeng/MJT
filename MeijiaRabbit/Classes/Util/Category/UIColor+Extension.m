//
//  UIColor+Extension.m
//  HuangtaijiDingcan
//
//  Created by WangJian on 15/7/6.
//  Copyright (c) 2015年 KKStudio. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)
+ (UIColor *)colorFromHexString:(NSString *)string {
    NSString *colorString = [[string stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    //String should be 6 or 8 characters
    const NSInteger kNumberLength = 6;
    if ([colorString length] < kNumberLength) {
        return nil;
    }
    
    //strip 0X or # if it appears
    if ([colorString hasPrefix:@"0X"]) {
        colorString = [colorString substringFromIndex:2];
    }
    if ([colorString hasPrefix:@"#"]) {
        colorString = [colorString substringFromIndex:1];
    }
    if ([colorString length] != kNumberLength) {
        return nil;
    }
    
    //Separate into r, g, b substrings
    NSString *rString = [colorString substringWithRange:NSMakeRange(0, 2)];
    NSString *gString = [colorString substringWithRange:NSMakeRange(2, 2)];
    NSString *bString = [colorString substringWithRange:NSMakeRange(4, 2)];
    if (rString == nil || gString == nil || bString == nil) {
        return nil;
    }
    
    //Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:1.0f];
}
+ (UIColor *)colorWithHexColorString:(NSString *)string alpha:(CGFloat)alpha{
    NSString *colorString = [[string stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    //String should be 6 or 8 characters
    const NSInteger kNumberLength = 6;
    if ([colorString length] < kNumberLength) {
        return nil;
    }
    
    //strip 0X or # if it appears
    if ([colorString hasPrefix:@"0X"]) {
        colorString = [colorString substringFromIndex:2];
    }
    if ([colorString hasPrefix:@"#"]) {
        colorString = [colorString substringFromIndex:1];
    }
    if ([colorString length] != kNumberLength) {
        return nil;
    }
    
    //Separate into r, g, b substrings
    NSString *rString = [colorString substringWithRange:NSMakeRange(0, 2)];
    NSString *gString = [colorString substringWithRange:NSMakeRange(2, 2)];
    NSString *bString = [colorString substringWithRange:NSMakeRange(4, 2)];
    if (rString == nil || gString == nil || bString == nil) {
        return nil;
    }
    
    //Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:alpha];
}


@end
