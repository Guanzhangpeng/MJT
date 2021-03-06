//
//  MjtMessageBaseVC.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/10.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtMessageBaseVC.h"
#import "MjtMessageListVC.h"
#import "JXCategoryView.h"
@interface MjtMessageBaseVC ()<JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *myCategoryView;
@end

@implementation MjtMessageBaseVC

- (void)viewDidLoad {
    if (self.titles == nil) {
        self.titles = @[@"系统消息",@"服务消息"];
    }
    [super viewDidLoad];
    [self _setup];
    self.myCategoryView.titles = self.titles;
    self.myCategoryView.backgroundColor = [UIColor whiteColor];
    self.myCategoryView.titleColorGradientEnabled = YES;
     self.myCategoryView.titleLabelZoomEnabled = YES;
       self.myCategoryView.titleSelectedColor = MJTColorFromHexString(@"#22354B");
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorWidth = 20;
    lineView.verticalMargin = 4;
    lineView.indicatorColor = MJTColorFromHexString(@"#22354B");
    self.myCategoryView.indicators = @[lineView];
}

- (void)_setup{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"消息中心";
}

- (JXCategoryTitleView *)myCategoryView {
    return (JXCategoryTitleView *)self.categoryView;
}

- (JXCategoryBaseView *)preferredCategoryView {
    return [[JXCategoryTitleView alloc] init];
}
#pragma mark - JXCategoryListContainerViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    MjtMessageListVC *list = [[MjtMessageListVC alloc] init];
    list.messageType = index + 1;
    return list;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}
@end
