//
//  MjtMessageBaseVC.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/10.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtMessageBaseVC.h"
#import "ZPSegmentView.h"
#import "MjtSysMessageVC.h"
#import "MjtOrderMessageVC.h"
@interface MjtMessageBaseVC ()
@property (nonatomic, strong) ZPSegmentBarStyle *style;
@property (nonatomic, strong) ZPSegmentView *segmentView;
@end

@implementation MjtMessageBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setup];
    [self _setupHeadView];
}

- (void)_setup{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"消息中心";
}
#pragma mark -- setup headView
- (void)_setupHeadView{
    ZPSegmentBarStyle * style=[[ZPSegmentBarStyle alloc] init];
    style.titleViewBG=[UIColor whiteColor];//导航条背景颜色,默认为紫色;
    style.normalColor = [UIColor blackColor];
    style.selecteColor = MJTGlobalMainColor;
    style.isScrollEnabled = NO;
    style.isShowBottomLine = YES;
    style.bottomLineColor = MJTGlobalMainColor;
//    style.isShowImage = YES;
//    style.imageNames = @[@"message_sys",@"message_tz"];
//    style.selectedImageNames = @[@"message_sys_h",@"message_tz_h"];
//    style.imageSize = CGSizeMake(40.f, 40.f);
    style.segmentBarHeight = 44.f;
    style.isNeedScale = NO;
    style.isShowDot = YES;
    style.titleHeight = 44.f;
    style.isShowCover = NO;
    style.titleFont = [UIFont systemFontOfSize:16];
    style.dotStates = @[@NO,@NO];
    
    NSArray *titleArray = @[@"系统消息",@"服务消息"];
    NSArray *childVCArray = @[[[MjtSysMessageVC alloc] init],[[MjtOrderMessageVC alloc] init]];
    
    ZPSegmentView * segmentView=[[ZPSegmentView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [segmentView setupWithtitles:titleArray style:style childVcs:childVCArray parentVc:self];
    [self.view addSubview:segmentView];
    
    self.style = style;
    self.segmentView = segmentView;
    
}
@end
