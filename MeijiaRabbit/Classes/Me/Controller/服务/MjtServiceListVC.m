//
//  MjtServiceListVC.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/16.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtServiceListVC.h"
#import "MjtServiceAllVC.h"
#import "JXCategoryView.h"

@interface MjtServiceListVC ()<JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *myCategoryView;
@end

@implementation MjtServiceListVC

- (void)viewDidLoad {
    if (self.titles == nil) {
        self.titles = @[@"全部",@"待付款",@"待开工",@"待验收",@"待评价"];
    }
    
    [super viewDidLoad];
    [self _setup];
    self.myCategoryView.titles = self.titles;
//    self.myCategoryView.titleSelectedColor = MJTGlobalMainColor;
    self.myCategoryView.backgroundColor = [UIColor whiteColor];
    self.myCategoryView.titleColorGradientEnabled = YES;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorWidth = 20;//JXCategoryViewAutomaticDimension;
//    lineView.lineStyle = JXCategoryIndicatorLineStyle_Lengthen;
    self.myCategoryView.indicators = @[lineView];
}
- (void)_setup{
    self.title = @"服务订单";
    self.view.backgroundColor = MJTGlobalGrayBackgroundColor;
}

- (JXCategoryTitleView *)myCategoryView {
    return (JXCategoryTitleView *)self.categoryView;
}

- (JXCategoryBaseView *)preferredCategoryView {
    return [[JXCategoryTitleView alloc] init];
}
#pragma mark - JXCategoryListContainerViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    MjtServiceBaseVC *list = [[MjtServiceBaseVC alloc] init];
    list.orderType = index;
    return list;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}

@end
