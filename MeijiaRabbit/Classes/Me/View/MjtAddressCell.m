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
@property (nonatomic, weak) UIImageView *defaultImg;

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
    
    UIImageView *defaultImg = [[UIImageView alloc] init];
    defaultImg.image = [UIImage imageNamed:@"address_default"];
    [self.contentView addSubview:defaultImg];
    self.defaultImg = defaultImg;
    
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
    self.editBtn.backgroundColor = [UIColor redColor];

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
        make.width.mas_equalTo(85);
    }];
    
    [self.phoneLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLbl.mas_right);
        make.width.mas_equalTo(90);
        make.centerY.mas_equalTo(self.nameLbl.mas_centerY);
    }];
    
    [self.defaultImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneLbl.mas_right).with.offset(10);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(32);
        make.centerY.mas_equalTo(self.nameLbl.mas_centerY);
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right).offset(-5);
        make.width.mas_equalTo(50);
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
    self.phoneLbl.text = [model.phone stringByReplacingCharactersInRange:NSMakeRange(model.phone.length -8, 4) withString:@"****"];//防止号码有前缀所以使用倒数第8位开始替换;
      
    self.addressLbl.text = model.detail_address;//[NSString stringWithFormat:@"%@%@",model.address,model.house_number];
    
    if ([model.default_address isEqualToString:@"1"]) {
        self.defaultImg.hidden = NO;
        !_defaultAddressBlock ? :_defaultAddressBlock();
    }else{
        self.defaultImg.hidden = YES;
    }
}

- (void)_editAddress{
    !_editAddressAction ?  :_editAddressAction();
}
@end
