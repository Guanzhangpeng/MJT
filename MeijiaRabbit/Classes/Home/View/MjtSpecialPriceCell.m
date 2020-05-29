



//
//  MyCell.m
//  WMZBanner
//
//  Created by wmz on 2019/9/6.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "MjtSpecialPriceCell.h"
#import "Masonry.h"
@implementation MjtSpecialPriceCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self _setupSubviews];
        [self _makeSubviewConstraints];
       
        
    }
    return self;
}
- (void)_setupSubviews{
    ///配图
   UIImageView *iconImg = [[UIImageView alloc] init];
   iconImg.contentMode = UIViewContentModeScaleAspectFill;
   iconImg.layer.cornerRadius = 8;
   iconImg.layer.masksToBounds = YES;
   [self.contentView addSubview:iconImg];
    self.iconImg = iconImg;
    
    ///标题
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.font = [UIFont boldSystemFontOfSize:14];
    titleLbl.numberOfLines = 2;
    titleLbl.textColor = MJTColorFromHexString(@"#333333");
    [self.contentView addSubview:titleLbl];
    self.titleLbl = titleLbl;
    
    ///原价
    UILabel *originalPriceLbl = [[UILabel alloc] init];
    originalPriceLbl.font = [UIFont boldSystemFontOfSize:10];
    originalPriceLbl.textColor = MJTColorFromHexString(@"#333333");
    [self.contentView addSubview:originalPriceLbl];
    self.originalPriceLbl = originalPriceLbl;
   
    
    ///现价
    UILabel *currentPricelLbl = [[UILabel alloc] init];
    currentPricelLbl.font = [UIFont boldSystemFontOfSize:14];
    currentPricelLbl.textColor = MJTColorFromHexString(@"#FF0202");
    [self.contentView addSubview:currentPricelLbl];
    self.currentPricelLbl = currentPricelLbl;
    
    ///标签
    UILabel *tagLabel = [[UILabel alloc] init];
    tagLabel.font = [UIFont boldSystemFontOfSize:11];
    tagLabel.textColor = MJTColorFromHexString(@"#4295DC");
    [self.contentView addSubview:tagLabel];
    self.tagLabel = tagLabel;
}
- (void)_makeSubviewConstraints{
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-40);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self.iconImg.mas_bottom);
        make.right.mas_equalTo(self.originalPriceLbl.mas_left).with.offset(0);
    }];
    
    [self.currentPricelLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self.iconImg.mas_bottom);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    [self.originalPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.currentPricelLbl.mas_left).offset(-2);
        make.top.mas_equalTo(self.iconImg.mas_bottom);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self.titleLbl.mas_bottom);
        make.height.mas_equalTo(15);
    }];
}
@end
