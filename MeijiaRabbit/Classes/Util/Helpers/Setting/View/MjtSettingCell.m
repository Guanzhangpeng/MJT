//
//  MjtSettingCell.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/12.
//  Copyright © 2020 管章鹏. All rights reserved.
//

//功能图片到左边界的距离
#define XBFuncImgToLeftGap 15

//功能名称字体
#define XBFuncLabelFont 14

//功能名称到功能图片的距离,当功能图片funcImg不存在时,等于到左边界的距离
#define XBFuncLabelToFuncImgGap 15

//指示箭头或开关到右边界的距离
#define XBIndicatorToRightGap 15

//详情文字字体
#define XBDetailLabelFont 12

//详情到指示箭头或开关的距离
#define XBDetailViewToIndicatorGap 13

#import "MjtSettingCell.h"
#import "MjtSettingItemModel.h"
#import "Masonry.h"
@interface MjtSettingCell()

@property (nonatomic, strong) UILabel *funcNameLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIImageView *imgView;
//@property (nonatomic, strong) UIImageView *indicator;
@property (nonatomic, strong) UISwitch *aswitch;


@end
@implementation MjtSettingCell

- (void)setItem:(MjtSettingItemModel *)item
{
    _item = item;
    [self updateUI];
}
- (void)updateUI
{
//    self.backgroundColor = MJTRandomColor;
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //功能图片
    if (self.item.img) {
        [self setupImgView];
    }
    //功能名称
    if (self.item.funcName) {
        [self setupFuncLabel];
    }

    //accessoryType
    if (self.item.accessoryType) {
        [self setupAccessoryType];
    }
    //detailView
    if (self.item.detailText) {
        [self setupDetailText];
    }
    
    if (self.item.detailImage) {
        [self setupDetailImage];
    }

    //bottomLine
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 1, ScreenWidth, 1)];
    line.backgroundColor = MJTColor(234, 234, 234);
    [self.contentView addSubview:line];
    self.bottomLine = line;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.funcNameLabel.centerY = self.contentView.centerY;
    _indicator.centerY = self.contentView.centerY;
    _aswitch.centerY = self.contentView.centerY;
    _detailLabel.centerY = self.contentView.centerY;
    _detailImageView.centerY = self.contentView.centerY;
    _imgView.centerY = self.contentView.centerY;
    _bottomLine.y = self.height - 1;
}
-(void)setupDetailImage
{
    self.detailImageView = [[UIImageView alloc] initWithImage:self.item.detailImage];
    self.detailImageView.contentMode = UIViewContentModeScaleAspectFill;
    switch (self.item.accessoryType) {
        case MJTSettingAccessoryTypeNone:
            self.detailImageView.x = ScreenWidth - self.detailImageView.width - XBDetailViewToIndicatorGap - 2;
            break;
        case MJTSettingAccessoryTypeDisclosureIndicator:
            self.detailImageView.x = self.indicator.x - self.detailImageView.width - XBDetailViewToIndicatorGap;
            break;
        case MJTSettingAccessoryTypeSwitch:
            self.detailImageView.x = self.aswitch.x - self.detailImageView.width - XBDetailViewToIndicatorGap;
            break;
        default:
            break;
    }
    [self.contentView addSubview:self.detailImageView];
}

- (void)setupDetailText
{
    self.detailLabel = [[UILabel alloc]init];
    self.detailLabel.text = self.item.detailText;
    self.detailLabel.textColor = MJTColor(142, 142, 142);
    self.detailLabel.font = [UIFont systemFontOfSize:XBDetailLabelFont];
    self.detailLabel.size = [self sizeForTitle:self.item.detailText withFont:self.detailLabel.font];
//    self.detailLabel.centerY = self.contentView.centerY;
    
    switch (self.item.accessoryType) {
        case MJTSettingAccessoryTypeNone:
            self.detailLabel.x = ScreenWidth - self.detailLabel.width - XBDetailViewToIndicatorGap - 2;
            break;
        case MJTSettingAccessoryTypeDisclosureIndicator:
            self.detailLabel.x = self.indicator.x - self.detailLabel.width - XBDetailViewToIndicatorGap;
            break;
        case MJTSettingAccessoryTypeSwitch:
            self.detailLabel.x = self.aswitch.x - self.detailLabel.width - XBDetailViewToIndicatorGap;
            break;
        default:
            break;
    }
    
    [self.contentView addSubview:self.detailLabel];
}


- (void)setupAccessoryType
{
    switch (self.item.accessoryType) {
        case MJTSettingAccessoryTypeNone:
            break;
        case MJTSettingAccessoryTypeDisclosureIndicator:
            [self setupIndicator];
            break;
        case MJTSettingAccessoryTypeSwitch:
            [self setupSwitch];
            break;
        default:
            break;
    }
}

- (void)setupSwitch
{
    [self.contentView addSubview:self.aswitch];
}

- (void)setupIndicator
{
    [self.contentView addSubview:self.indicator];
    
}

- (void)setupImgView
{
    self.imgView = [[UIImageView alloc]initWithImage:self.item.img];
    self.imgView.x = XBFuncImgToLeftGap;
    self.imgView.centerY = self.contentView.centerY;
    [self.contentView addSubview:self.imgView];
}

- (void)setupFuncLabel
{
    self.funcNameLabel = [[UILabel alloc]init];
    self.funcNameLabel.text = self.item.funcName;
    self.funcNameLabel.textColor = MJTColor(51, 51, 51);
    self.funcNameLabel.font = [UIFont systemFontOfSize:XBFuncLabelFont];
    self.funcNameLabel.size = [self sizeForTitle:self.item.funcName withFont:self.funcNameLabel.font];
//    self.funcNameLabel.centerY = self.contentView.centerY;
    self.funcNameLabel.x = CGRectGetMaxX(self.imgView.frame) + XBFuncLabelToFuncImgGap;
    [self.contentView addSubview:self.funcNameLabel];
}

- (CGSize)sizeForTitle:(NSString *)title withFont:(UIFont *)font
{
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : font}
                                           context:nil];
    
    return CGSizeMake(titleRect.size.width,
                      titleRect.size.height);
}

- (UIImageView *)indicator
{
    if (!_indicator) {
        _indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-arrow1"]];
//        _indicator.centerY = self.contentView.centerY;
        _indicator.x = ScreenWidth - _indicator.width - XBIndicatorToRightGap;
    }
    return _indicator;
}

- (UISwitch *)aswitch
{
    if (!_aswitch) {
        _aswitch = [[UISwitch alloc]init];
//        _aswitch.centerY = self.contentView.centerY;
        _aswitch.x = ScreenWidth - _aswitch.width - XBIndicatorToRightGap;
        [_aswitch addTarget:self action:@selector(switchTouched:) forControlEvents:UIControlEventValueChanged];
    }
    return _aswitch;
}

- (void)switchTouched:(UISwitch *)sw
{
    __weak typeof(self) weakSelf = self;
    self.item.switchValueChanged(weakSelf.aswitch.isOn);
}


@end
