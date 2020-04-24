//
//  MjtTextField.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/11.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtTextField.h"
#import "Masonry.h"

@interface MjtTextField()
@property (nonatomic, weak) UITextField *txtField;
@property (nonatomic, weak) UIView *grayLine;

@end
@implementation MjtTextField

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self _setupSubviews];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.txtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];

    [self.grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.txtField.mas_bottom).with.offset(5);
        make.left.mas_equalTo(-5);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}
- (void)_setupSubviews{
    UITextField *txtField = [[UITextField alloc] init];
    txtField.borderStyle = UITextBorderStyleNone;
    txtField.font = [UIFont systemFontOfSize:14];
    [self addSubview:txtField];
    self.txtField = txtField;
    
    UIView *grayLine = [[UIView alloc] init];
    grayLine.backgroundColor = MJTColorFromHexString(@"#DBD8D8");
    [self addSubview:grayLine];
    self.grayLine =grayLine;
    
}
-(void)setPlaceholder:(NSString *)placeHolder{
    _placeholder = placeHolder;
    self.txtField.placeholder = placeHolder;
}
@end
