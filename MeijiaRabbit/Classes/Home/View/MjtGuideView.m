//
//  STGuideView.m
//  kdzs
//
//  Created by 管章鹏 on 2019/5/17.
//  Copyright © 2019 gzp. All rights reserved.
//

#import "MjtGuideView.h"
#import "Masonry.h"
#import "MjtTipView.h"
#import "MjtButton.h"
#import "UIImageView+WebCache.h"
@interface MjtGuideView()
@property (nonatomic, strong) NSMutableArray *dataArray;
//@property (nonatomic, weak) UIImageView *adImgView;
@property (nonatomic, weak) UILabel *adTitleLabel;
@end
@implementation MjtGuideView

#define kAppViewW 60
#define kAppViewH 60
#define kColCount 5
#define kMarginX (ScreenWidth - kColCount * kAppViewW-kStartX - 12) / (kColCount - 1)
#define kStartY   0
#define kStartX   25

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"guide.json" ofType:nil];
        NSData *data =  [NSData dataWithContentsOfFile:fileName];
        _dataArray =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }
    return _dataArray;
}
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self dataArray];
    }
    return self;
}
- (void)setupUI{
    MjtTipView *tipView = [[MjtTipView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 18)];
    tipView.tipLabel.text = @"装修流程";
    [self addSubview:tipView];
    
    
    CGFloat marginY = MJTGlobalViewTopInset;
    CGFloat startY = MJTGlobalViewTopInset;
    CGFloat maxBtnY = 0;
    MjtButton *lastButton;
    for (int i = 0; i < self.dataArray.count; i++)
    {
        NSDictionary *dic = self.dataArray[i];
        MjtButton *btn = [MjtButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:dic[@"title"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:dic[@"icon"]] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        [btn setTitleColor:MJTColorFromHexString(@"#666666") forState:UIControlStateNormal];
        int row = i / kColCount;
        int col = i % kColCount;
        CGFloat x = kStartX + col * (kMarginX + kAppViewW);
        CGFloat y = CGRectGetMaxY(tipView.frame) + startY + marginY + row * (marginY + kAppViewH);
        btn.imageWH = 30;
        btn.margin = 12.f;
        btn.frame = CGRectMake(x, y, kAppViewW, kAppViewH);
        [self addSubview:btn];
        if (col != kColCount-1 && col != kColCount - 2){
            UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame) + kMarginX/2 - 2, y +15, 4, 6)];
            arrowView.image = [UIImage imageNamed:@"home_guid_arrow"];
            [self addSubview:arrowView];
        }
        if(i == self.dataArray.count -1){
            maxBtnY = CGRectGetMaxY(btn.frame);
            lastButton = btn;
        }
    }
    MjtBaseButton *detailBtn = [MjtBaseButton buttonWithType:UIButtonTypeCustom];
//    [detailBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    detailBtn.titleLabel.font = [UIFont systemFontOfSize:11];
//    [detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
//    detailBtn.backgroundColor = MJTGlobalMainColor;
//    detailBtn.layer.cornerRadius = 10;
//    [detailBtn setBackgroundImage:[UIImage imageNamed:@"home_guide_bg"] forState:UIControlStateNormal];
    [detailBtn setImage:[UIImage imageNamed:@"home_more"] forState:0];
    [detailBtn addTarget:self action:@selector(detailClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:detailBtn];

    [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-MJTGlobalViewLeftInset);
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(21);
        make.centerY.mas_equalTo(lastButton.mas_centerY).offset(-10);
    }];
}
- (void)detailClick{
    !_detailBlock ?  :_detailBlock();
}

@end
