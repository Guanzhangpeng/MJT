//
//  MjtView.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/6.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtView.h"
#import "Masonry.h"
@implementation MjtView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self _setup];
        [self _setupSubviews];
    }
    return self;
}
- (void)_setup{
    [self addGestureRecognizer:({
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapClick)];
        tapGes;
    })];
}
- (void)_setupSubviews{

       UIImageView *bgView;
       [self addSubview:({
           bgView = [[UIImageView alloc] init];
           bgView;
       })];
       [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.edges.mas_equalTo(self);
       }];
    self.bgView = bgView;
    
           /// DIY家装设计
           UILabel *textLabel;
           [self addSubview:({
               textLabel = [[UILabel alloc] initWithFrame:CGRectMake(MJTGlobalViewLeftInset, MJTGlobalViewLeftInset, 120, 22)];
               textLabel.textColor = [UIColor blackColor];
               textLabel.font = [UIFont systemFontOfSize:15];
               textLabel;
           })];
    self.textLabel = textLabel;
           
           /// DIY自己动手设计家
           UILabel *detailtextLabel;
           [self addSubview:({
               detailtextLabel = [[UILabel alloc] initWithFrame:CGRectMake(MJTGlobalViewLeftInset, CGRectGetMaxY(textLabel.frame), 120, 16)];
               detailtextLabel.font = [UIFont systemFontOfSize:10];
               detailtextLabel;
           })];
    self.detailtextLabel = detailtextLabel;
           
           /// DIY自己动手设计家
           UIImageView *iconView;
           [self addSubview:({
               iconView = [[UIImageView alloc] init];
               iconView;
           })];
    self.iconView = iconView;
}
- (void)_tapClick{
    !_clickBlock? :_clickBlock();
}
@end
