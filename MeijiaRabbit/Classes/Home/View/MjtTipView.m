//
//  MjtTipView.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/6.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtTipView.h"
#import "Masonry.h"

@implementation MjtTipView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self _setupSubviews];
        
    }
    return self;
}
- (void)_setupSubviews{
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:({
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        tapGes;
    })];
    //tipLabel
    UILabel *tipLabel;
    [self addSubview:({
        tipLabel = [[UILabel alloc] init];
        tipLabel.textColor = MJTColorFromHexString(@"#333333");
        tipLabel.font = [UIFont boldSystemFontOfSize:15];
        tipLabel;
    })];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.top.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
    }];
    self.tipLabel = tipLabel;
    
    //分割线
    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = MJTColorFromHexString(@"#FFCE00");
    [self addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(2);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(tipLabel.mas_left).offset(-15);
    }];
    
    //分割线
    UIView *rightView = [[UIView alloc] init];
    rightView.backgroundColor = MJTColorFromHexString(@"#FFCE00");
    [self addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(2);
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(tipLabel.mas_right).offset(15);
    }];
}
#pragma mark -- 点击事件
- (void)tapClick{
    !_tapAction ? :_tapAction();
}
@end
