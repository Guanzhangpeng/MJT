//
//  MjtRecommendView.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/7.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtRecommendView.h"
#import "Masonry.h"

@implementation MjtRecommendView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self _setupSubviews];
        [self _makeSubviewsConstraints];
    }
    return self;
}
- (void)_setupSubviews{
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.bounds];
    bgImgView.layer.cornerRadius = 8.f;
    bgImgView.layer.masksToBounds = YES;
    [self addSubview:bgImgView];
    self.bgImgView = bgImgView;
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.font = [UIFont boldSystemFontOfSize:15];
    titleLbl.textColor = [UIColor whiteColor];
    [self addSubview:titleLbl];
    self.titleLbl = titleLbl;
    
    UILabel *detailLbl = [[UILabel alloc] init];
    detailLbl.font = [UIFont boldSystemFontOfSize:13];
    detailLbl.textColor = [UIColor whiteColor];
    [self addSubview:detailLbl];
    self.detailLbl = detailLbl;
    
}
- (void)_makeSubviewsConstraints{
    [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.centerY).with.offset(MJTGlobalViewTopInset);
        make.centerX.mas_equalTo(self.centerX);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.detailLbl.mas_top).with.offset(-8);
        make.centerX.mas_equalTo(self.centerX);
    }];
}
@end