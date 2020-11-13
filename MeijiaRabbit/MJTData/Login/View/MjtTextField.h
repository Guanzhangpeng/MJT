//
//  MjtTextField.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/11.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MjtTextField : UIView

@property (nonatomic, strong) NSString *placeholder;

@property (nonatomic, strong) NSString *text;
@property(nonatomic)        UITextFieldViewMode  clearButtonMode;
@property(nonatomic) UIKeyboardType keyboardType;
@property(nonatomic,getter=isSecureTextEntry) BOOL secureTextEntry; 
@end

NS_ASSUME_NONNULL_END
