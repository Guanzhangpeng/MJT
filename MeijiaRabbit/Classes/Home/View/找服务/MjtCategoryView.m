//
//  MjtCategoryView.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/5/7.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtCategoryView.h"
#import "MjtFindServiceModel.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
@interface MjtCategoryView()
@property (nonatomic, strong) UIImageView *oldImg;//装修前
@property (nonatomic, strong) UIImageView *newdImg;//装修后
@end
@implementation MjtCategoryView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self _setupSubviews];
        [self addGestureRecognizer:({
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
            tapGes;
        })];
    }
    return self;
}
- (void)_setupSubviews{
    UIImageView *oldImg = [[UIImageView alloc] init];
    oldImg.contentMode =  UIViewContentModeScaleAspectFill;
    
    oldImg.clipsToBounds = YES;
    oldImg.layer.cornerRadius = 5;
    [self addSubview:oldImg];
    self.oldImg = oldImg;
    
    UIImageView *newdImg = [[UIImageView alloc] init];
    newdImg.contentMode =  UIViewContentModeScaleAspectFill;
    newdImg.clipsToBounds = YES;
    newdImg.layer.cornerRadius = 5;
    [self addSubview:newdImg];
    self.newdImg = newdImg;
    
    [oldImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_centerX).with.offset(-8);
    }];
    
    [newdImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.and.bottom.mas_equalTo(self);
        make.width.mas_equalTo(self.mas_width).with.multipliedBy(0.5);
    }];
}
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self;
}
-(void)setModel:(MjtFindServiceModel *)model{
    _model = model;
    if (model.images.count == 2) {
        [self.oldImg sd_setImageWithURL:[NSURL URLWithString:model.images[0]]];
        [self.newdImg sd_setImageWithURL:[NSURL URLWithString:model.images[1]]];
    }
}
- (void)tapClick{
    !_tapAction ? :_tapAction();
}
@end
