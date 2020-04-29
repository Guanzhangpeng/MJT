//
//  MjtAddressCell.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/19.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtAddressCell.h"
#import "Masonry.h"
#import "YWAddressInfoModel.h"
@interface MjtAddressCell()

@property (nonatomic, weak) UILabel *nameLbl;
@property (nonatomic, weak) UILabel *phoneLbl;
@property (nonatomic, weak) UILabel *addressLbl;
@property (nonatomic, weak) UIButton *editBtn;
@property (nonatomic, weak) UIView *bottomLine;

@end
@implementation MjtAddressCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        [self _setupSubViews];
    }
    return self;
}
- (void)_setupSubViews{
    UILabel *nameLbl = [[UILabel alloc] init];
    nameLbl.font = [UIFont boldSystemFontOfSize:15];
    nameLbl.textColor = [UIColor blackColor];
    [self.contentView addSubview:nameLbl];
    self.nameLbl = nameLbl;
    
    UILabel *phoneLbl = [[UILabel alloc] init];
    phoneLbl.font = [UIFont boldSystemFontOfSize:14];
    phoneLbl.textColor = [UIColor blackColor];
    [self.contentView addSubview:phoneLbl];
    self.phoneLbl = phoneLbl;
    
    UILabel *addressLbl = [[UILabel alloc] init];
    addressLbl.font = [UIFont systemFontOfSize:11];
    addressLbl.textColor = [UIColor lightGrayColor];
    addressLbl.numberOfLines = 0;
    [self.contentView addSubview:addressLbl];
    self.addressLbl = addressLbl;
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(_editAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:editBtn];

    self.editBtn = editBtn;
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = MJTGlobalGrayBackgroundColor;
    [self.contentView addSubview:bottomLine];
    self.bottomLine = bottomLine;
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(100);
    }];
    
    [self.phoneLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLbl.mas_right);
        make.width.mas_equalTo(150);
        make.centerY.mas_equalTo(self.nameLbl.mas_centerY);
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right).offset(-5);
        make.width.mas_equalTo(32);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.nameLbl.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [self.addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLbl.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.nameLbl.mas_left);
        make.right.mas_equalTo(self.editBtn.mas_left).with.offset(-10);
    }];
}
-(void)setModel:(YWAddressInfoModel *)model{
    _model = model;
    self.nameLbl.text = model.name;
    self.phoneLbl.text = model.phone;
    self.addressLbl.text = [NSString stringWithFormat:@"%@%@",model.areaAddress,model.house_number];
}

- (void)_editAddress{
    !_editAddressAction ?  :_editAddressAction();
}
@end
