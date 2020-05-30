
//
//  MjtServiceAlertView.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/5/30.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtServiceAlertView.h"
#import "YYLabel.h"
#import "YYText.h"
#import "MjtBaseButton.h"
#import "Masonry.h"
@implementation MjtServiceAlertView
- (void)show{
    self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.7f];
    self.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 180)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.center = self.center;
    bgView.layer.cornerRadius = 8;
    [self addSubview:bgView];
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:@"您提交的服务需求可以 在“我的-服务订单”中查看进度哦！"];
    
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName
    value:[UIColor blueColor]
    range:[[mutableAttributedString string] rangeOfString:@"我的-服务订单"]];
    
    
    mutableAttributedString.yy_font = [UIFont systemFontOfSize:14];
//    mutableAttributedString.yy_color = MJTColorFromHexString(@"#333333");
    mutableAttributedString.yy_lineSpacing = 6;

    YYLabel *tipLbl = [[YYLabel alloc] initWithFrame:CGRectMake(20,25,210, 50)];
    tipLbl.numberOfLines = 0;
    tipLbl.attributedText = mutableAttributedString ;
    tipLbl.preferredMaxLayoutWidth = 210;
    [bgView addSubview:tipLbl];

    MjtBaseButton *okBtn = [MjtBaseButton buttonWithType:UIButtonTypeCustom];
    [okBtn setTitle:@"我知道啦" forState:0];
    [okBtn setTitleColor:MJTColorFromHexString(@"#333333") forState:0];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    okBtn.backgroundColor = MJTGlobalMainColor;
    okBtn.layer.cornerRadius = 8;
    [okBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:okBtn];
    okBtn.frame = CGRectMake(0, 120, 90, 40);
    okBtn.centerX = 125;
}
- (void)dismiss{
    [self removeFromSuperview];
    !_dismissAction ?  :_dismissAction();
}
@end
