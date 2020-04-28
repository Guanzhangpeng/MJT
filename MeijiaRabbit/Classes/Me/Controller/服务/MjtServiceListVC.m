//
//  MjtServiceListVC.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/16.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtServiceListVC.h"
#import "MjtServiceAllVC.h"
#import "ZPSegmentView.h"

@interface MjtServiceListVC ()

@end

@implementation MjtServiceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setup];
    [self _setupSubviews];
}
- (void)_setup{
    self.title = @"服务订单";
    self.view.backgroundColor = MJTGlobalGrayBackgroundColor;
}
- (void)_setupSubviews{
    [self _setupHeadView];
}
#pragma mark -- setup headView
- (void)_setupHeadView{
    ZPSegmentBarStyle * style=[[ZPSegmentBarStyle alloc] init];
    style.isScrollEnabled = NO;
    style.isShowBottomLine = YES;
    style.segmentBarHeight = 44.f;
    style.isNeedScale = NO;
    style.titleHeight = 44.f;
    style.isShowCover = NO;
    style.bottomLineColor = MJTGlobalMainColor;
    style.normalColor = [UIColor darkGrayColor];
    style.selecteColor = MJTGlobalMainColor;
    style.titleViewBG = [UIColor whiteColor];
    style.titleFont = [UIFont systemFontOfSize:16];
    
    NSArray *titleArray = @[@"全部",@"待付款",@"待开工",@"待验收",@"待评价"];
    NSArray *vcs = @[[MjtServiceAllVC new],[MjtServicePayingVC new],[MjtServiceWorkingVC new],[MjtServiceCheckingVC new],[MjtServicePricingVC new],];
    ZPSegmentView * segmentView=[[ZPSegmentView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [segmentView setupWithtitles:titleArray style:style childVcs:vcs parentVc:self];
    [self.view addSubview:segmentView];
}
@end
